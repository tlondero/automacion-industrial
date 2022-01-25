%% CARGA DE IMAGEN

clear all
close all
clc

foto = iread('./Ejemplo3.png'); 
foto = idouble(foto);
[row,col,~] = size(foto);

%% Filtro verde y rojo

close all

green_filter = zeros(row,col);
red_filter = zeros(row,col);

gf_rgb_th = [130, 70, 130]./255;        %threshold de los colores
rf_rgb_th = [100, 70, 70]./255;        %threshold de los colores

for i=1:row
    for j=1:col
        %filtro solo lo verde
        cond1 = gf_rgb_th(1) > foto(i,j,1);
        cond2 = gf_rgb_th(2) < foto(i,j,2);
        cond3 = gf_rgb_th(3) > foto(i,j,3);        
        if (cond1 && cond2 && cond3)
            green_filter(i,j) = 1;  %es verde
        end
        
        %filtro solo lo rojo
        cond1 = rf_rgb_th(1) < foto(i,j,1);
        cond2 = rf_rgb_th(2) > foto(i,j,2);
        cond3 = rf_rgb_th(3) > foto(i,j,3);        
        if (cond1 && cond2 && cond3)
            red_filter(i,j) = 1;  %es rojo
        end
    end
end

%%

close all

figure()
idisp(foto)
title('Imagen original');

%limpio las imagenes filtradas para tener menos error
S = ones(3,3);
green_filter_l = iopen(green_filter, S);
red_filter_l = iclose(red_filter,S);

figure()
idisp(green_filter_l)
title('Filtro verde');

figure()
idisp(red_filter_l)
title('Filtro rojo');

%% Busco bordes

close all

imlin = Hough(green_filter_l,'suppress',30);
idisp(green_filter_l)
imlin.plot
title('Lineas esquinas Hough');

lineas = imlin.lines;
% Genera 4 imagenes, una con cada linea que obtuvo
% Se deberia chequear que en efecto haya 4 elementos...
imlinea1 = takeLine(lineas(1).rho,lineas(1).theta,col,row);
imlinea2 = takeLine(lineas(2).rho,lineas(2).theta,col,row);
imlinea3 = takeLine(lineas(3).rho,lineas(3).theta,col,row);
imlinea4 = takeLine(lineas(4).rho,lineas(4).theta,col,row);

% Donde se superponen vale 2
bordes_esquinas = (imlinea1+imlinea2+imlinea3+imlinea4)==2;
figure()
idisp(bordes_esquinas)
title('Intersecciones');

[row_, col_] = find(bordes_esquinas);
posi = zeros(2,4);
posi(2,:) = row_;
posi(1,:) = col_;
% posf = [1 1 col-1 col-1;row-1 1 row-1 1];
% CHEQUEAR ESTA FUNCION Y QUE FUNCIONE EN OTROS CASOS
posf = orderPoints(posi,row-1,col-1);

matH = homography(posi,posf);
warped = homwarp(matH,green_filter,'full');
warpedth = warped>0.5;
idisp(warpedth)

%% Se toman las piezas de las esquinas 
%
% gfl_blobs = iblobs(green_filter_l);
% [~,blobs_count] = size(gfl_blobs);
% gfl_blobs_white = [];
% 
% for i=1:blobs_count
%     if(gfl_blobs(i).class && (gfl_blobs(i).area > 200))
%         gfl_blobs_white = [gfl_blobs_white; gfl_blobs(i)];
%     end
% end
%
% close all
% 
% figure(); idisp(green_filter_l)
% gfl_blobs_white
% 
% for i=1:4
%     ymin = gfl_blobs_white(i).umin;
%     ymax = gfl_blobs_white(i).umax;
%     xmin = gfl_blobs_white(i).vmin;
%     xmax = gfl_blobs_white(i).vmax;
% 
%     figure(); idisp(green_filter_l(xmin:xmax,ymin:ymax))
% end
