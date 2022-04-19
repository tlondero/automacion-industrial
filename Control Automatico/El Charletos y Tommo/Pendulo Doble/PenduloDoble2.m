clear all; clc; 

%Constantes de simulink

M = 0.5;
m = 0.2;
b = 0; % 0.1;
I = 0.006;
g = 9.8;
L = 0.3;
l = L/2;

L1 = L;
L2 = L;
l1 = l;
l2 = L;
m1 = m;
m2 = m;
I1 = 0;
I2 = 0;

syms t1 t2;

D = [ M+m1+m2,                  (m1*l1+m2*L1)*cos(t1),  m2*l2*cos(t2);
      (m1*l1+m2*L1)*cos(t1),    m1*(l1^2)+m2*(L1^2)+I1, m2*L1*l2*cos(t1-t2);
      m2*l2*cos(t2),            m2*L1*l2*cos(t1-t2),    m2*(l2^2)+I2];
  
G = [ 0;
      -g*(m1*l1+m2*L1)*sin(t1);
      -m2*l2*g*sin(t2)];
  
H = [1;0;0];
  
minus_inv_d0 = -1*inv(double(subs(D, {'t1' 't2'}, {0 0})));
jacobian_g0 = double(subs(jacobian(G, [t1 t2]), {'t1' 't2'}, {0 0}));

A = [ zeros(3,3), eye(3);
    [ zeros(3,1), minus_inv_d0*jacobian_g0, zeros(3)] ]

B = [ 0;
      0;
      0;
     minus_inv_d0*H ]
 
%% ajustando la matriz B la a le pega a los signos pero hasta ahí

A(4,:) = A(4,:).*(-1);
A(6,:) = A(6,:).*(4);
 
B(4,:) = B(4,:).*(-1);
B(6,:) = B(6,:).*(4);


%% Modelo de estados Pendulo Doble

Ad = [0    1.0000         0         0         0         0;
      0         0    7.8480         0   -3.9240         0;
      0         0         0    1.0000         0         0;
      0         0  117.7199         0 -156.9592         0;
      0         0         0         0         0    1.0000;
      0         0 -235.4398         0  510.1176         0];
  
Bd = [0
      2.0000;
      0;
      13.3333;
      0;
     -26.6667];
  
Cd = [1 0 0 0 0 0];

Dd = 0; %zeros(6,1);

%% Transferencias Pendulo Doble

[num, den] = ss2tf(Ad,Bd,[0 0 1 0 0 0],0); Tt1d = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[0 0 0 0 1 0],0); Tt2d = zpk(minreal(tf(num,den)))
[num, den] = ss2tf(Ad,Bd,[1 0 0 0 0 0],0); Tcd = zpk(minreal(tf(num,den)))

%% Estabilidad, controlabilidad y observabilidad Pendulo Doble

disp('Estabildiad pendulo simple:')        %Es inestable, tengo un polo en SPD
eig(Ad)

disp(['Controlabilidad pendulo simple: ' num2str(rank(ctrb(Ad,Bd)))])    %Es controlable
disp(['Observabilidad pendulo simple: ' num2str(rank(obsv(Ad,Cd)))])    %Se puede estimar las variables de estado observando la posición

%% Realimentacion de estados y observador Pendulo Doble

pKd = [-5 -10 -10 -1 -15 -15];
Kd = acker(Ad, Bd, pKd)

pLd = pKd.*10;
Ld = (acker(Ad', Cd', pLd))'
