function [posFin]=orderPoints5(posIni,max_pos)
% ORDERPOINTS5 Coloca los 4 puntos obtenidos de la imagen en perspectiva a
% su posicion correspondiente.

    corner_1 = 0;       % 1    2 
    corner_2 = 0;       % 3    4
    corner_3 = 0;
    corner_4 = 0;

    posFin = zeros(2,4);	
    for index=1:2   % Coloco 2 esquinas
        u = 0;
        v = 0;
        for i=1:2
            sorted = sort(posIni(i,:));
            if(posIni(i,index) == sorted(3) || posIni(i,index) == sorted(4))
                posFin(i,index) = max_pos(i);
                if (i == 1)
                    u = 1;
                else
                    v = 1;
                end
            else
                posFin(i,index) = 1;
            end            
        end
        
        if (~u && ~v)
            corner_1 = 1;
        elseif (u && ~v)
            corner_2 = 1;
        elseif (~u && v)
            corner_3 = 1;
        else
            corner_4 = 1;
        end
    end
    
    if (corner_1 && corner_2)     
        if(posIni(1,3) < posIni(1,4))
            % El tercero es esquina 3            
            posFin(1,3) = 1;
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 4
            posFin(1,4) = max_pos(1);
            posFin(2,4) = max_pos(2);
        else
            % El tercero es esquina 4            
            posFin(1,3) = max_pos(1);
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 3
            posFin(1,4) = 1;
            posFin(2,4) = max_pos(2);
        end
    elseif (corner_1 && corner_3)
        if(posIni(2,3) < posIni(2,4))
            % El tercero es esquina 2            
            posFin(1,3) = max_pos(1);
            posFin(2,3) = 1;
            
            % El cuarto es esquina 4
            posFin(1,4) = max_pos(1);
            posFin(2,4) = max_pos(2);
        else
            % El tercero es esquina 4            
            posFin(1,3) = max_pos(1);
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 2
            posFin(1,4) = max_pos(1);
            posFin(2,4) = 1;
        end
    elseif (corner_1 && corner_4)
        if(posIni(1,3) < posIni(1,4))
            % El tercero es esquina 3            
            posFin(1,3) = 1;
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 2
            posFin(1,4) = max_pos(1);
            posFin(2,4) = 1;
        else
            % El tercero es esquina 2            
            posFin(1,3) = max_pos(1);
            posFin(2,3) = 1;
            
            % El cuarto es esquina 3
            posFin(1,4) = 1;
            posFin(2,4) = max_pos(2);
        end
    elseif (corner_2 && corner_3)
        if(posIni(2,3) < posIni(2,4))
            % El tercero es esquina 1            
            posFin(1,3) = 1;
            posFin(2,3) = 1;
            
            % El cuarto es esquina 4
            posFin(1,4) = max_pos(1);
            posFin(2,4) = max_pos(2);
        else
            % El tercero es esquina 4            
            posFin(1,3) = max_pos(1);
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 1
            posFin(1,4) = 1;
            posFin(2,4) = 1;
        end
    elseif (corner_2 && corner_4)
        if(posIni(2,3) < posIni(2,4))
            % El tercero es esquina 1            
            posFin(1,3) = 1;
            posFin(2,3) = 1;
            
            % El cuarto es esquina 3
            posFin(1,4) = 1;
            posFin(2,4) = max_pos(2);
        else
            % El tercero es esquina 3            
            posFin(1,3) = 1;
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 1
            posFin(1,4) = 1;
            posFin(2,4) = 1;
        end                
    else
        if(posIni(2,3) < posIni(2,4))
            % El tercero es esquina 1            
            posFin(1,3) = 1;
            posFin(2,3) = 1;
            
            % El cuarto es esquina 4
            posFin(1,4) = max_pos(1);
            posFin(2,4) = max_pos(2);
        else
            % El tercero es esquina 4            
            posFin(1,3) = max_pos(1);
            posFin(2,3) = max_pos(2);
            
            % El cuarto es esquina 1
            posFin(1,4) = 1;
            posFin(2,4) = 1;
        end 
    end
    
end