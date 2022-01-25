clc; clear all; close all;
L1=0.130;
L2=0.144;
L3=0.053;
L4=0.144;
L5=0.144;
Lp=sqrt(L2^2+L3^2);
x0=Lp+L4+L5-0.05;
y0=0;
z0=L1-0.05;
 

BlackWidow=WidowXMKII(L1,L2,L3,L4,L5);

 t = 0:0.5:pi*2;
T=[sin(t)*x0;cos(t)*x0;z0+t.*0]';
BlackWidow.moveWidow([x0;y0;z0])


%hay que hacer la cuenta generica para las coordenadas. Algo como lo
%siguiente pero que sea para nuestro caso
% t1=linspace(-180,180,180)*pi/180;
% t2=linspace(-90,90,10)*pi/180;
% t3=linspace(-90,90,10)*pi/180;
% t4=linspace(-180,180,40)*pi/180;
% [T1,T2,T3,T4]=ndgrid(t1,t2,t3,t4); % Add t4 here
% xM = cos(T1).*(Lp*cos(T2)+L4*cos(T2+T3)+L5*cos(T2+T3+T4)); % and use it in x y z as T4
% yM = sin(T1).*(Lp*cos(T2)+L4*cos(T2+T3)+L5*cos(T2+T3+T4));
% zM = L1+Lp*sin(T2)+L4*sin(T2+T3)+L5*sin(T2+T3+T4);
% plot3(xM(:),yM(:),zM(:),'.')
