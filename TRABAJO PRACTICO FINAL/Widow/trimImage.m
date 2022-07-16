function [xmin, xmax, ymin, ymax]=trimImage(img)  
% TRIMIMAGE Se recorta la imagen de la hoja vista de frente devolviendo los
% nuevos limites.
    
    S = ones(5,5);
    gfl_blobs = iblobs(iopen(img,S));
    [~,blobs_count] = size(gfl_blobs);
    blobs_white = [];

    for i=1:blobs_count
        if(gfl_blobs(i).class && (gfl_blobs(i).area > 200))
            blobs_white = [blobs_white; gfl_blobs(i)];
        end
    end
        
    [final,~] = size(blobs_white);
    x = zeros(1,final*2);
    y = zeros(1,final*2);
    for i=1:2:final*2
        y(i) = blobs_white((i+1)/2).umin;
        y(i+1) = blobs_white((i+1)/2).umax;
        x(i) = blobs_white((i+1)/2).vmin;
        x(i+1) = blobs_white((i+1)/2).vmax;
    end
    
    xmin = min(x);
    xmax = max(x);
    ymin = min(y);
    ymax = max(y);
end