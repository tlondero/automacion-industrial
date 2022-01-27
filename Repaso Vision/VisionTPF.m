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
posf = orderPoints(posi,row-1,col-1);

% Se rota tanto la imagen verde como la roja
matH = homography(posi,posf);
warped = homwarp(matH,green_filter,'full');
warpedth_g = warped>0.5;
idisp(warpedth_g)

matH = homography(posi,posf);
warped = homwarp(matH,red_filter_l,'full');
warpedth_r = warped>0.5;
idisp(warpedth_r)

%% Se corta la imagen final

close all

[xmin, xmax, ymin, ymax] = trimImage(warpedth_g);

final_bordes = warpedth_g(xmin:xmax,ymin:ymax);
final_linea = warpedth_r(xmin:xmax,ymin:ymax);

figure()
idisp(final_bordes)
title('Resultado final bordes');

figure()
idisp(final_linea)
title('Resultado final linea roja');

%% Se busca los extremos de la linea roja

close all

% Esto de acá es para ser finoli
% Se podria saltar a la linea 132 con final_linea
[row_fin,col_fin,~] = size(final_linea);
fl_hough = Hough(final_linea,'suppress',30);
imlinea5 = takeLine(fl_hough.lines.rho,fl_hough.lines.theta,col_fin,row_fin);
fin_sup = imlinea5.*final_linea;

[x_min, y_min] = find(fin_sup,1,'first');
[x_max, y_max] = find(fin_sup,1,'last');

limits = zeros(row_fin,col_fin);
limits(x_min,y_min) = 1;
limits(x_max, y_max) = 1;

figure()
idisp(limits)
title('Limites de linea roja');