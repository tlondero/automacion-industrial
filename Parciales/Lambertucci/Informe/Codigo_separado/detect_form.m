function form =detect_form(blob_data)
nada=0; rectangulo=1; triangulo=2; circulo=3; undefined=4;
form=undefined;%defualt es indefinido
ba=blob_data.b/blob_data.a;%saco la relacion ba
H=blob_data.vmax-blob_data.vmin;
%Aharro el ancho y alto
W=blob_data.umax-blob_data.umin;

delta_area=abs(H*W-blob_data.area);
%calculo el delta de area
threshold_area_rectangulo=50;
if((blob_data.area>9000) || (blob_data.area<10))
    form=nada;%%No era nada
elseif(delta_area< threshold_area_rectangulo)
    form=rectangulo; %%Aproximo el area, si da cerca era un rectangulo
elseif (ba>0.99)
    form=circulo;%%Este es el caso para diferenciar del cuadrado perfecto
    
elseif ((ba> 0.851) && (ba < 0.887))
    form=triangulo;%%Me fijo la razon del triangulo dado que siempre e sle mismo tipo de triangulo
    %en el caso de que haya triangulos de diversos angulos, utilizaria
    %una verificacion similar a las otras donde me fijo si es de un
    %area similar
    %unicamente la  verificacion de areas
end
end
