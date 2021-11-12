clc;clear all;
syms x1 x2 x3 u

R=4;
L=1;
m=0.2;
g=10;


F1=0.5*(((2+x3)^2)/((1-x1)^2));
F2=0.5*(((2-x3)^2)/((1+x1)^2));
x2_dot = -g+(F1-F2)/m;
x1_dot = x2;
x3_dot = -(x3*abs(x3))/(L/R)+u/L;
y=x1;

X_dot=[x1_dot;x2_dot;x3_dot];
X=[x1;x2;x3];
Y=[y];

%calculo de punto de equilibrio

x1_eq=0;
x2_eq = 0;
x3_eq = double(solve(subs(x2_dot,x1,x1_eq)));
u_eq = double(solve(subs(x3_dot,x3,x3_eq)));
y_eq=x1_eq;

%Linealizamos

A = jacobian(X_dot,X);
B = jacobian(X_dot,u);
C = jacobian(Y,X);
D = jacobian(Y,u);

A = double(subs(A,{x1,x2,x3,u},{x1_eq,x2_eq,x3_eq,u_eq}))
B = double(subs(B,{x1,x2,x3,u},{x1_eq,x2_eq,x3_eq,u_eq}))
C = double(subs(C,{x1,x2,x3,u},{x1_eq,x2_eq,x3_eq,u_eq}));
D = double(subs(D,{x1,x2,x3,u},{x1_eq,x2_eq,x3_eq,u_eq}));

eig(A)

%realimentacion de estados
K = acker(A,B,[-20 -20 -20])
eig(A-B*K)

Aa = [A zeros(3,1);-C 0]
Ba=[B;D]
Ki=acker(Aa,Ba,[-20 -20 -20 -20])
Ksr = Ki(1:3)
Ki = Ki(end)

%observador de estados con control integral
L=(acker(A',C',[-200 -200 -200]))'