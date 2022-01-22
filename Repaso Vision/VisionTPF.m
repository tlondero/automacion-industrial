%% CARGA DE IMAGEN

clear all
close all
clc

foto = iread('./Ejemplo.png'); 
foto = idouble(foto);

%% Filtro información verde

close all

green_filter = foto;
gf_rgb_th = [130, 70, 130]./255;        %threshold de los colores
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
    end
end

green_filter = rgb2gray(green_filter);

%%

close all

title('Imagen original');
imshow(foto)
figure()

title('Filtro verde sin limpiar');
imshow(green_filter)
figure()

%limpio las imagenes filtradas para tener menos error
S = ones(3,3);
% green_filter_l = iclose(iopen(green_filter, S), S);
% green_filter_l = iopen(iclose(green_filter, S), S);
green_filter_l = iopen(green_filter, S);

title('Filtro verde limpia');
imshow(green_filter_l)

gfl_blobs = iblobs(green_filter_l);
[~,blobs_count] = size(gfl_blobs);
gfl_blobs_white = [];

for i=1:blobs_count
    if(gfl_blobs(i).class && (gfl_blobs(i).area > 200))
        gfl_blobs_white = [gfl_blobs_white; gfl_blobs(i)];
    end
end

%% Busco bordes

close all

imlin = Hough(green_filter_l,'suppress',30);
idisp(green_filter_l)
imlin.plot

lineas = imlin.lines;

%CODIGO RODO
% Genera 4 imagenes, una con cada linea que obtuvo
imlinea1=generarlinea(lineas(1).rho,lineas(1).theta,size(green_filter_l,2),size(green_filter_l,1));
imlinea2=generarlinea(lineas(2).rho,lineas(2).theta,size(green_filter_l,2),size(green_filter_l,1));
imlinea3=generarlinea(lineas(3).rho,lineas(3).theta,size(green_filter_l,2),size(green_filter_l,1));
imlinea4=generarlinea(lineas(4).rho,lineas(4).theta,size(green_filter_l,2),size(green_filter_l,1));

% Imagen filtrara * linea que se superpone (para cada linea)
idisp(green_filter_l.*imlinea1+green_filter_l.*imlinea2+green_filter_l.*imlinea3+green_filter_l.*imlinea4)
figure()

% Donde se superponen, no vale 1, vale 2!!
bordescartel=(imlinea1+imlinea2+imlinea3+imlinea4)==2;
idisp(bordescartel)
%CODIGO RODO

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
