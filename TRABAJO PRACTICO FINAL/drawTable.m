function drawTable(width,length,x0,y0,z0,color)
% DRAWTABLE Dibuja los cuatro lados de la mesa en el dibujo 3D
%     drawTable(width,length,x0,y0,color) width y length son el largo y
%     ancho de la mesa. X0, Y0 y Z0 es la coordenada inferior izquierda de la
%     mesa en el plano y la altura. Color: opcional, array de RGB double.

    if ~exist('color')
        color = [0, 0, 1];
    end
	
	X = [x0, x0 + width, x0 + width, x0];
	Y = [y0, y0, y0 + length, y0 + length];
	Z = [z0, z0, z0, z0];
    
    h = fill3(X,Y,Z,[0, 0, 1]);
    h.FaceColor = color;
    h.FaceAlpha = 0.3;
    
end