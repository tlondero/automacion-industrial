clear all
close all
clc

%% Ejemplo 1
foto = iread('./Ejemplo1.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);

if(isnan(a))
    disp('No se encontro la imagen 1')
else
    disp('Se encontro la imagen 1')
    sprintf('(%d,%d) a (%d,%d)',a(1),a(2),b(1),b(2)) 
end
%% Ejemplo 2
foto = iread('./Ejemplo2.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);

if(isnan(a))
    disp('No se encontro la imagen 2')
else
    disp('Se encontro la imagen 2')
    sprintf('(%d,%d) a (%d,%d)',a(1),a(2),b(1),b(2))
end
%% Ejemplo 3
foto = iread('./Ejemplo3.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);

if(isnan(a))
    disp('No se encontro la imagen 3')
else
    disp('Se encontro la imagen 3')
    sprintf('(%d,%d) a (%d,%d)',a(1),a(2),b(1),b(2))
end
%% Ejemplo 4
foto = iread('./Ejemplo4.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);
if(isnan(a))
    disp('No se encontro la imagen 4')
else
    disp('Se encontro la imagen 4')
    sprintf('(%d,%d) a (%d,%d)',a(1),a(2),b(1),b(2))
end
%% Ejemplo 5
foto = iread('./Ejemplo5.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);

if(isnan(a))
    disp('No se encontro la imagen 5')
else
    disp('Se encontro la imagen 5')
    sprintf('(%d,%d) a (%d,%d)',a(1),a(2),b(1),b(2))
end
%% Ejemplo 6
foto = iread('./Ejemplo6.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);

if(isnan(a))
    disp('No se encontro la imagen 6')
else
    disp('Se encontro la imagen 6')
    sprintf('(%d,%d) a (%d,%d)',a(1),a(2),b(1),b(2))
end