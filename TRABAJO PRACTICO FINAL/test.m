clc; clear all; close all;

L1 = 0.130;
L2 = 0.144;
L3 = 0.053;
Lp = sqrt(L2^2+L3^2);
L4 = 0.144;
L5 = 0.144;

L(1) = Link([0 L1 0 0]);
L(2) = Link([0 0 0 pi/2]);
L(3) = Link([0 0 Lp 0]);
L(4) = Link([0 0 L4 0]);
L(5) = Link([0 0 L5 0]);

Widow = SerialLink(L);
Widow.name = 'WidowXMKII';

x0 = Lp + L4;
y0 = L3;
z0 = L1;    % Altura de la mesa

R = [ 0, 1, 0; 0, 0, -1; -1, 0, 0];
P = [x0; y0; z0]; 
T = [R, P; 0, 0, 0, 1];

hold on
width = 0.15;
length = 0.2;
x0 = 0.3;
y0 = -0.1;
z0 = 0;

drawTable(width, length, x0, y0, z0);
Q = Widow.ikine(T, 'mask', [1 1 1 0 0 0]);
Widow.plot(Q);
zlim([-0.6, Lp+L4+L1]);

hold off