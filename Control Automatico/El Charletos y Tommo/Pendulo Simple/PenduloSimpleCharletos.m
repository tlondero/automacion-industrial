clear all;clc;

syms x1 x2 x3 x4 u b k;
M = 0.5;
m = 0.2;
b = 0; % 0.1;
J = 0.000;
g = 9.8;

l = 0.3;
L =2*l;
%% Astrom y Murray equations
BF=1;
Mt=M+m;
Jt=J+m*l^2;
F = u;
%punto a
x1_dot = x2;
x3_dot = x4;
x2_dot = (-m*l*sin(x3)*x4^2+m*g*((m*l^2)/Jt)*cos(x3)*sin(x3)+F)/(Mt-m*((m*l^2)/Jt)*(cos(x3))^2);
x4_dot = (-m*l^2*sin(x3)*cos(x3)*x4^2+Mt*g*l*sin(x3)+l*cos(x3)*F)/(Jt*(Mt/m)-m*(l*cos(x3))^2);
y1=x1;
y2=x3;

X_dot=[x1_dot x2_dot x3_dot x4_dot]
X=[x1 x2 x3 x4]


Y=[y1]
%% Linealizado
x1_eq=0;
x2_eq=0;
x3_eq=0;
x4_eq=0;
X_eq=[x1_eq x2_eq x3_eq x4_eq];
u_eq = 0;

A = jacobian(X_dot,X);
B = jacobian(X_dot,u);
C = jacobian(Y,X);
D = jacobian(Y,u);



A = double(subs(A,{x1,x2,x3,x4,u},{x1_eq,x2_eq,x3_eq,x4_eq,u_eq}));
B = double(subs(B,{x1,x2,x3,x4,u},{x1_eq,x2_eq,x3_eq,x4_eq,u_eq}));
C = double(subs(C,{x1,x2,x3,x4,u},{x1_eq,x2_eq,x3_eq,x4_eq,u_eq}));
D = double(subs(D,{x1,x2,x3,x4,u},{x1_eq,x2_eq,x3_eq,x4_eq,u_eq}));
sys= ss(A, B, C, D);
tf(sys)
eig(A)
rank_A=rank(A)
rank_ctrb=rank(ctrb(A,B))
rank_obsv=rank(obsv(A,C))
%% Realimentacion de estados Pendulo Simple

pKs = [-10 -10 -10 -10];
Ks = acker(A, B, pKs)

%pLs = pKs.*5;
pLs = [-30 -30 -30 -30]
Ls = (acker(A', C', pLs))'
%% Control integral
[n,~]=size(A)
[p,~]=size(C)
Aa=[A zeros(n,p);-C zeros(p,p)];
Ba = [B; zeros(p,p)];
Bar = [0;0;0;0;1]
Ca = [C 0]

obs = det(obsv(Aa,Ca))
K2=acker(Aa,Ba,[-3 -3 -15 -15 -20])

Ks2=K2(1:end-1);
Ki2=K2(end);


% Q=diag([1, 1, 250, 10, 10]);
% R=0.1
% sys = ss(A, B, C, D)
% K2=lqi(sys,Q,R)
% Ks2=K2(1:end-1);
% Ki2=K2(end);
%% Pasando a tiempo discreto
Ts = 200e-3;
sysd=c2d(sys,Ts,'tustin')

Ad=sysd.A;
Bd=sysd.B;
Cd=sysd.C;
Dd=sysd.D;

Q=diag([1, 1, 250, 10, 10]);
R=0.1

K2d=lqi(sysd,Q,R)
Ks2d=K2d(1:end-1);
Ki2d=K2d(end);

%% Realimentacion por loop shaping continuo: theta

close all;

s = tf('s');

P_t = zpk(tf(ss(A,B,[0 0 1 0],D)))

Pap = (s+6.763)/(s-6.763);
Pmp = 6.6667/(s+6.763)^2;

gain = db2mag(117);
cn = (s+20);
cd = Pmp*s*(s+100)^3;
Cont_t = gain*cn/cd

L_t = Cont_t*P_t;

figure(); bode(L_t); grid on;
figure(); nyqlog(L_t);

%% Realimentacion por loop shaping continuo: x

close all;

%Linealizando el nuevo sistema generado antes

num = 2.1238e05*(s+20)*(s+6.763)^2*(s+5.718)*(s-5.718);
den = s^2*(s+183.7)*(s+6.766)*(s^2 + 8.029*s + 74.89)*(s^2 + 101.5*s + 6958);

P_x = num/den

gain = -db2mag(20.8);
cn = (s+1);
cd = (s+100);
Cont_x = gain*cn/cd
 
L_x = Cont_x*P_x;
 
figure(); margin(L_x); grid on;
figure(); nyqlog(L_x);
