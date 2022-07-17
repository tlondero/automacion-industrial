function [row_,col_,deteled]=deleteRedundancy(row,col,tolerancy_x,tolerancy_y)
    row_ = row;
    col_ = col;
	[row_max,~] = size(row);
	[col_max,~] = size(col);
    deteled = 0;
	
    for i=1:row_max
		done = 0;
        for j=1:col_max
            tol_x = (abs((row(i) - row(j))) <= tolerancy_x);
            tol_y = (abs((row(i) - row(j))) <= tolerancy_y);
            if((i ~= j) && tol_x && tol_y)
                row_(j) = [];
				col_(j) = [];
                done = 1;
                break
            end			
        end
		
		if(done)
            deteled = 1;
			break
		end
    end
	
end
