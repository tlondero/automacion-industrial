clear all; clc;

simulation = 'DoublePendulumDiscreto';

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
  
inv_d0 = inv(double(subs(D, {'t1' 't2'}, {0 0})));
jacobian_g0 = double(subs(jacobian(G, [t1 t2]), {'t1' 't2'}, {0 0}));

A = [ zeros(3,3), eye(3);
    [ zeros(3,1), -1*inv_d0*jacobian_g0, zeros(3)] ]

B = [ 0;
      0;
      0;
      inv_d0*H ]

C = eye(6);

D = zeros(6,1);

%% Transferencias Pendulo Doble

% x t1 t2 x_d t1_d t2_d

[num, den] = ss2tf(A,B,[1 0 0 0 0 0],0); Tx = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(A,B,[0 1 0 0 0 0],0); Tt1 = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(A,B,[0 0 1 0 0 0],0); Tt2 = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(A)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(A,B)))])    %Es controlable
disp(['Observabilidad pendulo simple: ' num2str(rank(obsv(A,C)))])    %Se puede estimar las variables de estado observando la posición

%% Realimentacion de estados y observador CONTINUO

pK = [-25 -15 -10 -10 -5 -1];
K = acker(A, B, pK)

pL = pK.*10;
L = (acker(A', [1 0 0 0 0 0]', pL))
L = L';

%% Realimentacion de estados y observador DISCRETO

Ts = 1e-3;

sysd = c2d(ss(A,B,[1 0 0 0 0 0],0), Ts, 'tustin');
Ad = sysd.A;
Bd = sysd.B;
Cd = sysd.C;
Dd = sysd.D;

pKd = exp(pK.*Ts);
Kd = acker(Ad, Bd, pKd)

pLd = exp(pK.*(1.05*Ts));
Ld = (acker(Ad', Cd', pLd))
Ld = Ld';

sim(simulation,10);