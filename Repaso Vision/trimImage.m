function [xmin, xmax, ymin, ymax]=trimImage(img)  
    
    S = ones(5,5);
    gfl_blobs = iblobs(iopen(img,S));
    [~,blobs_count] = size(gfl_blobs);
    blobs_white = [];

    for i=1:blobs_count
        if(gfl_blobs(i).class && (gfl_blobs(i).area > 200))
            blobs_white = [blobs_white; gfl_blobs(i)];
        end
    end
    
    x = [];
    y = [];

    for i=1:4
        y = [y, blobs_white(i).umin, blobs_white(i).umax];
        x = [x, blobs_white(i).vmin, blobs_white(i).vmax];
        % figure(); idisp(green_filter_l(xmin:xmax,ymin:ymax))
    end
    
    xmin = min(x);
    xmax = max(x);
    ymin = min(y);
    ymax = max(y);
end