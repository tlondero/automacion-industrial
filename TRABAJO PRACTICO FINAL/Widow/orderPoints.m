function [posFin]=orderPoints(posIni,max_pos)
% ORDERPOINTS Coloca los 4 puntos obtenidos de la imagen en perspectiva a
% su posicion correspondiente.
%     [posFin] = orderPoints(posIni,max_pos) posIni, matriz de 2x4 con los
%     puntos en X e Y originales. max_pos array de 2 elementos,
%     representando el extremo en X e Y de la hoja
    
	aux = posIni;
    posFin = zeros(2,4);
    
    for i=1:2
        % i = 1 : trabajo en X
        % i = 2 : trabajo en Y
        
        for j=1:4            
            % j = 1:2 los dos mas grandes, son las esquinas superiores
            % j = 3:4 los dos mas chicos, son las esquinas inferiores

            [~, ind] = max(aux(i,:));
            if (j <= 2)
                posFin(i,ind) = max_pos(i);    %Esquina mas grande
            else
                posFin(i,ind) = 1;    %Esquina mas chica
            end
            aux(i,ind) = 0;  %Evito tomarlo de nuevo
        end        
    end	
end
