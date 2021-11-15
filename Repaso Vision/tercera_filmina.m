%% Erosion
clear all
close all
clc
foto = imread('./Tomi_facha.jpg');

figure()
imshow(foto)

S = ones(1,100);
mn = imorph(foto, S, 'min');
figure()
imshow(mn)
title('imorph min')

% mn = ierode(foto, S);
% figure()
% imshow(mn)
% title('ierode')

%% Dilatacion

clear all
close all
clc
foto = imread('./Tomi_facha.jpg');

figure()
imshow(foto)

S = ones(20,20);
% mn = imorph(foto, S, 'max');
% figure()
% imshow(mn)
% title('imorph max')

mn = idilate(foto, S);
figure()
imshow(mn)
title('idilate')

%% Apertura

clear all
close all
clc
foto = imread('./Tomi_facha.jpg');

figure()
imshow(foto)

S_h = ones(20,5);
S_w = ones(5,20);
S = ones(20,20);

mn = iopen(foto, S_h);
figure()
imshow(mn)
title('open height')

mn = iopen(foto, S_w);
figure()
imshow(mn)
title('open wide')

mn = iopen(foto, S);
figure()
imshow(mn)
title('open')

%% Cierre

clear all
close all
clc
foto = imread('./Tomi_facha.jpg');

figure()
imshow(foto)

S_h = ones(20,5);
S_w = ones(5,20);
S = ones(20,20);

mn = iclose(foto, S_h);
figure()
imshow(mn)
title('close height')

mn = iclose(foto, S_w);
figure()
imshow(mn)
title('close wide')

mn = iclose(foto, S);
figure()
imshow(mn)
title('close')

%% Filtrado de ruido

clear all
close all
clc
foto = imnoise(imread('./Tomi_facha.jpg'), 'salt & pepper');

figure()
imshow(foto)

S = kcircle(1);

closed = iclose(foto, S);
clean = iopen(closed, S);
figure()
imshow(clean)
title('close -> open')

opened = iopen(foto, S);
clean = iclose(opened, S);
figure()
imshow(clean)
title('open -> close')

%VER HIT OR MISS I GUESS THEY NEVER MISS UH?

%% Tamaño: Sampling
clear all
close all
clc
foto = imread('./Tomi_facha.jpg');
%foto = rgb2gray(imread('./Tomi_facha.jpg'));

figure()
imshow(foto)

smaller = foto(1:7:end, 1:7:end);
figure()
imshow(smaller)

% Aliasing