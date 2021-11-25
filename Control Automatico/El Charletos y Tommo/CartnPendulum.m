clear all; clc; 

% Constantes para Simulink
M = 0.5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

% Modelo de estados
A = [0         1         0         0;
     0         0    3.9240         0;
     0         0         0         1;
     0         0   91.5599         0];
B = [0;
     2;
     0;
     13.3333];
C = [1 0 0 0;
    0 0 1 0];
D = [0; 0];

% Transferencias
[num, den] = ss2tf(A,B,[0 0 1 0],0); Tt = minreal(tf(num,den));
[num, den] = ss2tf(A,B,[1 0 0 0],0); Tc = minreal(tf(num,den));


disp('Estabildiad:')        %Es inestable, tengo un polo en SPD
eig(A)
disp(['Controlabilidad: ' num2str(rank(ctrb(A,B)))])    %Es controlable
disp(['Observabilidad: ' num2str(rank(obsv(A,C)))])    %Es observable

pK = [-10 -10 -15 -15];
K = acker(A, B, pK)