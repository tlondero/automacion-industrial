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