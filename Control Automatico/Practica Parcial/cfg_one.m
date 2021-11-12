clc; clear all;
syms u;
syms x1; %i
syms x2; %y
syms x3; %dy/dt
syms u;
m = 1;
g = 10;
L0 = g/4;
R = 1;
L = 100e-3;
alfa = pi/4;

x = [x1 x2 x3];

x1dot = -x1*(R/L)+u*(1/L);
x2dot = x3;
x3dot = (-L0/(2*m))*(x1^2/x2^2) + g*sin(alfa);

fxu = [x1dot x2dot x3dot];

x2_eq = 1;
x3_eq = 0;

x1_eq = solve(subs(fxu(3), x2, x2_eq));

u_eq = double(solve(subs(fxu(1), x1, x1_eq(2))));

x1_eq = double(x1_eq(2));

A = jacobian(fxu, [x1 x2 x3]);
B = jacobian(fxu, u);

x1 = x1_eq;
x2 = x2_eq;
x3 = x3_eq;
u = u_eq;

A = eval(simplify(A));
B = eval(simplify(B));
C = [0 1 0];
D = 0;

s = tf('s');

sys=ss(A,B,C,D);
P = tf(sys);

eig(A);
%Podemos observar que hay un RHP pole entonces no es bibo estable,
%entonces, tenemos como limitacion del diseño que la frecuencia de cruce
%sea más rápida que 1.7 veces la frecuencia del polo inestable. w_cruce >
%6.4rad/s. Entonces elegimos una frecuencia de cruce de 20rad/s.

Pmp=59.46/((s+10)*(s+3.761)^2)
Pap = -(s+3.761)/(s-3.761)



Control= -(1/Pmp)*(1/s)*(1/(s+100))^3*(s+20)*db2mag(105+8.39)



%rlocus(Pmp*Pap*Control)






% Pmp = -59.46/((s+10)*(s+3.761)^2);
% Pap = (s+3.761)/(s-3.761);
% 
% Contr = db2mag(145)*((1/Pmp)*(1/s^2)*(s+1)/((s+1000)^2));
% 
% L = minreal(P*Contr);
% bode(L); %Queda ajustado a MF=60 con 40db/dec de atenuacion antes y despues de w_cruce y 20db/dec en la w_cruce. w_cruce = 17 rad/s.
% T = 0.01;
% pade_raro = (1-(T/2)*s)/(1+(T/2)*s);
% 
% L = minreal(P*pade_raro*Contr);
% margin(L);
% %De manera iterativa se consigue que con 0.01 el retraso de fase
% %introducido al sistema es casi de 10 grados, quedando MF = 50.
% 
% rank(ctrb(A,B)) %El rango de la matriz ctrb es 3 que es igual a la dimension del espacio columna de A -> es controlable.
% 
% K = acker(A, B, [-20 -20 -200]);
% A_cl = (A-B*K);
% sys_cl = ss(A_cl, B, C, D);
% 

Q=diag([1 1 1e-100 1])
R=1e-6

Ka = lqi(sys,Q,R)

K_lqr=Ka(1:3)
Ki_lqr = Ka(end)


eig(A-B*K_lqr)