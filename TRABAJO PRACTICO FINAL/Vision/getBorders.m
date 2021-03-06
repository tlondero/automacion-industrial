function [pos1, pos2]=getBorders(green_filter_l, red_filter_l, umax, vmax)

    green_filter = green_filter_l;
    [row,col] = size(green_filter_l);

    imlin = Hough(green_filter_l,'suppress',30);
	lineas = imlin.lines;
	[~,line_count,~] = size(lineas);
	
	x_min = NaN;
	y_min = NaN;
	x_max = NaN;
	y_max = NaN;
	
	if(line_count==4)   % Chequeo que haya 4 elementos

		% Genera 4 imagenes, una con cada linea que obtuvo
		imlinea1 = takeLine(lineas(1).rho,lineas(1).theta,col,row);
		imlinea2 = takeLine(lineas(2).rho,lineas(2).theta,col,row);
		imlinea3 = takeLine(lineas(3).rho,lineas(3).theta,col,row);
		imlinea4 = takeLine(lineas(4).rho,lineas(4).theta,col,row);

		% Donde se superponen vale 2
		bordes_esquinas = (imlinea1+imlinea2+imlinea3+imlinea4)==2;

		[row_, col_] = find(bordes_esquinas);
		posi = zeros(2,4);
		posi(2,:) = row_;
		posi(1,:) = col_;
		posf = orderPoints(posi,row-1,col-1);

		% Se rota tanto la imagen verde como la roja
		matH = homography(posi,posf);
		warpedth_g = (homwarp(matH,green_filter,'full'))>0.5;
		warpedth_r = (homwarp(matH,red_filter_l,'full'))>0.5;

		% Se corta y reescala la imagen 
		[xmin, xmax, ymin, ymax] = trimImage(warpedth_g);
		final_linea = warpedth_r(xmin:xmax,ymin:ymax);
        final_linea = imresize(final_linea,[umax,vmax]);
		
		% Se busca los extremos de la linea roja
        
		 [row_fin,col_fin,~] = size(final_linea);	
		 fl_hough = Hough(final_linea,'suppress',30);
		 imlinea5 = takeLine(fl_hough.lines.rho,fl_hough.lines.theta,col_fin,row_fin);
		 fin_sup = imlinea5.*final_linea;

		[x_min, y_min] = find(fin_sup,1,'first');
		[x_max, y_max] = find(fin_sup,1,'last');
	end
	
	pos1 = [x_min, y_min];
	pos2 = [x_max, y_max];
end

