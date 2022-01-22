clc; clear all; close all;
L1=0.130;
L2=0.144;
L3=0.053;
L4=0.144;
L5=0.144;
Lp=sqrt(L2^2+L3^2);
x0=Lp+L4+L5;
y0=0;
z0=L1;
 

BlackWidow=WidowXMKII(L1,L2,L3,L4,L5);

%  t = 0:0.5:pi*2;
% T=[sin(t)*x0;cos(t)*x0;z0+t.*0]';
% BlackWidow.moveWidow(T)
% BlackWidow.getPosition()

i=1;
totalcases=704970;
points=zeros(totalcases,3);

%hay que hacer la cuenta generica para las coordenadas. Algo como lo
%siguiente pero que sea para nuestro caso
% l1=500;l2=600;l3=400;l4=191.03;
% t1=linspace(-180,180,90)*pi/180;
% t2=linspace(-90,90,90)*pi/180;
% d3=linspace(-200,200,90);
% t4=linspace(-180,180,90)*pi/180;
% [T1,T2,D3,T4]=ndgrid(t1,t2,d3,t4); % Add t4 here
% xM = round((-cos(T1).*cos(T2)).*((D3 + l2 + l3 + l4))); % and use it in x y z as T4
% yM = round((-cos(T2).*sin(T1)).*(D3 + l2 + l3 + l4));
% zM = round((l1 - l4.*sin(T2) - sin(T2).*(D3 + l2 + l3)));
% plot3(xM(:),yM(:),zM(:),'.')
%save('reachable.mat','points')