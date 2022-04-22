clear all; clc; 

%Constantes de simulink

M = 0.5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
L = 0.3;
l = L/2;

L1 = L;
L2 = L;
l1 = l;
l2 = l;
m1 = m;
m2 = m;
I1 = 0; %(m1*L1^2)/12;
I2 = 0; %(m2*L2^2)/12;

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

A = [ zeros(3,3), eye(3);
    [ zeros(3,1), -1*inv_d0*jacobian_g0, zeros(3)] ];

B = [ 0;
      0;
      0;
     inv_d0*H ];

Ad = [A(:,1) A(:,4) A(:,2) A(:,5) A(:,3) A(:,6)];
Ad = [Ad(1,:); -1.*Ad(4,:); Ad(2,:); Ad(5,:); Ad(3,:); Ad(6,:)]
%Ad(:,3) = Ad(:,3)./2;
%Ad(2,:) = -1.*Ad(2,:);

Bd = [B(1); B(4); B(2); -1*B(5); B(3); -1*B(6)]
%Bd(4,:) = Bd(4,:).*(-1);
%Bd(6,:) = Bd(6,:).*(2);

Cd = [1 0 0 0 0 0];

Dd = 0;

%% Transferencias Pendulo Doble

[num, den] = ss2tf(Ad,Bd,[0 0 1 0 0 0],0); Tt1d = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 0 0 0 1 0],0); Tt2d = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[1 0 0 0 0 0],0); Tcd = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(Ad)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(Ad,Bd)))])    %Es controlable
disp(['Observabilidad pendulo simple: ' num2str(rank(obsv(Ad,Cd)))])    %Se puede estimar las variables de estado observando la posición

%% Realimentacion de estados y observador Pendulo Doble

pKd = [-5 -10 -10 -1 -15 -15];
Kd = acker(Ad, Bd, pKd)

pLd = pKd.*10;
Ld = (acker(Ad', Cd', pLd))'

%%

% 1.0e+03 *
% 
%          0    0.0010         0         0         0         0
%          0         0    0.0078         0   -0.0039         0
%          0         0         0    0.0010         0         0
%          0         0    0.2354         0   -0.3139         0
%          0         0         0         0         0    0.0010
%          0         0   -0.4709         0    1.0202         0
%          
%          
%                   0         0
%     2.0000    0.0000
%          0         0
%    26.6667    0.0000
%          0         0
%   -53.3333  -66.6667
