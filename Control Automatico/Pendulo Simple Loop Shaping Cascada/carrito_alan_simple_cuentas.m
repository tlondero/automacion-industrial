clc; clear all;
s = tf('s');
%% Control de ángulo por loop shaping
%Transferencia de fuerza carrito a ángulo
G_q = 0.1763/((s-1.47)*(s+1.47));
%Grafico bode de la planta
bode(G_q);
%Notar que hay un polo en el semiplano derecho. La teoría nos dice que la
%frecuencia de cruce debe estar 1.766 veces más arriba que el polo en el
%semiplano derecho.
%Notar también que el bode de la planta presenta inversión de fase para
%todas las frecuencias. Se coloca un cero en -1.47*1.766 para proveer adelanto de
%fase alrededor de la frecuencia de cruce deseada. Se coloca un polo en
%-100 para hacer al controlador realizable.
bode(G_q*((s+(1.47*1.7666)/(s+100))));
%Se halla la frecuencia en donde el margen de fase es de 60 grados, se
%observa que se debe levantar la magnitud por 68.8db para obtener cruce en
%esa frecuencia.
%Se valida el diseño.
bode(G_q*(db2mag(90.4+12.5)*(s+(1.47*1.7666))/(s+200)));
C_q = (db2mag(90.4+12.5)*(s+(1.47*1.7666))/(s+200));
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

%% Control de posición en cascada por loop shaping
%Transferencia de fuerza de carrito a posición con realimentación en el
%ángulo
G_p = (0.94101 * (s+200) * (s+1.356) * (s-1.356)) / (s^2 * (s+2.635) * (s^2 + 197.4*s + 2.409e04));
%Notar que hay un cero en el semiplano derecho en 1.356 rad/s. La teoría nos indica que la
%frecuencia de cruce debe estar por debajo de 0.6 veces la frecuencia del
%polo en el semiplano derecho que sería alrededor de 0.5 rad/s.

%??? a ghersin en clase no le da tan fea la trasferencia esta, no se que
%hacer ya intente de todo
