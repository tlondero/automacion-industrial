clear all; clc; 

%Constantes de simulink

M = 0.5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

%% Modelo de estados Pendulo Simple

As = [0         1         0         0;
     0         0    3.9240         0;
     0         0         0         1;
     0         0   91.5599         0];
Bs = [0;
     2;
     0;
     13.3333];
Cs = [1 0 0 0;
    0 0 1 0];
Ds = [0; 0];

%% Transferencias Pendulo Simple

[num, den] = ss2tf(As,Bs,[0 0 1 0],0); Tts = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(As,Bs,[1 0 0 0],0); Tcs = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Simple

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(As)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(As,Bs)))])    %Es controlable
disp(['Observabilidadpendulo simple: ' num2str(rank(obsv(As,Cs)))])    %Es observable

%% Realimentacion de estados Pendulo Simple

pKs = [-10 -10 -15 -15];
Ks = acker(As, Bs, pKs)

%% Modelo de estados Pendulo Doble

Ad = [0    1.0000         0         0         0         0;
      0         0    7.8480         0   -3.9240         0;
      0         0         0    1.0000         0         0;
      0         0  117.7199         0 -156.9592         0;
      0         0         0         0         0    1.0000;
      0         0 -235.4398         0  510.1176         0];
Bd = [0
      2.0000;
      0;
      13.3333;
      0;
      -26.6667];
Cd = eye(6);
Dd = zeros(6,1);

%% Transferencias Pendulo Doble

[num, den] = ss2tf(Ad,Bd,[0 0 1 0 0 0],0); Tt1d = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 0 0 0 1 0],0); Tt2d = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[1 0 0 0 0 0],0); Tcd = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(Ad)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(Ad,Bd)))])    %Es controlable
disp(['Observabilidadpendulo simple: ' num2str(rank(obsv(Ad,Cd)))])    %Es observable

%% Realimentacion de estados Pendulo Doble

pKd = [-5 -10 -10 -1 -15 -15];
Kd = acker(Ad, Bd, pKd)
