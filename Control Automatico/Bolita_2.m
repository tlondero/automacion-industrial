clear; clc;


%defino variables simbolicas

%Variables de estado y entradas
syms x1 x2 x3 u


%constantes del problema
g=10;
m=0.2;
L=1;
R=4;

%% Punto 1
f1 = 0.5*((2+x3)^2)/((1-x1)^2);
f2 = 0.5*((2-x3)^2)/((1+x1)^2);
disp('Punto 1, x_dot = f(x,u)')
fxu = [ x2 ; -g+(f1/m)-(f2/m) ; -abs(x3)*x3*R/L+u/L]
disp('La salida es x1 (la altura)')
%% Punto 2
A = jacobian(fxu,[x1;x2;x3]);
B = jacobian(fxu,u);

x1_eq=0;
x2_eq = 0;
x3_eq = solve(subs(fxu(2),x1,x1_eq));
u_eq = solve(subs(fxu(3),x3,x3_eq));
y_eq=x1_eq;

%Ahora que esta todo simbolico evaluo y linealizo
m=0.2;
g=10;
L=1;
R=1;

x1=double(x1_eq);
x2=double(x2_eq);
x3=double(x3_eq);
u=double(u_eq);

A = eval(simplify(A));
B = eval(simplify(B));
C = [1, 0, 0];
D = 0;

%% Punto F: Realimentacion de estados

%Verifico Observabilidad y Controlabilidad
%rank(ctrb(A,B))
%rank(obsv(A,C))
eig(A)
K = place(A, B, [-15 -3 -220]);

%% Punto F: Control Integral

%Armo el sistema ampliado
Aai=[A zeros(3,1); -C 0];
Bai = [B ; 0];
Cai = [C 0];
Dai = D;

%Verifico Observabilidad y Controlabilidad
rank(ctrb(Aai,Bai))
rank(obsv(Aai,Cai))

eig(Aai)
Kai = acker(Aai, Bai, [-200 -200 -200 -200])

Kc = Kai(1:3);
Kic = Kai(4);

%% Punto G: Observador continuo
% 
 L = (acker(A', C', [-1000 -1100 -1200]))'

%% Observador discreto


Ts = 0.0001;
sysDisc = c2d(ss(Aai,Bai,Cai,D), Ts, 'tustin');%discrete system

pCont = [-15 -15 -15 -100];%poles in s-domain
pDisc = exp(pCont.*Ts);%poles in z-domain

Kdisc = acker(sysDisc.A,sysDisc.B,pDisc)


Kd = Kdisc(1:3)
Kid = Kdisc(4)


sysasd = ss(A,B,C,D);
sysasd = c2d(sysasd, Ts, 'tustin');%discrete system
pDiscL = exp([-150 -150 -150].*Ts);%poles in z-domain
Ldisc = (acker(sysasd.A', sysasd.C', pDiscL))'