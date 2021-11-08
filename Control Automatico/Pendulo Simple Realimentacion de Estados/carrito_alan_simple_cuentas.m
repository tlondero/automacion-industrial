clc; clear all;
s = tf('s');
%% Control por realimentación de estados
%Del linearizer de simulink
A = [0 1 0 0;
    0 0 1.7292 0;
    0 0 0 1;
    0 0 2.1615 0];

B = [0 ; 0.941 ; 0 ; 0.1763];

C = [0 0 1 0;
    1 0 0 0];

D = [0 ; 0];
%Tener en cuenta: x1: p, x2: v, x3: q, x4: w
sys = ss(A,B,C,D);
%Chequeamos controlabilidad, viendo que el rango de la matriz de
%controlabilidad sea igual a la dimensión del espacio columna de la matriz
%A.
rank(ctrb(sys.A, sys.B));
%El rango es cuatro, por lo que el sistema es controlable.
%Realizamos la realimentación de estados teniendo en cuenta que el
%controlador debe ser lo suficientemente rapido para lograr controlar la
%inestabilidad del polo del semiplano derecho.
K = acker(sys.A, sys.B, [-3 -3 -2 -2]);
%El algoritmo de acker presenta error en los lugares de los polos por mas
%de un 10% de lo esperado, sin embargo el diseño se valida mediante la
%simulación y se logra asi obtener ganancia mas pequenas.

%% Control por realimentación de estados con acción integral
%Modificamos la matriz C para realizar la acción integral sobre la posición
%del carrito
C = [1 0 0 0];
%Aumentamos las matrices
Aa = [A  zeros(4,1);
      -C      0];
Ba = [sys.B;
      0];
Bar = [zeros(4,1);
       1];
Ca = [C 0];
Da = 0;
%Calculamos las ganancias
Ka = acker(Aa, Ba, [-2.5 -2.5 -1 -1 -4]);
sys_i = ss(Aa, Ba, Ca, Da);
sys_i_cl = ss(Aa-Ba*Ka, Bar, Ca, Da);

Kai = Ka(5)
Ka = Ka(1:4)