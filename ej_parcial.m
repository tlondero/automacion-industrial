clear all;close all;clc;
Ts=10e-3;
s=tf([1 0],[1]);
P=((s+10)*(1-(Ts/4)*s))/((s*(s+1))*((1+(Ts/4)*s)));
C=((s+1))/(s*(s+10));
PC=minreal(P*C);

S=minreal(1/(1+PC));
T=minreal(1-S);
PS=minreal(P*S) ;
CS=minreal(C*S);

nc = (s+1);
dc = 1;
L_ = PC*nc/dc *db2mag(3.89);
L=PC;
figure()

margin(L); grid on
figure()
margin(L_);
grid on
