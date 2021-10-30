clc;
clear;
syms x1 x2 x3 u1;%Variables de estado

syms R L m g; %Constantes



f=[-x1*abs(x1)*R/L+u1/L;
    x3;
    -g+((0.5*(2+x1)^2)/(1-x2)^2)/m-((0.5*(2-x1)^2)/(1+x2)^2)/m];
A = jacobian(f,[x1;x2;x3])
B = jacobian(f,u1)

%Asignacion de constantes y puntos de equilibrio
R =4;
L =1;
m =0.2;
g=10;%Constantes

x1eq=m*g/4;
x2eq=0;
x3eq=0;
u1eq= m*g*R/16;


x1 = x1eq;
x2 = x2eq;
x3 = x3eq;
u1 = u1eq;

%%%%%%%%%%%%%%%%%%%%%%

A = eval(A);
B = eval(B);
C = [0 1 0];

system = ss(A,B,C,0)