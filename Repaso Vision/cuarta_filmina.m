%% Threshold
clear all
close all
clc

foto = imread('./Tomi_facha.jpg');
figure()
imshow(foto)
title('El toMMo Gamer')

figure()
histogram(foto(:,:,1)) %histograma R
title('Histograma en R')

[H W tuvi] = size(foto);
foto_threashold = rgb2gray(foto);

thr_r = otsu(foto(:,:,1));
thr_g = 100;
thr_b = 100;

for i = 1:H
    for j = 1:W
        if((foto(i,j,1)>thr_r) && (foto(i,j,2) < thr_g) && (foto(i,j,3) < thr_b))
           foto_threashold(i,j) = 255;
        else
           foto_threashold(i,j) = 0;
        end
    end
end

figure()
imshow(foto_threashold)
title('Threshold')
iblobs(foto_threashold)

S = ones(5,5);
foto_open = iopen(foto_threashold, S);
figure()
imshow(foto_open)
title('Open')
iblobs(foto_open)

for i = 1:H
    for j = 1:W
        if(foto_open(i,j)==255)
            foto(i,j,2) = 200;
            foto(i,j,1) = 0;
        end
    end
end

figure()
imshow(foto)
title('El toMMo Gamer')


%% nickelback

clear all
close all
clc

foto = rgb2gray(imread('./Tomi_facha.jpg'));
figure()
imshow(foto)
title('El toMMo Gamer')

t = niblack(foto, -0.2, 50);
figure()
idisp(abs(t));
title('nickelback')

figure()
idisp(foto >= abs(t));
title('look at this photograph')

% Ver MSER

%% Segmentacion

clear all
close all
clc

foto = rgb2gray(imread('./Anash2.png'));
figure()
imshow(foto)
title('Anashe')

foto_anashe = uint8(ilabel(foto));

k = uint8(255/max(max(foto_anashe)));
figure()
imshow(foto_anashe.*k)
title('Ananashe')

iblobs(foto_anashe)

%% Hough

clear all
close all
clc

foto = rgb2gray(imread('./Cartel.jpeg'));
figure()
imshow(foto)
title('Cartel')

h = Hough(foto, 'equal');

figure()
imshow(foto)
title('Cartel lineas')
h.plot(20)

figure()
h.show()