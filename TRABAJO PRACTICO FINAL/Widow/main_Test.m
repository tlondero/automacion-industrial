clc; clear all; close all;

% Se analiza la imagen

foto = iread('../Vision/Ejemplo1.png'); 
foto = idouble(foto);
[start_pos, end_pos] = getLineCoords(foto);
    
%% Se inicializa el manipulador

% Parametros del manipulador
L1 = 0.130;
L2 = 0.144;
L3 = 0.053;
L4 = 0.144;
L5 = 0.144;

% Parametros de la hoja
w_hoja = 0.2;
l_hoja = 0.15;
init_pos = [0.1,-0.15/2.0]; %x e y de la hoja (respectivamente)
table_height = 0;

hold on
drawTable(w_hoja, l_hoja, init_pos(1), init_pos(2), table_height);
BlackWidow = WidowXMKII(L1,L2,L3,L4,L5,table_height,init_pos);
hold off

%% Se observa el espacio alcanzable

hold on

% BlackWidow.showReachableSpace()

Lp = sqrt(L2^2+L3^2);    
x0 = Lp+L4+L5-0.05;
y0 = 0;
z0 = L1-0.05;

t = 0:0.5:pi*2;
T = [sin(t)*x0;cos(t)*x0;z0+t.*0]';
BlackWidow.moveWidow(T)

hold off

%% Se mueve el manipulador

clc; close all;

if(isnan(start_pos))
    disp('No se encontraron las esquinas')
else    
    T = BlackWidow.createLineTrajectory(start_pos./1000,end_pos./1000);
    BlackWidow.getWidowInPosition(1)
    
    hold on
    drawTable(w_hoja, l_hoja, init_pos(1), init_pos(2), table_height);
    [~,n] = size(T);
    for i=1:n
        x_ = T(1,i) + init_pos(1);
        y_ = T(2,i) + init_pos(2);
        BlackWidow.moveWidow([x_, y_]);
    end
    hold off    
end

