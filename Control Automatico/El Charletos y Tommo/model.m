clear all; clc; 

M = .5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
C = [0 0 1 0];
D = 0;

C = [1 0 0 0; 0 0 1 0];
D = [0; 0];

[num, den] = ss2tf(A,B,[0 0 1 0],0); Tt = minreal(tf(num,den));
[num, den] = ss2tf(A,B,[1 0 0 0],0); Tc = minreal(tf(num,den));

ctr = ctrb(A,B);
obs = obsv(A,C);

eig(A);
rank(ctr);
rank(obs);

K = acker(A, B, [-10 -10 -15 -15])




syms x1 x2 x3 x4 u;

f = [x2;
    u+m*l*(u+(M+m)*g*x4)/((M+m)*(I/(m*l)+l)-m*l);
    x4;
    (u+(M+m)*g*x4)/((M+m)*(I/(m*l)+l)-m*l)];


%[num, den] = ss2tf(A,B,C,D); T = minreal(tf(num,den))

% Aai=[A B; -Cc -D];
% Bai = [B ; 0];
% Cai = [C(1,:) , 0;
%       C(2,:), 0];
% Dai = D;
% 
% Kai = acker(Aai, Bai, [-1 -0.5 -10 -220 -200])
% Kc = Kai(1:3);
% Ki = Kai(4);
 
%states = {'x' 'x_dot' 'phi' 'phi_dot'};
%inputs = {'u'};
%outputs = {'x'; 'phi'};
%sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs)