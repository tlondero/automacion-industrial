function [fx, fy] = modelo_fuerza(x)
    %La idea es que esto devuelva la reaccion que tiene la pared sobre el
    %end efector cuando este le aplica presión por lo tanto hasta que no
    %choque con la misma no devolvera ningun valor de fuerza
wall.m=-1;%pendiente de la funcion que describe la pared
wall.b=2;%ordenada a origen de la misma
wall.ke=1000;%coeficiente de rigidez del cuerpo rigido, del modelo f=ke*x\

     x_ee=x(1);
     y_ee=x(2);
     y_pared=wall.m*x_ee+wall.b;
     x_pared= (y_ee-wall.b)/wall.m;
     if((y_ee < y_pared )&&(x_ee < x_pared))%Si no me choque con la pared no hago fuerza
         f=0;
     else
     dist = abs(wall.m*x_ee+2-y_ee)/sqrt(wall.m^2+1); %esto describe la distancia entre la posicion
%     del end efector y la pared por el camino mas corto (Linea ortogonal a la superficie de la pared)
     f=wall.ke*dist;%calculo de la fuerza segun el modelo de rigidez
     end
     fx= f/sqrt(2);
     fy = fx;         

end