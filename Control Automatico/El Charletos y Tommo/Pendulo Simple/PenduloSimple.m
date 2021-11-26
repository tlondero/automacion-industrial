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
  
Cs = [1 0 0 0];
  
Ds = 0;

%% Transferencias Pendulo Simple

[num, den] = ss2tf(As,Bs,[0 0 1 0],0); Tts = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(As,Bs,[1 0 0 0],0); Tcs = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Simple

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(As)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(As,Bs)))])    %Es controlable
disp(['Observabilidad pendulo simple: ' num2str(rank(obsv(As,Cs)))])    %Se puede estimar las variables de estado observando la posición

%% Realimentacion de estados Pendulo Simple

pKs = [-10 -10 -15 -15];
Ks = acker(As, Bs, pKs)

pLs = pKs.*10;
Ls = (acker(As', Cs', pLs))'