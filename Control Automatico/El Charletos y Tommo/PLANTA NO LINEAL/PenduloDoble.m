clear all; clc;

simulation = 'DoublePendulum';

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

A = [ zeros(3,3), eye(3);
    [ zeros(3,1), -1*(D0\jacobian_g0), zeros(3)] ]

B = [ 0;
      0;
      0;
      D0\H ]

C = [1 0 0 0 0 0];

D = 0;

%% Transferencias Pendulo Doble

% x t1 t2 x_d t1_d t2_d

[num, den] = ss2tf(A,B,[1 0 0 0 0 0],0); Tx = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(A,B,[0 1 0 0 0 0],0); Tt1 = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(A,B,[0 0 1 0 0 0],0); Tt2 = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp(['Estabilidad pendulo doble: ' num2str(eig(A)')])        %Es inestable, tengo dos polos en SPD
disp(['Controlabilidad pendulo doble: ' num2str(rank(ctrb(A,B)))])    %Es controlable
disp(['Observabilidad con posicion del carro: ' num2str(rank(obsv(A,C)))])    %Se puede estimar las variables de estado observando la posición

C = [1 0 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 0 0 0];
disp(['Observabilidad con las tres posiciones: ' num2str(rank(obsv(A,C)))])
 
C = [1 0 0 0 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1]; 
disp(['Observabilidad con posicion y velocidades: ' num2str(rank(obsv(A,C)))])

%% Realimentacion de estados y observador Pendulo Doble

X0 = [0 5*pi/180 5*pi/180 0 0 0];

pK = [-40 -8 -8 -1 -1 -0.5];
K = acker(A, B, pK)

C = [1 0 0 0 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1];

pL = pK.*8;
L = place(A', C', pL)
L = L';

sim(simulation,10);
