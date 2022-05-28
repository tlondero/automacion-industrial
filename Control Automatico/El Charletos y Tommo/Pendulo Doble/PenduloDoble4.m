clear all; clc;

simulation = 'DoublePendulum5'

if ~bdIsLoaded(simulation)   % Abro SimuLink si no está abierto
    open_system(simulation)
end

% Constantes de simulink

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

% Sistema

p1 = (m1 + 2*m2)*L1;
p2 = m2*L2;
p3 = 2*m2*L1*L2;
p4 = (m1+4*m2)*L1*L2;
p5 = m2*L1^2;

den_inv = 1/(M*p4*p5 + 2*p1*p2*p3 - (p2^2)*p4 - M*(p3^2) - (p1^2)*p5);

A42 = (p2*p3 - p1*p5)*p1;
A43 = (p1*p3 + p2*p4)*p2;
A52 = (M*p5 - p2^2)*p1;
A53 = -(M*p3 - p1*p2)*p2;
A62 = (M*p3 - p1*p2)*p1;
A63 = (M*p4 - p1^2)*p2;

Aaux = [0 A42 A43;
        0 A52 A53;
        0 A62 A63];

Ad = [zeros(3,3)        eye(3);
      Aaux.*(g*den_inv) zeros(3,3)]
  
B4 = p4*p5 - p3^2;
B5 = p1*p5 - p2*p3;
B6 = p1*p3 + p2*p4;
   
Bd = [0 0 0 B4 B5 B6]'.*den_inv

Cdo = [1 0 0 0 0 0];     % x t1 t2 x_d t1_d t2_d
Cd = eye(6);     % x t1 t2 x_d t1_d t2_d

Ddo = 0;
Dd = zeros(6,1);

%% Transferencias Pendulo Doble

[num, den] = ss2tf(Ad,Bd,[1 0 0 0 0 0],0); Tx = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 1 0 0 0 0],0); Tt1 = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 0 1 0 0 0],0); Tt2 = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(Ad)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(Ad,Bd)))])    %Es controlable
disp(['Observabilidad pendulo simple: ' num2str(rank(obsv(Ad,Cd)))])    %Se puede estimar las variables de estado observando la posición

%% Realimentacion de estados y observador Pendulo Doble

% pKd = [-15 -5 -1 -10 -25 -10];      %Con error permanente pero bastante chico
pKd = [-25 -15 -10 -10 -5 -1];
Kd = acker(Ad, Bd, pKd')

pLd = pKd.*10;
Ld = acker(Ad', Cdo', pLd)
Ld = Ld';

if exist('runSimuLink','var')   % Si esta todo inicializado corro SimuLink
    sim(simulation,10)
end

%% Analizo control integral

Aai = [Ad Bd; -Cdo Ddo];
Bai = [Bd; 0];
Cai = [Cdo 0];
Dai = Dd;

disp(['Estabilidad: ' num2str(eig(Aai)')])
disp(['Controlabilidad: ' num2str(rank(ctrb(Aai,Bai)))])   %Es controlable
disp(['Observabilidad: ' num2str(rank(obsv(Aai,Cai)))])    %Es observable

Kaid = acker(Aai, Bai, [pKd -0.1]);
%Aaicl= (Aai-Bai*Kaid);
%eig(Aaicl)
%Kd = Kaid(1:6);
Kai = -Kaid(7);

runSimuLink = 1;    % Esta todo inicializado, ahora puedo correr SimuLink
