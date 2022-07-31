clear all; clc;

simulation = 'DoublePendulumLin';

if ~bdIsLoaded(simulation)   % Abro SimuLink si no está abierto
    open_system(simulation)
end

%Constantes de simulink

M = 1.5;
g = 9.8;
b = 0;
l = 0.15;

L1 = 0.5;
L2 = 0.75;
l1 = L1/2;
l2 = L2/2;
m1 = 0.5;
m2 = 0.75;

I0 = 0;
I1 = (m1*L1^2)/12;
I2 = (m2*L2^2)/12;

syms t1 t2;

D = [ M+m1+m2,                  (m1*l1+m2*L1)*cos(t1),  m2*l2*cos(t2);
      (m1*l1+m2*L1)*cos(t1),    m1*(l1^2)+m2*(L1^2)+I1, m2*L1*l2*cos(t1-t2);
      m2*l2*cos(t2),            m2*L1*l2*cos(t1-t2),    m2*(l2^2)+I2];
  
G = [ 0;
      -g*(m1*l1+m2*L1)*sin(t1);
      -m2*l2*g*sin(t2)];
  
H = [1;0;0];
  
D0 = double(subs(D, {'t1' 't2'}, {0 0}));
jacobian_g0 = double(subs(jacobian(G, [t1 t2]), {'t1' 't2'}, {0 0}));

A = [0         0         0    1         0         0;
     0         0         0    0         1         0;
     0         0         0    0         0         1;
     0    6.8783    1.3795    0         0         0;
     0   40.8470  -14.2141    0         0         0;
     0  -31.3540   36.6342    0         0         0];

B = [ 0; 0; 0; 0.6274; 1.5372; -1.1732];

C = [1 0 0 0 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1];

D = 0;

%% Realimentacion de estados y observador Pendulo Doble

x_0 = 0;
t1_0 = 5*pi/180;
t2_0 = 5*pi/180;
x_0d = 0;
t1_0d = 0;
t2_0d = 0;

X0 = [x_0 t1_0 t2_0 x_0d t1_0d t2_0d];

pK = [-20 -15 -10 -5 -0.2 -0.1];
K = acker(A, B, pK)

pL = pK.*8;
L = place(A', C', pL)
L = L';

sim(simulation,50);

%% Control LQR y observador Pendulo Doble

x_0 = 0;
t1_0 = 5*pi/180;
t2_0 = 5*pi/180;
x_0d = 0;
t1_0d = 0;
t2_0d = 0;

X0 = [x_0 t1_0 t2_0 x_0d t1_0d t2_0d];

Q = diag([100 10 10 10 1 1]);
R = 1;
K = lqr(A,B,Q,R)

pL = pK.*8;
L = place(A', C', pL)
L = L';

sim(simulation,10);
