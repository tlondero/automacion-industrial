function [imagen]=takeLine(rho,theta,utot,vtot)
% TAKELINE Toma una linea generada por Hough y genera una imagen binaria
% con dicha linea.
%     [imagen] = takeLine(rho,theta,utot,vtot) rho y yheta son parametros
%     de las lineas de Houg, mientras que utot y vtot son el tamaño de la imagen.
    
    imagen = zeros(vtot,utot);
    xc = rho*cos(theta);
    yc = rho*sin(theta);
    
    pendiente = -tan(theta);
    ordenada = rho/cos(theta);
    
    for i=1:utot
        y = round(pendiente*i+ordenada);
        if((y>0) && (y<vtot))
            imagen(y,i) = 1;
        end
    end
    
    for j=1:vtot
        x = round(j/pendiente-ordenada/pendiente);
        if((x>0) && (x<utot))
            imagen(j,x) = 1;
        end
    end    
end