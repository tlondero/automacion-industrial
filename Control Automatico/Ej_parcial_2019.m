
y = @(x) sin(x)-0.5*x^3*(pi/6)^(-3);


x0 = fzero(y, 3)
x1 = fzero(y, -3)
x2 = fzero(y, 0)

clc;
clear;
syms x1 x2 u1;%Variables de estado

syms alpha beta m g; %Constantes



f = [x2;
    g*m*sin(x1)+u1-alpha*x1^3-beta*x2];
A = jacobian(f,[x1;x2])
B = jacobian(f,u1)

%Asignacion de constantes y puntos de equilibrio
alpha =0.5*(pi/6)^-3;
beta =1;
m =0.1;
g=10;%Constantes

x1eq=0;         %inestable
%x1eq=pi/6;     %estable
%x1eq=-pi/6;    %estable
x2eq=0;
u1eq=0;


x1 = x1eq;
x2 = x2eq;
u1 = u1eq;

A = eval(A);
B = eval(B);
C = [1 0];
D = 0;
eig(A)
disp('No es estable, vamos a hacer realimentacion de estados con accion integral')

disp('Chequeemos controlabilidad y observabilidad Planta original')
disp('Controlabilidad:')
ctr = ctrb(A,B);
rank(ctr)
disp('Observabilidad:')
obs = obsv(A,C);
rank(obs)

Aai=[A B;
    -C -D];
Bai = [B ; 0];
Cai = [C 0];
D=0;
disp('Chequeemos controlabilidad y observabilidad Planta original')
disp('Controlabilidad:')
ctr = ctrb(Aai,Bai);
rank(ctr)
disp('Observabilidad:')
obs = obsv(Aai,Cai);
rank(obs)

Kai = place(Aai, Bai, [-1 -0.5 -200]);
Aaicl= (Aai-Bai*Kai);

eig(Aaicl)
Baicl=[B*0;1];
Caicl=Cai;
Daicl = 0;

%% Calculemos las cosas para discreto
sys=ss(Aai,Bai,Cai,D);
Ts=0.1;
sysDisc=c2d(sys,Ts,'tustin');%discrete system
pCont=[-1 -0.5 -200];%poles in s-domain
pDisc=exp(pCont.*Ts);%poles in z-domain
disc=place(sysDisc.A,sysDisc.B,pDisc)


%%%%%%%%
%% calculamos paramentros observador
sysobs=ss(A,B,C,D);
sysDiscobs=c2d(sysobs,Ts,'tustin'); 
%discrete system
Ad_obs=sysDiscobs.A;
Bd_obs=sysDiscobs.B;
Cd_obs=sysDiscobs.C;
Dd_obs=sysDiscobs.D;

L=place(Ad_obs',Cd_obs',[-10 -5])


