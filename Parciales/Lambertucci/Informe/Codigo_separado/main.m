%Posibles formas
nada=0;rectangulo=1;triangulo=2;
circulo=3;undefined=4;
%Muestro cuadro original
idisp(basecolor)
title('Original')
%Separo en marcos R G y B la imagen original
fotor=(basecolor(:,:,1));
fotog=(basecolor(:,:,2));
fotob=(basecolor(:,:,3));

mnr = irank(fotor, 4,1);
mng = irank(fotog, 4,1);
mnb = irank(fotob, 4,1);

basecolor_nl=basecolor.*0;%armo un cuadro de iguales dimensiones
basecolor_nl(:,:,1)=mnr;
basecolor_nl(:,:,2)=mng;
basecolor_nl(:,:,3)=mnb;
%Asigno los marcos filtrados

figure()
idisp(basecolor_nl)
title('Filtrado')%%Muestro el filtrado

gray_figures=rgb2gray(basecolor_nl);
iblobs(gray_figures)%%Lo paso a grayscale

figs=zeros(100,100,16);

for i = 1:4
    for j=1:4
       id=(i-1)*110+1;
       jd=(j-1)*110+1;
       figs(:,:,(i-1)*4+j)=gray_figures(id:(id+99),jd:(jd+99));%Lo separo en marcos
    end
end


forms=[];
%Hasta aca agarro los cuadros por separados y filtrados
colored_frame=basecolor_nl;
%copio el marco filtrado

for i=1:16
    blob_data = filterDotsAndArea(figs(:,:,i));
    %Saco los vacios
    forms(i)=detect_form(blob_data);
    %Detecto formas
end
print_forms(forms)
%Los imprimo
new_colors=change_colors(forms,basecolor_nl);
%Cambio los colores acorde a la consigna
figure()
idisp(new_colors)
title('Colores Cambiados')
