clear all; clc; 

%Constantes de simulink

M = 0.5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

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
  
Cd = [1 0 0 0 0 0];

Dd = 0; %zeros(6,1);

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
