clear all
close all
clc

foto = iread('./Ejemplo1.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);

if(isnan(a))
    disp('No se encontro la imagen')
else
    disp('Se encontro la imagen')
end

foto = iread('./Ejemplo4.png'); 
foto = idouble(foto);
[a,b] = getLineCoords(foto);
if(isnan(a))
    disp('No se encontro la imagen')
else
    disp('Se encontro la imagen')
end