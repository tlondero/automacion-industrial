function [posFin]=orderPoints3(posIni,max_pos,toggle)
% ORDERPOINTS3 Coloca los 4 puntos obtenidos de la imagen en perspectiva a
% su posicion correspondiente.
    
	corner_1 = 0;	% 1   2
	corner_2 = 0;	% 3   4
	
	aux = posIni;
    posFin = zeros(2,4);
	
    
	[~,index] = max(aux(1,:));			% Primer max en u	
	posFin(1,index) = max_pos(1);		% Lo mando al max
	
    if(toggle)
        posFin = orderPoints(posIni,max_pos);        
    else
       if(posIni(2,index) == max(aux(2,:)))
            posFin(2,index) = 1;
        else
            posFin(2,index) = max_pos(2);
            corner_2 = 1;
        end    
	
        aux(1,index) = 0;
        aux(2,index) = 0;

        [~,index] = max(aux(1,:));			% Segundo max en u	
        posFin(1,index) = max_pos(1);		% Lo mando al max
        
        if(posIni(2,index) == max(aux(2,:)))	
            if(~corner_2)
                posFin(2,index) = 1;
            else
                posFin(2,index) = max_pos(2);
            end
        else
            if(corner_2)
                posFin(2,index) = 1;
            else
                posFin(2,index) = max_pos(2);
            end
        end 
 
        aux(1,index) = 0;
        aux(2,index) = 0;

        [~,index] = max(aux(1,:));			% Tercer max en u
        posFin(1,index) = 1;				% Lo mando al min	

        if(posIni(2,index) == max(aux(2,:)))
            posFin(2,index) = max_pos(2);
        else
            posFin(2,index) = 1;
            corner_1 = 1;
        end

        aux(1,index) = 0;
        aux(2,index) = 0;

        [~,index] = max(aux(1,:));			% Cuarto max en u	
        posFin(1,index) = 1;		% Lo mando al min

        if(~corner_1)
            posFin(2,index) = 1;
        else
            posFin(2,index) = max_pos(2);
        end    
    end
end