clc; clear all;
s = tf('s');

%Parámetros
m0_value=5; %Masa
m1_value=1;
m2_value=1;
L1_value=1; %Longitud
L2_value=1.5;
I0 = 0;
I1 = m1_value*(((L1_value)^2)/12); %Inercia
I2 = m2_value*(((L2_value)^2)/12);
F0 = 0.004; %Friccion
F1 = 0.004;
F2 = 0.004;

%% Control por realimentación de estados
%Del linearizer de simulink
A = [0 0 0 1 0 0;
    0 0 0 0 1 0;
    0 0 0 0 0 1;
    0 -3.1784 0.3973 -0.0008 0.0557 -0.0681;
    0 16.6865 -13.1108 0.0010 -0.4646 0.8734;
    0 -20.3946 35.6243 -0.0012 0.8734 -1.9842];

B = [0 ; 0 ; 0 ; 0.1892 ; -0.2432 ; 0.2973];

C = [1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0];

D = [0];

%Tener en cuenta: x1: p, x2: q1, x3: q2, x4: v, x5: w1, x6: w2
sys = ss(A,B,C,D);
%Chequeamos controlabilidad, viendo que el rango de la matriz de
%controlabilidad sea igual a la dimensión del espacio columna de la matriz
%A.
rank(ctrb(sys.A, sys.B));
%El rango es seis, por lo que el sistema es controlable.
%Realizamos la realimentación de estados teniendo en cuenta que el
%controlador debe ser lo suficientemente rapido para lograr controlar la
%inestabilidad del polo del semiplano derecho.
K = place(sys.A, sys.B, [-3 -2.5 -2.4 -2 -1.9 -1.8]);

%% Control por realimentación de estados con observador
%Estudiamos la observabilidad del sistema
rank(obsv(sys.A,sys.C));
%Como el rango de la matriz de observabilidad es 6 igual al orden de la
%matriz A, el sistema es observable.
%Calculo ganancias del observador, colocando sus polos diez veces más
%rápidos que los de la planta a lazo cerrado para lograr rápida convergencia
%entre la planta y el observador.
L = place((sys.A)',(sys.C)', [-3 -2.5 -2.4 -2 -1.9 -1.8].*10)';

%% Control por realimentación de estados con observador discreto
%Selecciono periodo de muestreo
Ts = 0.03; %30ms o 33.3Hz
%Discretizo el sistema utilizando tustin.
sysDisc = c2d(sys, Ts, 'tustin');
%Calculo ganancias de realimentación.
KDisc = place(sysDisc.A, sysDisc.B, exp([-1.5 -1.6 -1.7 -2 -2.1 -2.2].*Ts));
%Calculo ganancias del observador discreto con los polos del observador 20
%veces más rapido para lograr convergencia rápida.
LDisc = place((sysDisc.A)',(sysDisc.C)', exp(([-1.5 -1.6 -1.7 -2 -2.1 -2.2].*20).*Ts))';




