function [matrizfigura] = figurarandom()
d4=ceil(rand()*4);
figura=zeros(31,31);
switch d4
    case 1
        figura=kcircle(15);
    case 2
        alto=5+ceil(rand()*25);
        ancho=5+ceil(rand()*25);
        figura(1:alto,1:ancho)=ones(alto,ancho);
    case 3
        figura=ktriangle(30);
    case 4
end
matrizfigura = figura;
end
% --------------------------NO TOCAR NADA ENCIMA DE ESTA LINEA-------------------------------
% --------------NO USAR EN EL PROGRAMA NINGUNA VARIABLE QUE ESTE SOBRE ESTA LINEA------------