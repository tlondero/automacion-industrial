clear all; clc; 

M = .5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

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

[num, den] = ss2tf(A,B,[0 0 1 0],0); Tt = minreal(tf(num,den));
[num, den] = ss2tf(A,B,[1 0 0 0],0); Tc = minreal(tf(num,den));

ctr = ctrb(A,B);
obs = obsv(A,C);

eig(A);
rank(ctr);
rank(obs);

K = acker(A, B, [-10 -10 -15 -15])