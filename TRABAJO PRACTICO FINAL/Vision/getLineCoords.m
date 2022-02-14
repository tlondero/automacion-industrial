function [pos1, pos2]=getLineCoords(foto,umax,vmax)
% GETLINECOORDS Encuentra la linea roja en la imagen
%     [pos1, pos2] = getLineCoords(foto) Devuelve coordenadas de inicio y
%     fin de la linea roja de la imagen reescalada a 1500 x 2000.
%      
%     [pos1, pos2] = getLineCoords(foto,umax,vmax) Devuelve coordenadas de
%     inicio y fin de la linea roja de la imagen reescalada a umax x vmax.
% 
%     En caso de no encontrar los 4 puntos que identifican la seccion
%     verde, retorna las dos coordenadas con NaN.
    
    if ~exist('umax','var')
        umax = 1500;
    end
    if ~exist('vmax','var')
        vmax = 2000;
    end

	foto = idouble(foto);
	[row,col,~] = size(foto);

% 	%% Filtro verde y rojo
% 
% 	green_filter = zeros(row,col);
% 	red_filter = zeros(row,col);
% 	
% 	gf_rgb_th = [130, 70, 130]./255;        %threshold de verde
% 	rf_rgb_th = [100, 70, 70]./255;        %threshold de rojo
% 
% 	for i=1:row
% 		for j=1:col
% 			%filtro solo lo verde
% 			cond1 = gf_rgb_th(1) > foto(i,j,1);
% 			cond2 = gf_rgb_th(2) < foto(i,j,2);
% 			cond3 = gf_rgb_th(3) > foto(i,j,3);        
% 			if (cond1 && cond2 && cond3)
% 				green_filter(i,j) = 1;  %es verde
% 			end
% 			
% 			%filtro solo lo rojo
% 			cond1 = rf_rgb_th(1) < foto(i,j,1);
% 			cond2 = rf_rgb_th(2) > foto(i,j,2);
% 			cond3 = rf_rgb_th(3) > foto(i,j,3);        
% 			if (cond1 && cond2 && cond3)
% 				red_filter(i,j) = 1;  %es rojo
% 			end
% 		end
%     end
%     
% 	% (RGB) Limpio las imagenes filtradas para tener menos error
% 	
% 	%S = ones(3);
% 	%green_filter_l = iopen(green_filter, S);
%     green_filter_cl = iclose(green_filter, ones(5));
%     green_filter_cl2 = iclose(green_filter, ones(7));
% 	  green_filter_l = iopen(green_filter_cl, ones(3));
%     green_filter_l2 = iopen(green_filter_cl, ones(3), 2);
%     green_filter_l3 = iopen(green_filter_cl, ones(3), 3);
%     green_filter_l4 = iopen(green_filter_cl2, ones(11));
%     red_filter_l = iclose(red_filter,ones(7));
%     red_filter_l = iopen(red_filter_l,ones(3));
    
    %% Filtro hsv
    hsv_foto = rgb2hsv(foto);
    
    hsv_green_filter = zeros(row,col);
	hsv_red_filter = zeros(row,col);
    
    %0 grados hue = rojo
    hsv_redhue_hi = (-7.5+27.5)/360; %27.5 grados adelante de -7.5 grados
    hsv_redhue_lo = ((-7.5+360)-27.5)/360; %27.5 grados atras de -7.5 grados
    %~120 grados hue = verde
    hsv_greenhue_hi = (110+80)/360; %80 grados arriba de 110 grados
    hsv_greenhue_lo = (110-75)/360; %75 grados abajo de 110 grados
    
    hsv_sat_lo = 0.14;
    hsv_val_hi = 0.55;
    hsv_val_lo = 0.25;
    
    for i=1:row
		for j=1:col
            %Filtro rojo
            cond1 = hsv_redhue_hi > hsv_foto(i, j, 1);
            cond2 = hsv_redhue_lo < hsv_foto(i, j, 1);
            cond3 = hsv_sat_lo < hsv_foto(i, j, 2);
            cond4 = hsv_val_lo < hsv_foto(i, j, 3);
            cond5 = hsv_val_hi > hsv_foto(i,j,3);
            if ((cond1 || cond2) && cond3 && cond4 && cond5) %cond1 y cond2 con OR porque hue rojo cruza por el valor 0
				hsv_red_filter(i,j) = 1;  %es rojo
            end
            
            %Filtro verde
            cond1 = hsv_greenhue_hi > hsv_foto(i, j, 1);
            cond2 = hsv_greenhue_lo < hsv_foto(i, j, 1);
            cond3 = hsv_sat_lo < hsv_foto(i, j, 2);
            cond4 = hsv_val_lo < hsv_foto(i, j, 3);
            cond5 = hsv_val_hi > hsv_foto(i,j,3);
            if (cond1 && cond2 && cond3 && cond4 && cond5)
				hsv_green_filter(i,j) = 1;  %es verde
            end
        end
    end
    
    red_filter = hsv_red_filter;
    green_filter = hsv_green_filter;
    
	% (HSV) Limpio las imagenes filtradas para tener menos error
    green_filter_cl = iclose(green_filter, ones(5));
    green_filter_cl2 = iclose(green_filter, ones(7));
	green_filter_l = iopen(green_filter_cl, ones(3));
    green_filter_l2 = iopen(green_filter_cl, ones(3), 2);
    green_filter_l3 = iopen(green_filter_cl, ones(3), 3);
    green_filter_l4 = iopen(green_filter_cl2, ones(11));
    red_filter_l = iclose(red_filter,ones(7));
    red_filter_l = iopen(red_filter_l,ones(3));
    

	%% Busco bordes
    
    %Intento 1: Filtrado + limpiado
    [pos1, pos2] = getBorders(green_filter_l, red_filter_l, umax, vmax);
    
    %Esto se podría hacer recursivo, pero no tiene sentido porque si se
    %limpia con N mas grande que ~3 las lineas empiezan a desaparecer
    if(isnan(pos1))
        %Intento 2: Filtrado + limpiado x2
        [pos1, pos2] = getBorders(green_filter_l2, red_filter_l, umax, vmax);
        if(isnan(pos1))
            %Intento 3: Filtrado solo
            [pos1, pos2] = getBorders(green_filter, red_filter_l, umax, vmax);
            if(isnan(pos1))
                %Intento 4: Filtrado + limpiado x3
                [pos1, pos2] = getBorders(green_filter_l3, red_filter_l, umax, vmax);
                if(isnan(pos1))
                    %Intento 5: Filtrado + limpiado grande
                    [pos1, pos2] = getBorders(green_filter_l4, red_filter_l, umax, vmax);
                end
            end
        end
    end

	
end