clc; clear all; close all;
L1=0.130;
L2=0.144;
L3=0.053;
Lp=sqrt(L2^2+L3^2);
L4=0.144;
L5=0.144;

L(1)=Link([0 L1 0 0]);
L(2)=Link([0 0 0 pi/2]);
L(3)=Link([0 0 Lp 0]);
L(4)=Link([0 0 L4 0]);
L(5)=Link([0 0 L5 0]);


Widow = SerialLink(L);
Widow.name = 'WidowXMKII';

%  x0=Lp+L4+L5;
%  y0=0;
%  z0=L1;
  
 x0=Lp+L4+L5-0.05;
 y0=0;
 z0=L1-L1/4;
 
t = 0:0.001:0.01;
%T = [-t.*1+x0; t.*0+y0; t.*0+z0].';
t = 0:0.1:pi*2;
T=[sin(t)*x0;cos(t)*x0;z0+t.*0]';   
PORONGA=transl(T);
Q = Widow.ikine(PORONGA,[1 1 1 0 0 0]);
%Q=[0,0,0,0,0]
Widow.plot(Q);