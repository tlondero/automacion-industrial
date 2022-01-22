%% Erosion
clear all
close all
clc
%foto = imread('./Tomi_facha.jpg');
foto = imread('./poronga.jpg');
fotooriginal=foto;
fotor=(foto(:,:,1));
fotog=(foto(:,:,2));
fotob=(foto(:,:,3));
S = ones(10,15);
mnr = imorph(fotor, S, 'min');
mng = imorph(fotog, S, 'min');
mnb = imorph(fotob, S, 'min');

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;
figure()
imshow([fotooriginal foto]);
title('imorph min')



%% Dilatacion

clear all
close all
clc
% foto = imread('./Tomi_facha.jpg');
foto = imread('./el_pelusita.jfif');
fotooriginal=foto;
S = ones(5,5);
fotor=(foto(:,:,1));
fotog=(foto(:,:,2));
fotob=(foto(:,:,3));
mnr = imorph(fotor, S, 'max');
mng = imorph(fotog, S, 'max');
mnb = imorph(fotob, S, 'max');

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;
figure()
imshow([fotooriginal foto]);

title('imorph max')
% 
% mn = idilate(foto, S);
% figure()
% imshow(mn)
% title('idilate')

%% Apertura

clear all
close all
clc
foto = imread('./Tomi_facha.jpg');



S_h = ones(20,5);
S_w = ones(5,20);
S = ones(20,20);

fotooriginal=foto;

fotor=(foto(:,:,1));
fotog=(foto(:,:,2));
fotob=(foto(:,:,3));
mnr = iopen(fotor, S_h);
mng = iopen(fotog, S_h);
mnb = iopen(fotob, S_h);

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;
fotoh=foto;



mnr = iopen(fotor, S_w);
mng = iopen(fotog, S_w);
mnb = iopen(fotob, S_w);

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;
fotow=foto;



mnr = iopen(fotor, S);
mng = iopen(fotog, S);
mnb = iopen(fotob, S);

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;

fotos=foto;
figure()
imshow([fotooriginal fotoh fotow fotos]);
title('open')

%% Cierre

clear all
close all
clc
foto = imread('./Tomi_facha.jpg');



S_h = ones(15,5);
S_w = ones(5,20);
S = ones(20,20);

fotooriginal=foto;

fotor=(foto(:,:,1));
fotog=(foto(:,:,2));
fotob=(foto(:,:,3));
mnr = iclose(fotor, S_h);
mng = iclose(fotog, S_h);
mnb = iclose(fotob, S_h);

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;
fotoh=foto;



mnr = iclose(fotor, S_w);
mng = iclose(fotog, S_w);
mnb = iclose(fotob, S_w);

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;
fotow=foto;



mnr = iclose(fotor, S);
mng = iclose(fotog, S);
mnb = iclose(fotob, S);

foto(:,:,1)=mnr;
foto(:,:,2)=mng;
foto(:,:,3)=mnb;

fotos=foto;
figure()
imshow([fotooriginal fotoh fotow fotos]);
title('close')


%% Filtrado de ruido

clear all
close all
clc
foto =imnoise(rgb2gray(imread('./lena.png')),'salt & pepper',0.1);

figure()
imshow(foto)

S = kcircle(1);

closed = iclose(foto, S);
clean = iopen(closed, S);

figure();
imshow(clean./255);
title('close -> open');

opened = iopen(foto, S);
clean = iclose(opened, S);
figure();
imshow(clean./255);
title('open -> close');

%VER HIT OR MISS I GUESS THEY NEVER MISS UH?
%% Hito or miss

clear all
close all
clc
foto =rand(500,500)>.3 % Increase number for less ones, decrease for more.;
T=ones(4);
H= hitormiss(foto,T);
figure();
imshow(foto);
title('original'); 
figure();
imshow(H);
title('resultado');     
%% Manchitas de caca
clear all
close all
clc
foto = imnoise(rgb2gray(imread('./broi.png')),'salt & pepper',0.1);
S = kcircle(1);

opened = iclose(foto, S);
clean = iopen(opened, S);

S = ones(10,5);
mn = imorph(clean, S, 'min');

out=clean-mn;
figure();
imshow(out);
title('resultado'); 

%% Tamaño: Sampling
clear all
close all
clc
foto = imread('./Tomi_cara.jpg');
%foto = rgb2gray(imread('./Tomi_facha.jpg'));

figure()
imshow(foto)

smallerR = foto(1:2:end, 1:2:end,1);
smallerG = foto(1:2:end, 1:2:end,2);
smallerB = foto(1:2:end, 1:2:end,3);
[H,W]=size(smallerR);
fotoRGBchikina=zeros(H,W,3);
fotoRGBchikina(:,:,1)=smallerR;
fotoRGBchikina(:,:,2)=smallerG;
fotoRGBchikina(:,:,3)=smallerB;

figure()
imshow(uint8(fotoRGBchikina))
[H_o W_o RGB]=size(foto);
scale=14
BIGGUSDICKUS_R=zeros(H_o*scale,W_o*scale);
BIGGUSDICKUS_G=zeros(H_o*scale,W_o*scale);
BIGGUSDICKUS_B=zeros(H_o*scale,W_o*scale);
BIGGUSDICKUS=zeros(H_o*scale,W_o*scale,3);
for i = 1:(H_o-1)*scale
    for j = 1:(W_o-1)*scale
        BIGGUSDICKUS_R(i,j)=foto(uint16(i/scale)+1,uint16(j/scale)+1,1);
        BIGGUSDICKUS_G(i,j)=foto(uint16(i/scale)+1,uint16(j/scale)+1,2);
        BIGGUSDICKUS_B(i,j)=foto(uint16(i/scale)+1,uint16(j/scale)+1,3);
    end
end
BIGGUSDICKUS(:,:,1)=BIGGUSDICKUS_R;
BIGGUSDICKUS(:,:,2)=BIGGUSDICKUS_G;
BIGGUSDICKUS(:,:,3)=BIGGUSDICKUS_B;

figure()
imshow(uint8(BIGGUSDICKUS))

%% Warping

clear all
close all
clc
%foto = imread('./Tomi_cara.jpg');
foto = rgb2gray(imread('./Tomi_facha.jpg'));

[Ui, Vi] = imeshgrid(foto);
[Uo, Vo] = imeshgrid(690,690);

U = 2*(Uo-100);
V = 2*(Vo-200);

tomismol = interp2(Ui, Vi, idouble(foto), U, V);
figure()
imshow(tomismol)
