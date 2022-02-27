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

% Parametros de la hoja
w_hoja = 0.15;
l_hoja = 0.2;
x_hoja = 0.3;
y_hoja = -0.1;
z_hoja = 0;

x0 = 0.4;
y0 = 0;
z0 = 0.2;
R = [1, 0, 0; 0, 0, -1; 0, 1, 0];
P = [x0; y0; z0]; %[x0; y0; z0]; 
T = [R, P; 0, 0, 0, 1];

hold on

drawTable(w_hoja, l_hoja, x_hoja, y_hoja, z_hoja);
Q = Widow.ikine(T, 'mask', [1 1 1 1 0 1]);
Widow.plot(Q);
zlim([-0.6, Lp+L4+L1]);

hold off