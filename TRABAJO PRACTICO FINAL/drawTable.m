function drawTable(width,length,x0,y0,z0,color)
% DRAWTABLE Dibuja los cuatro lados de la mesa en el dibujo 3D
%     drawTable(width,length,x0,y0,color) width y length son el largo y
%     ancho de la mesa. X0, Y0 y Z0 es la coordenada inferior izquierda de la
%     mesa en el plano y la altura. Color: opcional, son las mismas opciones que posee
%     la funcion plot().

    if ~exist('color')
        color = 'blue';
    end
    
    x = linspace(x0,x0+width,1000);
	y = y0 + x.*0;
	plot3(x,y,z0 + x.*0,color);

	y = y0 + length + x.*0;
	plot3(x,y,z0 + x.*0,color);

	y = linspace(y0,y0 + length,1000);
	x = x0 + y.*0;
	plot3(x,y,z0 + y.*0,color);

	x = x0 + width + y.*0;
	plot3(x,y,z0 + y.*0,color);    
end