function [row_,col_,deteled]=deleteRedundancy(row,col)
    row_ = row;
    col_ = col;
	[row_max,~] = size(row);
	[col_max,~] = size(col);
    deteled = 0;
	
    for i=1:row_max
		done = 0;
        for j=1:col_max
            if((i ~= j) && (abs((row(i) - row(j))) <= 10))
                row_(i) = [];
				col_(i) = [];
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
