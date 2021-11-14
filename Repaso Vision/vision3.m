%% VISION 4 - BLOBS
clear all
close all
clc

%% CARGA DE IMAGEN
im=iread('./Cartel.jpeg'); 
im=idouble(im);
im=imono(im);

ithresh(im)
stop=input('continuar?');
close all

%% DETECCION DE BORDES
K=ksobel();
imbordeh=iconv(im,K);
imbordev=iconv(im,K');
imbordenorm=((imbordeh).^2+(imbordev).^2).^0.5;
idisp(imbordenorm)

stop=input('continuar?');
close all

ithresh(imbordenorm)
imth=imbordenorm>0.14;

stop=input('continuar?');
close all

imlin=Hough(imth);
idisp(imth)
imlin.plot
figure
imlin.lines

stop=input('continuar?');
close all

imthfoc=imth(129:264,316:587);
idisp(imthfoc)
imlin=Hough(imthfoc);
imlin.plot
figure
imlin.lines

stop=input('continuar?');
close all

imlin.suppress=10;
idisp(imthfoc)
imlin.plot

figure

mesh(imlin.A)

stop=input('continuar?');
close all

imlin.houghThresh=0.39;
idisp(imthfoc)
imlin.plot

stop=input('continuar?');
close all

imlin.suppress=20;
idisp(imthfoc)
imlin.plot

lineas=imlin.lines;
lineas

stop=input('continuar?');
close all

imlinea1=generarlinea(lineas(1).rho,lineas(1).theta,size(imthfoc,2),size(imthfoc,1));

idisp(imlinea1)

imlinea2=generarlinea(lineas(2).rho,lineas(2).theta,size(imthfoc,2),size(imthfoc,1));
imlinea3=generarlinea(lineas(5).rho,lineas(5).theta,size(imthfoc,2),size(imthfoc,1));
imlinea4=generarlinea(lineas(11).rho,lineas(11).theta,size(imthfoc,2),size(imthfoc,1));

stop=input('continuar?');
close all

idisp(imthfoc.*imlinea1+imthfoc.*imlinea2+imthfoc.*imlinea3+imthfoc.*imlinea4)
figure
bordescartel=(imlinea1+imlinea2+imlinea3+imlinea4)==2;
idisp(bordescartel)

stop=input('continuar?');
close all

% VER TEORIA EN https://robotacademy.net.au/masterclass/the-geometry-of-image-formation

[fil,col]=find(bordescartel);
posi=zeros(2,4);
posi(2,:)=fil;
posi(1,:)=col;

posf=[1 1 600 600;200 1 1 200];

matH=homography(posi,posf);
warped=homwarp(matH,imthfoc,'full');
warpedth=warped>0.5;
idisp(warpedth)

stop=input('continuar?');
close all

template0=warpedth(265:307,543:569);
figure
cerodetect=isimilarity(template0,warpedth);
mesh(cerodetect)
figure
idisp(cerodetect)

[max,posicion] = peak2(cerodetect, 1, 'npeaks', 5)
