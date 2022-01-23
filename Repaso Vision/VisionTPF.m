%% CARGA DE IMAGEN

clear all
close all
clc

foto = iread('./Ejemplo.png'); 
foto = idouble(foto);

%% Filtro verde y rojo

close all

green_filter = foto;
red_filter = foto;
gf_rgb_th = [130, 70, 130]./255;        %threshold de los colores
rf_rgb_th = [100, 70, 70]./255;        %threshold de los colores
[row,col,~] = size(foto);

for i=1:row
    for j=1:col
        %chequeo si es verde
        cond1 = gf_rgb_th(1) > green_filter(i,j,1);
        cond2 = gf_rgb_th(2) < green_filter(i,j,2);
        cond3 = gf_rgb_th(3) > green_filter(i,j,3);        
        if (cond1 && cond2 && cond3)
            green_filter(i,j,:) = [1,1,1];  %es verde
        else
            green_filter(i,j,:) = [0,0,0];  %no es verde
        end
        cond1 = rf_rgb_th(1) < red_filter(i,j,1);
        cond2 = rf_rgb_th(2) > red_filter(i,j,2);
        cond3 = rf_rgb_th(3) > red_filter(i,j,3);        
        if (cond1 && cond2 && cond3)
            red_filter(i,j,:) = [1,1,1];  %es rojo
        else
            red_filter(i,j,:) = [0,0,0];  %no es verde
        end
    end
end

green_filter = rgb2gray(green_filter);
red_filter = rgb2gray(red_filter);

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
imlinea1 = takeLine(lineas(1).rho,lineas(1).theta,col,row);
imlinea2 = takeLine(lineas(2).rho,lineas(2).theta,col,row);
imlinea3 = takeLine(lineas(3).rho,lineas(3).theta,col,row);
imlinea4 = takeLine(lineas(4).rho,lineas(4).theta,col,row);

% Donde se superponen vale 2
bordes_esquinas = (imlinea1+imlinea2+imlinea3+imlinea4)==2;
figure()
idisp(bordes_esquinas)
title('Intersecciones');

[fil,col] = find(bordes_esquinas);
posi = zeros(2,4);
posi(2,:) = fil;
posi(1,:) = col;

posf=[1 1 938 938;630 1 630 1];

matH = homography(posi,posf);
warped = homwarp(matH,green_filter,'full');
warpedth = warped>0.5;
idisp(warpedth)

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
%Puede ser util para reescribir generar linea de Rodo
% for i=1:total
%     theta = lineas(i).theta;
%     rho = lineas(i).rho;
%     xc = rho*cos(theta);
%     yc = rho*sin(theta);
%     
%     pendiente = -tan(theta);
%     ordenada = yc + tan(theta)*xc;         
% end

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
