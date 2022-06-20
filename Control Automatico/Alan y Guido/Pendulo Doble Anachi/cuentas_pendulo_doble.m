%% Initialize
clc; clear all; close all;
s = tf('s');
%% Define variables

syms m0 m1 m2 l1 l2 L1 L2 I1 I2 g theta0 theta1 theta2 dtheta0 dtheta1 dtheta2;
%X0 Theta1 THeta2 dx0 dt1 dt2
%% Matrices Alineales
% M(theta)*ddtheta+V(theta,dtheta)+G(theta)
M=[m0+m1+m2, (m1*l1+m2*L1)*cos(theta1), m2*l2*cos(theta2);
    (m1*l1+m2*L1)*cos(theta1), m1*l1^2+m2*L1^2+I1, m2*L1*l2*cos(theta1-theta2);
    m2*l2*cos(theta2), m2*L1*l2*cos(theta1-theta2), m2*l2^2+I2];
V=[0,-(m1*l1+m2*L1)*sin(theta1)*dtheta1,-m2*l2*sin(theta2)*dtheta2;
    0,0,m2*L1*l2*sin(theta1-theta2)*dtheta2;
    0,-m2*L1*l2*sin(theta1-theta2)*dtheta1,0];
G=[0;
    -(m1*l1+m2*L1)*g*sin(theta1);
    -m2*g*l2*sin(theta2)];
H=[1;
    0;
    0];
%% Luego asumimos valores para algunos valores, como centros de masa e Incercias

M=simplify(subs(M, {'l1' 'l2','I1','I2'}, {L1/2 L2/2 m1*L1^2/12 m2*L2^2/12}));
V=simplify(subs(V, {'l1' 'l2','I1','I2'}, {L1/2 L2/2 m1*L1^2/12 m2*L2^2/12}));
G=simplify(subs(G, {'l1' 'l2','I1','I2'}, {L1/2 L2/2 m1*L1^2/12 m2*L2^2/12}));
H=simplify(subs(H, {'l1' 'l2','I1','I2'}, {L1/2 L2/2 m1*L1^2/12 m2*L2^2/12}));

%% Ahora uso el modelo Lineal a partir de las matrices derivadas.
a11=zeros(3);
a12=eye(3);
a21=zeros(3);
a22=simplify(inv(M)*V);
A=[a11, a12;
     a21, a22];
B=[zeros(3,1);
    inv(M)*H];
L=[zeros(3,1);
    -inv(M)*G];
%%
p=1/(4*m0*m1+3*m0*m2+m1^2+m1*m2);
Asublinear=[
    0,-3/2*p*(2*m1^2+5*m1*m2+2*m2^2)*g,3/2*p*m1*m2*g;
    0,3/2*p/L1*(4*m0*m1+8*m0*m2+4*m1^2+9*m1*m2+2*m2^2)*g,-9/2*p/L1*(2*m0*m2+m1*m2)*g;
    0,-g*9/2*p/L2*(2*m0*m1+4*m0*m2+m1^2+2*m1*m2),g*3/2*p/L2*(m1^2+4*m0*m1+12*m0*m2+4*m1*m2)]
Bsublinear=[p*(4*m1+3*m2);
    -3*p/L1*(2*m1+m2);
    2*p*m2/L2];
A=[zeros(3) eye(3);
    Asublinear zeros(3)];
B=[zeros(3,1);Bsublinear];
C=eye(6);
D=zeros(1,6);

m0_value=0.10;
m1_value=0.10;
m2_value=0.075;
L1_value=0.5;
L2_value=0.75;
g_value=9.8;

A=double(subs(A, {'m0' 'm1' 'm2','L1','L2' 'g'}, {m0_value m1_value m2_value L1_value L2_value g_value}))
B=double(subs(B, {'m0' 'm1' 'm2','L1','L2' 'g'}, {m0_value m1_value m2_value L1_value L2_value g_value}))

disp('Rango de matriz de controlabilidad')
rank(ctrb(A,B))
disp('Rango de matriz de observabilidad')
rank(obsv(A,C))
K=acker(A,B,[0.002,-0.001,-0.001,-0.001,-0.001,-0.001])