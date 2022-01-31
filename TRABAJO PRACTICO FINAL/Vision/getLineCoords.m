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
% 	S = ones(3);
% 	green_filter_l = iopen(green_filter, S);
% 	red_filter_l = iclose(red_filter,S);
    
    %% Filtro hsv
    hsv_foto = rgb2hsv(foto);
    
    hsv_green_filter = zeros(row,col);
	hsv_red_filter = zeros(row,col);
    
    %0 grados hue = rojo
    hsv_redhue_hi = (0+30)/360; %30 grados adelante de 0 grados
    hsv_redhue_lo = (360-30)/360; %30 grados atras de 0 grados
    %70 grados hue = verde
    hsv_greenhue_hi = (85+45)/360; %40 grados arriba de 70 grados
    hsv_greenhue_lo = (85-45)/360; %30 grados arriba de 70 grados
    
    hsv_sat_lo = 0.134;
    hsv_val_hi = 0.56;
    hsv_val_lo = 0.24;
    
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
	
	S = ones(3);
	green_filter_l = iopen(green_filter, S);
	red_filter_l = iopen(red_filter,S);
    

	%% Busco bordes

	imlin = Hough(green_filter_l,'suppress',30);
	lineas = imlin.lines;
	[~,line_count,~] = size(lineas);
	
	x_min = NaN;
	y_min = NaN;
	x_max = NaN;
	y_max = NaN;
	
	if(line_count==4)   % Chequeo que haya 4 elementos

		% Genera 4 imagenes, una con cada linea que obtuvo
		imlinea1 = takeLine(lineas(1).rho,lineas(1).theta,col,row);
		imlinea2 = takeLine(lineas(2).rho,lineas(2).theta,col,row);
		imlinea3 = takeLine(lineas(3).rho,lineas(3).theta,col,row);
		imlinea4 = takeLine(lineas(4).rho,lineas(4).theta,col,row);

		% Donde se superponen vale 2
		bordes_esquinas = (imlinea1+imlinea2+imlinea3+imlinea4)==2;

		[row_, col_] = find(bordes_esquinas);
		posi = zeros(2,4);
		posi(2,:) = row_;
		posi(1,:) = col_;
		posf = orderPoints(posi,row-1,col-1);

		% Se rota tanto la imagen verde como la roja
		matH = homography(posi,posf);
		warpedth_g = (homwarp(matH,green_filter,'full'))>0.5;
		warpedth_r = (homwarp(matH,red_filter_l,'full'))>0.5;

		% Se corta y reescala la imagen 
		[xmin, xmax, ymin, ymax] = trimImage(warpedth_g);
		final_linea = warpedth_r(xmin:xmax,ymin:ymax);
        final_linea = imresize(final_linea,[umax,vmax]);
		
		% Se busca los extremos de la linea roja
        
		% [row_fin,col_fin,~] = size(final_linea);	% Esto de acá es para ser finoli
		% fl_hough = Hough(final_linea,'suppress',30); % Se podria saltar a la linea 132 con final_linea
		% imlinea5 = takeLine(fl_hough.lines.rho,fl_hough.lines.theta,col_fin,row_fin);
		% fin_sup = imlinea5.*final_linea;

		[x_min, y_min] = find(final_linea,1,'first');
		[x_max, y_max] = find(final_linea,1,'last');
	else
		% Ver que se puede hacer cuando no se encuentran las 4 lineas
	end
	
	pos1 = [x_min, y_min];
	pos2 = [x_max, y_max];
	
end