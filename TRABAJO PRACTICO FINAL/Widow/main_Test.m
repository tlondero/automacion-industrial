clc; clear all; close all;

% Analisis de la imagen
foto = iread('../Vision/Ejemplo5.png'); 
foto = idouble(foto);
[start_pos, end_pos] = getLineCoords(foto);

start_pos = start_pos./1000;    % Cambio de escala
end_pos = end_pos./1000;

% Parametros de inicializacion
% Del manipulador
L1 = 0.130;
L2 = 0.144;
L3 = 0.053;
L4 = 0.144;
L5 = 0.144;

% De la hoja
w_hoja = 0.2;
l_hoja = 0.15;
table_origin = [0,0.35]; %x e y de la hoja (respectivamente)
table_height = L1;
marker_offset = 0.05;

% Inicializacion del manipulador y dibujo de hoja

hold on
drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);
BlackWidow = WidowXMKII(L1,L2,L3,L4,L5,table_height+marker_offset,table_origin);
hold off

%% Espacio alcanzable del manipulador

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

if(isnan(start_pos))
    disp('No se encontraron las esquinas')
else
    
    x0 = table_origin(1) + start_pos(2);
    y0 = table_origin(2) - start_pos(1);
    xf = table_origin(1) + end_pos(2);
    yf = table_origin(2) - end_pos(1);
    
    BlackWidow.getWidowInPosition(1)
    
    P_ = BlackWidow.createLineTrajectory([x0, y0],[xf, yf],20);
    [row_P, col_P] = size(P_);
    R = [1, 0, 0;
         0, 0, -1;
         0, 1, 0];
    cur_pos = BlackWidow.getPosition();
    
    P = [P_', ones(col_P,1).*cur_pos(3)]';    
    T = zeros(4,4,col_P);
    
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    
    hold on
    
    drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);    
    BlackWidow.moveWidow(T);    
    BlackWidow.getWidowInPosition(0)
    hold off    
end


%% Dibujo linea en la mesa

clc
hold on
X = [table_origin(1)+start_pos(2),table_origin(1)+end_pos(2)];
Y = [table_origin(2)-start_pos(1),table_origin(2)-end_pos(1)];
Z = [table_height,table_height];
plot3(X,Y,Z,'Color','red');
hold off

%% Llevo el manipulador al origen

hold on
drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);
BlackWidow.moveWidowXY([table_origin(1),table_origin(2)]);
hold off

%% Llevo el manipulador al extremo opuesto

hold on
drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);
BlackWidow.moveWidowXY([table_origin(1)+w_hoja,table_origin(2)-l_hoja]);
hold off    