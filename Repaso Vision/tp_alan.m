clc; clear all;

%% NO TOCAR
clear all
close all
clc
imagen=zeros(1000);

% generador de formas - rectangulos
for i=1:10
    for j=1:10
        generar=rand(); %generar <0.4 crea forma en cuadrante
        dondex=floor(rand()*100);
        dondey=floor(rand()*100);
        
        if generar<0.4
            imagen(i*100-dondex,j*100-dondey)=1;
            size=rand()*50;
            actual=0;
            flag=0;
            for p=1:98
                
                if flag==1
                    actual=actual+1;
                end
                
                if actual>size
                    break
                end
                
                for q=1:98
                    
                    if imagen(i*100-p,j*100-q)==1
                        flag=1;
                        imagen(i*100-p-1,j*100-q)=1;
                        imagen(i*100-p,j*100-q-1)=1;
                        imagen(i*100-p-1,j*100-q-1)=1;
                    end
                    
                end
            end
        end

    end
end



% agregar ruido

for i=1:1000
    for j=1:1000
        k=rand();
        if k<0.02
            imagen(i,j)=1; %ruido blanco

        end
    end
end
%% NO TOCAR    
idisp(imagen)
        
%% PUEDEN COLOCAR SU CODIGO A PARTIR DE ESTE TITULO`
S = ones(2,2);
imagen_limpia = iopen(imagen, S);
imagen_limpia = iclose(imagen_limpia, S);
figure();
idisp(imagen_limpia);
title('limpiada');

blobberz = iblobs(imagen_limpia)

%% Eligo el broder + grande que sea rectangulo estrictamente
[M, I] = max(blobberz.area);
blobberz(I) = [];      %% elimino el area negra

while 1
   [~, I] = max(blobberz.area);
   if(blobberz(I).theta == 0.00 || blobberz(I).theta == 1.57)
       break;
   else
       blobberz(I) = [];
   end
end

biggest.index = I;
biggest.area = blobberz(I).area
biggest.b = blobberz(I).b
biggest.a = blobberz(I).a
biggest.c = blobberz(I).p

p_movil_start = uint16([biggest.c(1) biggest.c(2)-biggest.b-1]);
p_movil_end = p_movil_start;
times = 10;
while ( (times > 0) && (p_movil_end(1) ~= 1) && (p_movil_end(2) ~= 1))
    
    while imagen_limpia(p_movil_end(2)-1,p_movil_end(1)) == 0
        if(p_movil_end(2) > 2)
            p_movil_end = [p_movil_end(1) p_movil_end(2)-1];
        else
            break;
        end
    end
    p_movil_end = [p_movil_end(1) p_movil_end(2)+2];
    P_1 = double([p_movil_start(1) p_movil_start(2)]);
    P_2 = double([p_movil_end(1) p_movil_end(2)]);
    imagen_limpia = iline(imagen_limpia, P_1, P_2);
    p_movil_start = p_movil_end;
    
    while imagen_limpia(p_movil_end(2),p_movil_end(1)-1) == 0
        if(p_movil_end(1) > 2)
            p_movil_end = [p_movil_end(1)-1 p_movil_end(2)];
        else
            break;
        end
    end
        p_movil_end = [p_movil_end(1)+2 p_movil_end(2)];
    P_1 = double([p_movil_start(1) p_movil_start(2)]);
    P_2 = double([p_movil_end(1) p_movil_end(2)]);
    imagen_limpia = iline(imagen_limpia, P_1, P_2);
    p_movil_start = p_movil_end;
    
    times = times - 1;
end

P1 = double(uint16([biggest.c(1)-biggest.a/0.85, biggest.c(2)-biggest.b/0.85]))
P2 = double(uint16([biggest.c(1)+biggest.a/0.85, biggest.c(2)-biggest.b/0.85]))
P3 = double(uint16([biggest.c(1)+biggest.a/0.85, biggest.c(2)+biggest.b/0.85]))
P4 = double(uint16([biggest.c(1)-biggest.a/0.85, biggest.c(2)+biggest.b/0.85]))

imagen_limpia = iline(imagen_limpia, P1, P2);
imagen_limpia = iline(imagen_limpia, P2, P3);
imagen_limpia = iline(imagen_limpia, P3, P4);
imagen_limpia = iline(imagen_limpia, P4, P1);
idisp(imagen_limpia);