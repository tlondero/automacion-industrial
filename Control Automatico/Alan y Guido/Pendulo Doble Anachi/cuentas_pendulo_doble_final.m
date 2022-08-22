clc; clear all;
s = tf('s');

m0_value=5;
m1_value=1;
m2_value=1;
L1_value=1;
L2_value=1.5;
I0 = 0;
I1 = m1_value*(((L1_value)^2)/12);
I2 = m2_value*(((L2_value)^2)/12);
F0 = 0.004;
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

A_orig = [0 0 0 1 0 0;
    0 0 0 0 1 0;
    0 0 0 0 0 1;
    0 -3.5757 0.3973 0 0 0;
    0 29.7973 -13.1108 0 0 0;
    0 -26.2216 22.5135 0 0 0];

B_orig = [0 ; 0 ; 0 ; 0.1892 ; -0.2432 ; 0.036];

C_orig = [1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0];

sys_orig = ss(A_orig, B_orig, C, D);

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
K = place(sys.A, sys.B, [-4 -3.5 -3 -2.5 -2 -1.5]);
%El algoritmo de acker presenta error en los lugares de los polos por mas
%de un 10% de lo esperado, sin embargo el diseño se valida mediante la
%simulación y se logra asi obtener ganancia mas pequenas.

 %% Control por realimentación de estados con observador
 %Estudiamos la observabilidad del sistema
 rank(obsv(sys.A,sys.C));
 %Como el rango de la matriz de observabilidad es 4 igual al orden de la
 %matriz A, el sistema es observable.
 %Calculo ganancias del observador, colocando sus polos diez veces más
 %rápidos que los de la planta a lazo cerrado.
 L = place((sys.A)',(sys.C)', [-4 -3.5 -3 -2.5 -2 -1.5].*15)';
 
 %% Control por realimentación de estados con observador discreto
 %Selecciono periodo de muestreo
 Ts = 0.025; %25ms o 40Hz
 %Discretizo el sistema utilizando tustin.
 sysDisc = c2d(sys, Ts, 'tustin');
 %Calculo ganancias de realimentación.
 KDisc = place(sysDisc.A, sysDisc.B, exp([-3.5 -3 -2.5 -2 -1.5 -1].*Ts));
 %Calculo ganancias del observador discreto.
 LDisc = place((sysDisc.A)',(sysDisc.C)', exp(([-3.5 -3 -2.5 -2 -1.5 -1].*20).*Ts))';
 
 
 %% Control por realimentación de estados con acción integral
 %Modificamos la matriz C para realizar la acción integral sobre la posición
 %del carrito
 C = [1 0 0 0 0 0];
 %Aumentamos las matrices
 Aa = [A  zeros(6,1);
       -C      0];
 Ba = [sys.B;
       0];
 Bar = [zeros(6,1);
        1];
 Ca = [C 0];
%  Ca = [1 0 0 0 0 0 0;
%     0 1 0 0 0 0 0;
%     0 0 1 0 0 0 0;
%     0 0 0 0 0 0 1];
 Da = 0;
 %Estudiamos controlabilidad del sistema aumentado
 rank(ctrb(Aa, Ba));
 %Como el rango de la matriz de controlabilidad es 7 igual al orden de Aa, el
 %sistema es controlable.
 %Estudio de observabilidad del sistema aumentado
 rank(obsv(Aa,Ca));
 %El rango de la matriz de observabilidad es menor al orden de Aa, por lo que
 %el sistema no es observable.
 %Calculamos las ganancias
 Ka = place(Aa, Ba, [-6 -3.5 -3 -2.5 -2 -1.5 -4]);
 sys_i = ss(Aa, Ba, Ca, Da);
 sys_i_cl = ss(Aa-Ba*Ka, Bar, Ca, Da);
 
 Kai = Ka(7);
 Ka = Ka(1:6);
 
 %% Control por realimentacion de estados con accion integral discreto
  %Tasa de muestreo
 Ts2 = 0.01; %10ms
 Ca = [C 0];
 %Calculo ganancias de realimentación.
 sysDisc2 = c2d(ss(Aa,Ba,Ca,Da), Ts2, 'tustin');
 KDisc2 = acker(sysDisc2.A, sysDisc2.B, exp([-6 -3.5 -3 -2.5 -2 -1.5 -4].*Ts2));
 
 KaiDisc = KDisc2(7);
 KaDisc = KDisc2(1:6);


