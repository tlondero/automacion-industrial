s=tf('s');
%Transferencia de fuerza de carrito a posición con realimentación en el
%ángulo
G_p = (0.94101 * (s+200) * (s+1.356) * (s-1.356)) / (s^2 * (s+2.635) * (s^2 + 197.4*s + 2.409e04));
%Notar que hay un cero en el semiplano derecho en 1.356 rad/s. La teoría nos indica que la
%frecuencia de cruce debe estar por debajo de 0.6 veces la frecuencia del
%polo en el semiplano derecho que sería alrededor de 0.5 rad/s.
%Agregamos un cero en -0.05rad/s para brindar adelanto de fase a la izquierda de
%0.5rad/seg. Ademas agregamos un polo rápido en -100 para hacer el
%controlador realizable.
C_p = -(s+0.05)/(s+100);
bode(G_p*C_p);
%Para tener un margen buen margen de fase a una frecuencia de cruce de
%por debajo del limite de 0.5rad/seg, multiplicamos por 76.9dB. 
C_p = -db2mag(76.9)*(s+0.05)/(s+100);
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
