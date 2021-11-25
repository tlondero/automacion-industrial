clear all
close all
clc
salt=rand(430)>0.996;
pepper=rand(430)>0.996;
base=zeros(430,430);
base(101:110,:)=ones(10,430);
base(211:220,:)=ones(10,430);
base(321:330,:)=ones(10,430);
base=(base+base')>0;

for i=1:4
    for j=1:4
        posrf=ceil(rand()*30);
        posrc=ceil(rand()*30);
        minf=1+(i-1)*110+posrf;
        minc=1+(j-1)*110+posrc;
        base(minf:minf+30,minc:minc+30)=figurarandom();
    end
end
base=base+salt-pepper;
base=base>0;
basecolor=zeros(430,430,3);
basecolor(:,:,1)=base;
basecolor(:,:,2)=base;
basecolor(:,:,3)=base;

cr=ones(100,100);
pestr=rand(4)>0.5;
pestg=rand(4)>0.5;
pestb=(pestr+pestg)<2;

for i=1:4
    for j=1:4
        if pestr(i,j)==1
            minf=1+(i-1)*110;
            minc=1+(j-1)*110;
            basecolor(minf:minf+99,minc:minc+99,1)=cr;
        end
        if pestb(i,j)==1
            minf=1+(i-1)*110;
            minc=1+(j-1)*110;
            basecolor(minf:minf+99,minc:minc+99,3)=cr;
        end
        if pestg(i,j)==1
            minf=1+(i-1)*110;
            minc=1+(j-1)*110;
            basecolor(minf:minf+99,minc:minc+99,2)=cr;
        end
    end
end

clc
% --------------------------NO TOCAR NADA ENCIMA DE ESTA LINEA-------------------------------
% --------------NO USAR EN EL PROGRAMA NINGUNA VARIABLE QUE ESTE SOBRE ESTA LINEA------------


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


function form =detect_form(blob_data)
nada=0; rectangulo=1; triangulo=2; circulo=3; undefined=4;
form=undefined;%defualt es indefinido
ba=blob_data.b/blob_data.a;%saco la relacion ba
H=blob_data.vmax-blob_data.vmin;
%Aharro el ancho y alto
W=blob_data.umax-blob_data.umin;

delta_area=abs(H*W-blob_data.area);
%calculo el delta de area
threshold_area_rectangulo=70;
if((blob_data.area>9000) || (blob_data.area<10))
    form=nada;%%No era nada    
elseif(delta_area< threshold_area_rectangulo)
    form=rectangulo; %%Aproximo el area, si da cerca era un rectangulo
elseif (ba>0.99)
    form=circulo;%%Este es el caso para diferenciar del cuadrado perfecto
    
elseif ((ba> 0.841) && (ba < 0.897))
    form=triangulo;%%Me fijo la razon del triangulo dado que siempre e sle mismo tipo de triangulo
    %en el caso de que haya triangulos de diversos angulos, utilizaria
    %una verificacion similar a las otras donde me fijo si es de un
    %area similar
    %unicamente la  verificacion de areas
end
end


function blobData = filterDotsAndArea(fig)
%aqui solo saco los que son vacios
blobData=iblobs(fig);
[~, blobCount]=size(blobData);
if blobCount>1
    i=1;
    while(blobCount-1)
        if((blobData(1,i).area>9000) || (blobData(1,i).area<10))
            blobData(i)=[];
            blobCount=blobCount-1;
        else
            i=i+1;
        end
    end
    
end
end


function print_forms(forms)
words=["","","","";
    "","","","";
    "","","","";
    "","","",""];
nada= 0;
rectangulo=  1;
triangulo =2;
circulo  =3;
undefined=4;
    
for i=1:4
    for j=1:4
        if(forms((i-1)*4+j) ==nada)
            words(i,j)="Vacio";
        elseif(forms((i-1)*4+j) ==rectangulo)
            words(i,j)="Rectangulo";
        elseif(forms((i-1)*4+j) ==triangulo)
            words(i,j)="Triangulo";
        elseif(forms((i-1)*4+j) ==circulo)
            words(i,j)="Circulo";
        elseif(forms((i-1)*4+j) ==undefined)
            words(i,j)="Indedfinido";
        end
        
    end
end

disp(words)
end

function new_colors = change_colors(forms,figure)
new_colors=figure;
for i=1:4
    for j=1:4
        id=(i-1)*110+1;
        jd=(j-1)*110+1;
        switch forms((i-1)*4+j)
            case 1%Si es un rectangulo saco el azul
                for idd=0:99
                    for jdd=0:99
                        if(is_not_white(new_colors(id+idd,jd+jdd,:)))
                            new_colors(id+idd,jd+jdd,3)= new_colors(id+idd,jd+jdd,3)*0;
                        end
                        
                    end
                end
            case 2%si e sun triangulo saco el rojo
                for idd=0:99
                    for jdd=0:99
                        if(is_not_white(new_colors(id+idd,jd+jdd,:)))
                            new_colors(id+idd,jd+jdd,1)= new_colors(id+idd,jd+jdd,1)*0;
                        end
                    end
                end
            case 3%si es un circulo saco el verde
                for idd=0:99
                    for jdd=0:99
                        
                        if(is_not_white(new_colors(id+idd,jd+jdd,:)))
                            new_colors(id+idd,jd+jdd,2)= new_colors(id+idd,jd+jdd,2)*0;
                        end
                    end
                end
        end
    end
    
end
end

function not_white=is_not_white(val)
    if((round(val(1),2)==1) && (round(val(2),2)==1) && (round(val(3),2)==1))
        not_white=0;
    else
        not_white=1;
    end
end