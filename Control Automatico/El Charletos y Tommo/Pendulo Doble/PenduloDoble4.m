clear all; clc; 

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

% Sistema

p1 = (m1 + 2*m2)*L1;
p2 = m2*L2;
p3 = 2*m2*L1*L2;
p4 = (m1+4*m2)*L1*L2;
p5 = m2*L1^2;

den = M*p4*p5 + 2*p1*p2*p3 - (p2^2)*p4 - M*(p3^2) - (p1^2)*p5;

A42 = ((p2*p3 - p1*p5)*p1*g)/den;
A43 = ((p1*p3 + p2*p4)*p2*g)/den;
A52 = ((M*p5 - p2^2)*p1*g)/den;
A53 = -((M*p3 - p1*p2)*p2*g)/den;
A62 = ((M*p3 - p1*p2)*p1*g)/den;
A63 = ((M*p4 - p1^2)*p2*g)/den;

Ad = [0 0   0   1 0 0;
      0 0   0   0 1 0;
      0 0   0   0 0 1;
      0 A42 A43 0 0 0;
      0 A52 A53 0 0 0;
      0 A62 A63 0 0 0;];

B41 = (p4*p5 - p3^2)/den;
B51 = (p1*p5 - p2*p3)/den;
B61 = (p1*p3 + p2*p4)/den;
   
Bd = [0; 0; 0; B41; B51; B61];

Cd = [1 0 0 0 0 0];

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

clc;
pKd = [-15 -5 -1 -10 -25 -10];
Kd = acker(Ad, Bd, pKd)

pLd = pKd.*10;
Ld = (acker(Ad', Cd', pLd))
Ld = Ld';
