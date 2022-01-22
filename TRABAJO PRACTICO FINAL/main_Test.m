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
for x=-x0:0.01:x0
    for y=-x0:0.01:x0
        for z=-x0:0.01:x0
           %if BlackWidow.isReachable([x;y;z]) 
           % points(i,:)=[x;y;z];
           %end
           i=i+1;
        end
    end
end
%save('reachable.mat','points')