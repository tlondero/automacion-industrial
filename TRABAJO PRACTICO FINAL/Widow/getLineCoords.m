function [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea]=getLineCoords(green_filter,green_filter_l,green_filter_l2,green_filter_l3.green_filter_l4,red_filter_l,debug_state,umax,vmax)
% GETLINECOORDS Encuentra la linea roja en la imagen
%     [pos1, pos2, Bordes, warpedth_g, warpedth_r, final_linea]=getLineCoords(green_filter_l,green_filter_l2, green_filter_l3,red_filter_l)
%     Devuelve coordenadas de inicio y fin de la linea roja de la imagen
%     reescalada a 150 x 200. Devuelve también las imagenes empleadas en el
%     proceso.
%      
%     [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea]=getLineCoords(green_filter_l,green_filter_l2, green_filter_l3,red_filter_l,debug_state,umax,vmax)
%     Devuelve coordenadas de inicio y fin de la linea roja de la imagen en
%     umax y vmax. Devuelve también las imagenes empleadas en el proceso.
% 
%     En caso de no encontrar los 4 puntos que identifican la seccion
%     verde, retorna las dos coordenadas con NaN.
    
    if ~exist('umax','var')
        umax = 150;
    end
    if ~exist('vmax','var')
        vmax = 200;
    end
    if ~exist('debug_state','var')
        debug_state = 0;
    end    

	%% Busco bordes
    
    %Intento 1: Filtrado + limpiado
    [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea] = getBorders(green_filter_l, red_filter_l, umax, vmax, debug_state);
    
    %Esto se podría hacer recursivo, pero no tiene sentido porque si se
    %limpia con N mas grande que ~3 las lineas empiezan a desaparecer
    if(isnan(pos1))
        %Intento 2: Filtrado + limpiado x2
        [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea] = getBorders(green_filter_l2, red_filter_l, umax, vmax, debug_state);
        if(isnan(pos1))
            %Intento 3: Filtrado solo
            [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea] = getBorders(green_filter, red_filter_l, umax, vmax, debug_state);
            if(isnan(pos1))
                %Intento 4: Filtrado + limpiado x3
                [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea] = getBorders(green_filter_l3, red_filter_l, umax, vmax, debug_state);
                if(isnan(pos1))
                    %Intento 5: Filtrado + limpiado grande
                    [pos1, pos2,Bordes,warpedth_g,warpedth_r,final_linea] = getBorders(green_filter_l4, red_filter_l, umax, vmax, debug_state);
                end
            end
        end
    end

	
end