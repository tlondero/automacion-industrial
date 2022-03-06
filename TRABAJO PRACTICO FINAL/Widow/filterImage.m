function [green_filter,green_filter_l,green_filter_l2, green_filter_l3,red_filter_l]=filterImage(foto,hsv_sat_lo,hsv_val_hi,hsv_val_lo)
% FILTERIMAGE Realiza un filtrado de la imagen que se le provee. 
%     [green_filter,green_filter_l,green_filter_l2, green_filter_l3,red_filter_l]=filterImage(foto,hsv_sat_lo,hsv_val_hi,hsv_val_lo)
%     Devuelve los filtros procesados de la imagen original
    
	foto = idouble(foto);
	[row,col,~] = size(foto);
   
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
    
	if(hsv_sat_lo == 0)
		hsv_sat_lo = 0.14;
	end
	if(hsv_val_hi == 0)
		hsv_val_hi = 0.55;
	end
	if(hsv_val_lo == 0)
		hsv_val_lo = 0.25;
	end
    
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
	
end