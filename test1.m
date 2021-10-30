clc; clear all; close all;
%DH parameters using Peter Corke Robotics%
L1=1;
L2=L1;
syms th1 th2;

t1=pi/2;
t2=pi/2;


L(1) = Link([0 0 L1 0]);
L(2) = Link([0 0 L2 0]);
Rob = SerialLink(L);
Rob.name = 'RR';

t = [0:0.01:1];
T = [1.+t.*0; -1.+t.*2; t.*0].';
hold on
 x = linspace(0,2,1000);
 y = -x+2;
 plot(x,y);
 patch([2 0 0 2],[0 2 2 0], [-2 -2 1 1],'g' );

 Q = Rob.ikine(transl(T), 'mask', [1 1 0 0 0 0]);
Rob.plot(Q);

hold off

% T1 = transl(L1, -L2, 0);
% qi = Rob.ikine(T1,'q0',[-pi/2 0], 'mask', [1 1 0 0 0 0]);
% Rob.plot(qi)
% w = waitforbuttonpress
% x = linspace(0,2,1000);
% y = -x+2;
% plot(x,y)
% 
% 
% T2 = transl(L1, L2, 0);
% qf = Rob.ikine(T2,'q0',[0 0], 'mask', [1 1 0 0 0 0]);
% Rob.plot(qf)
% t = [0:0.01:1];
% [q, qd, qdd] = jtraj(qi, qf, t);
% Rob.plot(q)
% TT = Rob.fkine(q);
% tt =[]
% for i = [1:1:101]
%     tt = [tt; (TT(i).t(1:2)).'];
% end
% hold on
% plot2(tt)
% hold off