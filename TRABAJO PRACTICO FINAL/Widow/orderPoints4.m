function [posFin]=orderPoints4(posIni,max_pos)
% ORDERPOINTS4 Coloca los 4 puntos obtenidos de la imagen en perspectiva a
% su posicion correspondiente.

	aux = posIni;
    posFin = zeros(2,4);
	
    while(min(min(posFin)) == 0)
        [~,index] = max(aux(1,:));        
        if(aux(1,:) == zeros(1,4))
            [~,index] = max(aux(2,:));
        end
        
        posIni_order = sort(posIni(1,:));            
        if(posIni(1,index) == max(posIni(1,:)))   % El mas grande
            posFin(1,index) = max_pos(1);
            aux(1,index) = 0;
        elseif(posIni(2,index) == min(posIni(1,:)))   % El mas chico
            posFin(2,index) = 1;
            aux(1,index) = 0;
        elseif (posIni(1,index) == posIni_order(3)) % El 2 mas grande
            
        end
        
        if(posIni(2,index) == max(posIni(2,:)))
            posFin(2,index) = max_pos(2);
            aux(2,index) = 0;
        elseif(posIni(2,index) == min(posIni(2,:)))
            posFin(2,index) = 1;
            aux(2,index) = 0;
        end    
        
    end
end