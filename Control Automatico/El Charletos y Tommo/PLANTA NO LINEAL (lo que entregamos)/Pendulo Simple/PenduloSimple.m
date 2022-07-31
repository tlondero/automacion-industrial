clear all; clc;

simulation = 'SimplePendulum';

if ~bdIsLoaded(simulation)   % Abro SimuLink si no está abierto
    open_system(simulation)
end

%Constantes de simulink

b = 0;
l = 0.15;

M = 1.5;
g = 9.8;
L1 = 0.5;
l1 = L1/2;
m1 = 0.5;

% syms M g L1 l1 m1;

I0 = 0;
I1 = (m1*L1^2)/12;
syms t1 t2;

D = [ M+m1,             (m1*l1*L1)*cos(t1);
      (m1*l1)*cos(t1),  m1*(l1^2)+I1];      
  
G = [ 0;
      -g*(m1*l1)*sin(t1);];
  
H = [1;0];
  
D0 = subs(D, {'t1' 't2'}, {0 0});
jacobian_g0 = subs(jacobian(G, [t1 t2]), {'t1' 't2'}, {0 0});

A = double([ zeros(2), eye(2);
      zeros(2,1), -1*(D0\jacobian_g0), zeros(2,1) ])

  
B = double([ 0; 0; D0\H ])

C = [1 0 0 0];

D = 0;

%% Transferencias Pendulo Doble

% x t1 x_d t1_d

[num, den] = ss2tf(A,B,[1 0 0 0],0); Tx = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(A,B,[0 1 0 0],0); Tt1 = zpk(minreal(tf(num,den)))

%% Realimentacion de estados y observador Pendulo Doble

x_0 = 0;
t1_0 = 5*pi/180;
x_0d = 0;
t1_0d = 0;

X0 = [x_0 t1_0 x_0d t1_0d];

pK = [-40 -8 -1 -1];
K = acker(A, B, pK)

C = [1 0 0 0;
     0 1 0 0];
pL = pK.*8
L = place(A', C', pL)
L = L';

sim(simulation,10);

%%

clc; clear;

%Constantes de simulink

b = 0;
l = 0.15;

syms M g L m;
l = L/2;

I0 = 0;
I = (m*L^2)/12;
syms t1 t2;

D = [ M+m,            (m*l*L)*cos(t1);
      (m*l)*cos(t1),  m*(l^2)+I];      
  
G = [ 0;
      -g*(m*l)*sin(t1);];
  
H = [1;0];
  
D0 = subs(D, {'t1' 't2'}, {0 0});
jacobian_g0 = subs(jacobian(G, [t1 t2]), {'t1' 't2'}, {0 0});

A = [ zeros(2), eye(2);
      zeros(2,1), -1*(D0\jacobian_g0), zeros(2,1) ]

  
B = [ 0; 0; D0\H ]