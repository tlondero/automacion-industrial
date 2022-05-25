clear all; clc;

simulation = 'DoublePendulum4';

if ~bdIsLoaded(simulation)   % Abro SimuLink si no está abierto
    open_system(simulation)
end

%Constantes de simulink

M = 1.5;
g = 9.8;
b = 0;
l = 0.15;

L1 = 0.5;
L2 = 0.75;
l1 = L1/2;
l2 = L2/2;
m1 = 0.5;
m2 = 0.75;

I1 = (m1*L1^2)/12;
I2 = (m2*L2^2)/12;

syms t1 t2;

D = [ M+m1+m2,                  (m1*l1+m2*L1)*cos(t1),  m2*l2*cos(t2);
      (m1*l1+m2*L1)*cos(t1),    m1*(l1^2)+m2*(L1^2)+I1, m2*L1*l2*cos(t1-t2);
      m2*l2*cos(t2),            m2*L1*l2*cos(t1-t2),    m2*(l2^2)+I2];
  
G = [ 0;
      -g*(m1*l1+m2*L1)*sin(t1);
      -m2*l2*g*sin(t2)];
  
H = [1;0;0];
  
inv_d0 = inv(double(subs(D, {'t1' 't2'}, {0 0})));
jacobian_g0 = double(subs(jacobian(G, [t1 t2]), {'t1' 't2'}, {0 0}));

Ad = [ zeros(3,3), eye(3);
     [ zeros(3,1), -1*inv_d0*jacobian_g0, zeros(3)] ]

Bd = [ 0;
       0;
       0;
       inv_d0*H ]

Cd =  [1 0 0 0 0 0];

Dd = 0;

%% Transferencias Pendulo Doble

% x t1 t2 x_d t1_d t2_d

[num, den] = ss2tf(Ad,Bd,[1 0 0 0 0 0],0); Tx = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 1 0 0 0 0],0); Tt1 = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 0 1 0 0 0],0); Tt2 = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(Ad)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(Ad,Bd)))])    %Es controlable
disp(['Observabilidad pendulo simple: ' num2str(rank(obsv(Ad,Cd)))])    %Se puede estimar las variables de estado observando la posición

%% Realimentacion de estados y observador Pendulo Doble

%pKd = [-15 -5 -1 -10 -25 -10];      %Con error permanente pero bastante chico
%pKd = [-25 -15 -10 -10 -5 -1];
pKd = [1 1 1 1 1 10];
Kd = acker(Ad, Bd, pKd)

pLd = pKd.*10;
Ld = (acker(Ad', [1 0 0 0 0 0]', pLd))';

if exist('runSimuLink','var')   % Si esta todo inicializado corro SimuLink
    sim(simulation,10)
end

%% Analizo control integral

Aai = [Ad Bd; -Cd Dd];
Bai = [Bd; 0];
Cai = [Cd 0];
Dai = 0;

disp(['Estabilidad: ' num2str(eig(Aai)')])
disp(['Controlabilidad: ' num2str(rank(ctrb(Aai,Bai)))])   %Es controlable
disp(['Observabilidad: ' num2str(rank(obsv(Aai,Cai)))])    %Es observable

Kaid = acker(Aai, Bai, [pKd -0.1]);
%Aaicl= (Aai-Bai*Kaid);
%eig(Aaicl)
%Kd = Kaid(1:6);
Kai = -Kaid(7);

runSimuLink = 1;    % Esta todo inicializado, ahora puedo correr SimuLink