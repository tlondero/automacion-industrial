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

%% Control por realimentación de estados con observador
%Estudiamos la observabilidad del sistema
rank(obsv(sys.A,sys.C));
%Como el rango de la matriz de observabilidad es 4 igual al orden de la
%matriz A, el sistema es observable.
%Calculo ganancias del observador, colocando sus polos diez veces más
%rápidos que los de la planta a lazo cerrado.
L = place((sys.A)',(sys.C)', [-25 -20 -35 -30])';

%% Control por realimentación de estados con observador discreto
%Selecciono periodo de muestreo
Ts = 0.1; %100ms
%Discretizo el sistema utilizando tustin.
sysDisc = c2d(sys, Ts, 'tustin');
%Calculo ganancias de realimentación.
KDisc = acker(sysDisc.A, sysDisc.B, exp([-2 -2 -1 -1].*Ts));
%Calculo ganancias del observador discreto.
LDisc = place((sysDisc.A)',(sysDisc.C)', exp([-20 -15 -25 -30].*Ts))';


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
%Estudiamos controlabilidad del sistema aumentado
rank(ctrb(Aa, Ba));
%Como el rango de la matriz de controlabilidad es 5 igual al orden de A, el
%sistema es controlable.
%Estudio de observabilidad del sistema aumentado
rank(obsv(Aa,Ca));
%El rango de la matriz de observabilidad es menor al orden de A, por lo que
%el sistema no es observable.
%Calculamos las ganancias
Ka = acker(Aa, Ba, [-2.5 -2.5 -1 -1 -4]);
sys_i = ss(Aa, Ba, Ca, Da);
sys_i_cl = ss(Aa-Ba*Ka, Bar, Ca, Da);

Kai = Ka(5);
Ka = Ka(1:4);

%% Control por realimentacion de estados con accion integral discreto
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
%Estudiamos controlabilidad del sistema aumentado
rank(ctrb(Aa, Ba));
%Como el rango de la matriz de controlabilidad es 5 igual al orden de A, el
%sistema es controlable.
%Estudio de observabilidad del sistema aumentado
rank(obsv(Aa,Ca));
%El rango de la matriz de observabilidad es menor al orden de A, por lo que
%el sistema no es observable.
%Calculamos las ganancias

%Tasa de muestreo
Ts2 = 0.05; %50ms

%Calculo ganancias de realimentación.
sysDisc2 = c2d(ss(Aa,Ba,Ca,Da), Ts2, 'tustin');
KDisc2 = acker(sysDisc2.A, sysDisc2.B, exp([-2.5 -2.5 -1 -1 -4].*Ts2));


KaiDisc = KDisc2(5);
KaDisc = KDisc2(1:4);

%% Control de ángulo por loop shaping
%Transferencia de fuerza carrito a ángulo sacada utilizando el linearizer
%del simulink
G_q = 0.1763/((s-1.47)*(s+1.47));
%Grafico bode de la planta
bode(G_q);
%Notar que hay un polo en el semiplano derecho. La teoría nos dice que la
%frecuencia de cruce debe estar 1.766 veces más arriba que el polo en el
%semiplano derecho.
%Notar también que el bode de la planta presenta inversión de fase para
%todas las frecuencias. Se coloca un cero en -2.6 para proveer adelanto de
%fase alrededor de la frecuencia de cruce deseada. Se coloca un polo en
%-200 para hacer al controlador realizable.
bode(G_q*((s+(2.6)/(s+200))));
%Se observa que se debe levantar la magnitud por 102.5db para obtener cruce
%en una frecuencia rápida.
%Se valida el diseño.
bode(G_q*(db2mag(102.5)*(s+(2.6))/(s+200)));
C_q = (db2mag(102.5)*(s+(2.6))/(s+200));
[C_q_n, C_q_d] = tfdata(C_q,'v');
%Se analiza la función de sensibilidad
L_q = G_q*C_q;
S_q = 1/(1+L_q);
T_q = L_q/(1+L_q);
bode(S_q);
%Se observa que el pico de la función de sensibilidad es de 2.4db = 1.3, esto
%brinda un buen margen de estabilidad.
%Simulando con simscape se puede observar que el ángulo del pendulo es
%correctamente estabilizado, sin embargo la posición del carrito presenta
%drift.

%Transferencia de fuerza de carrito a posición con realimentación en el
%ángulo
G_p = (0.94101 * (s+200) * (s+1.356) * (s-1.356)) / (s^2 * (s+2.635) * (s^2 + 197.4*s + 2.409e04));
%Notar que hay un cero en el semiplano derecho en 1.356 rad/s. La teoría nos indica que la
%frecuencia de cruce debe estar por debajo de 0.6 veces la frecuencia del
%polo en el semiplano derecho que sería alrededor de 0.8 rad/s.
%Agregamos un cero en -0.05rad/s para brindar adelanto de fase a la izquierda de
%0.5rad/seg. Ademas agregamos un polo rápido en -100 para hacer el
%controlador realizable.
C_p = -(s+0.05)/(s+100);
bode(G_p*-(s+0.05)/(s+100));
%Para tener un margen buen margen de fase a una frecuencia de cruce de
%por debajo del limite de 0.5rad/seg, multiplicamos por 76.9dB. 
C_p = -db2mag(80.6)*(s+0.05)/(s+100);
[C_p_n, C_p_d] = tfdata(C_p,'v');
margin(G_p*C_p);
L_p = G_p*C_p;
T_p = L_p/(1+L_p);
S_p = 1-T_p;
bode(S_p);
%Se observa un pico de 6db en S_p, esto esta casi al límite de un buen
%margen de estabilidad. Además, si bien el margen de fase es bueno, el
%margen de ganancia es bastante malo, pero es el costo de tener un
%controlador lo más rápido posible, dentro de las limitaciones de
%implementación por las características de la planta.
step(T_p);
%En el step de la función de sensibilidad complementaria se puede ver la
%acción del cero en el semiplano derecho al actuar al carrito en la
%dirección contraria a la referencia, para luego volver y asentarse sin
%error permanente sobre la referencia.

%Sin embargo, al simular con simscape, si bien tanto el ángulo como la
%posición son correctamente estabilizadas, sí se ve error permanente en la
%posición. Esto es raro debido a que la planta es de tipo 2.

%% Control de ángulo por loop shaping discreto
Ts_loop = 25/1000; %25ms

C_q_Disc = c2d(C_q, Ts_loop, 'tustin')
[C_q_Disc_n, C_q_Disc_d] = tfdata(C_q_Disc,'v');

C_p_Disc = c2d(C_p, Ts_loop, 'tustin')
[C_p_Disc_n, C_p_Disc_d] = tfdata(C_p_Disc,'v');

