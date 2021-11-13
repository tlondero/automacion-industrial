%%
clear all
close all
clc
foto = imread('./el_tomo.png');
figure()

imshow(foto)
title('El toMMo Gamer')

figure()
histogram(foto(:,:,1)) %histograma R
title('R')

figure()
histogram(foto(:,:,2)) %histograma G
title('G')

figure()
histogram(foto(:,:,3)) %histograma B
title('B')

foto_gray= rgb2gray(foto);
figure()
imshow(foto_gray)
title('El ToMMo muerio F')

figure()
histogram(foto_gray)
title('Gray')

%%
clear all
close all
clc
foto = imread('./tomi_facha.jpg');
figure()

imshow(foto)
title('original')
foto_gray= rgb2gray(foto);
[H W] = size(foto_gray);
foto_threashold= foto_gray.*0;
THRESHOLD=145;
for i = 1:H
    for j = 1:W
        if(foto_gray(i,j)< THRESHOLD)
           foto_threashold(i,j) = 0;
        else
           foto_threashold(i,j) = 255;
        end
    end
end
figure()
imshow(foto_threashold)
title('Threshold')
%%




clear all
close all
clc
foto =rgb2gray(imread('./baw_obs.png'));
figure()

imshow(foto)
title('Oskuridad')

[H W] = size(foto);

figure()
histogram(foto)

nice=90;
value=255/nice;
for i = 1:H
    for j = 1:W
        if(foto(i,j)< nice)
           foto(i,j) = int32(foto(i,j)*value);
         else
            foto(i,j) = 255;
        end
    end
end

figure()
imshow(foto)
title('Klaritud')

figure()
histogram(foto)
%% Tomi Berde
clear all
close all
clc
foto =imread('./poronga.jpg');
fondo =imread('./fondo.jpg');
figure()
imshow(foto)
title('tomi greenscreen')

[H W RGB] = size(foto);

for i = 1:H
    for j = 1:W
        if((foto(i,j,1) <  80) && ((foto(i,j,2) >  200)) && (foto(i,j,3) <  80) )
            foto(i,j,1) = fondo(i,j,1);
            foto(i,j,2) = fondo(i,j,2);
            foto(i,j,3) = fondo(i,j,3);
        end
    end
end

figure()
imshow(foto)
title('Tomi RAD')








