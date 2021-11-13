%%
clear all
close all
clc
foto = imread('./Tomi_facha.jpg');

figure()
imshow(foto)

n = 10;
K = ones(n)/(n^2);
Out = iconvolve(foto, K);
figure()
imshow(Out./255)      %Importante dividir por 255

%% Filtrado Gaussiano

w = 10;
sigma = (w - 1)/6     %K siempre es de w x w

K = kgauss(sigma);      
Out = iconvolve(foto, K);
figure()
imshow(Out./255)

%% Irank
clear all
close all
clc
foto = imread('./Tomi_facha.jpg');

foto_gray = rgb2gray(foto);     %irank solo recibe en escala de grices
foto_gray_snp = imnoise(foto_gray, 'salt & pepper', 0.1);   %Le meto ruido
figure()
imshow(foto_gray_snp)

foto_irank = irank(foto_gray_snp, 5, 1);        %Le saco el ruido
figure()
imshow(foto_irank./255)      %Importante dividir por 255

%% Deteccion de bordes
clear all
close all
clc

foto_borde = imread('./Cartel.jpeg');

%K sobel
Kb = ksobel();

Out_h = iconvolve(foto_borde, Kb);
Out_v = iconvolve(foto_borde, Kb');
Out = sqrt(Out_v.^2 + Out_h.^2);           %Unimos las dos imagenes
figure()
imshow(Out./255)
title('K Sobel')

%K Laplace
Kb = klaplace();
Out = iconvolve(foto_borde, Kb);
figure()
imshow(Out./255)
title('K Laplace')

%K LoG
Kb = klog(1);
Out = iconvolve(foto_borde, Kb);
figure()
imshow(Out./255)
title('K LoG')

%% Comparacion NO SE PORQUE NO ANDA

clear all
close all
clc
foto = rgb2gray(imread('./Tomi_facha.jpg'));
tomi_cara = rgb2gray(imread('./Tomi_cara.jpg'));

figure()
imshow(foto)
figure()
imshow(tomi_cara)

S = isimilarity(tomi_cara./255, foto./255, @sad); %@sad, @ssd, @ncc, @zsad, @zssd
%k = max(S, [], 'omitnan');
%S = S./k;
%[mx,p] = peak2(S, 1, 'npeaks',5);

figure()
idisp(S, 'colormap', 'jet', 'bar')


%% Corke example

clear all
close all
clc

T = iread('wally.png', 'double');
crowd = iread('wheres-wally.png', 'double');

S = isimilarity(T, crowd, @zncc);
idisp(S, 'colormap', 'jet', 'bar')
[~,p] = peak2(S, 1, 'npeaks', 5);
idisp(crowd)

plot_circle(p, 30, 'fillcolor', 'b', 'alpha', 0.3, 'edgecolor', 'none')
plot_point(p, 'sequence', 'bold', 'textsize', 24, 'textcolor', 'k', 'Marker', 'none')