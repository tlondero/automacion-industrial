function new_colors = change_colors(forms,figure)
new_colors=figure;
for i=1:4
    for j=1:4
        id=(i-1)*110+1;
        jd=(j-1)*110+1;
        switch forms((i-1)*4+j)
            case 1%Si es un rectangulo saco el azul
                for idd=0:99
                    for jdd=0:99
                        if(is_not_white(new_colors(id+idd,jd+jdd,:)))
                            new_colors(id+idd,jd+jdd,3)= new_colors(id+idd,jd+jdd,3)*0;
                        end
                        
                    end
                end
            case 2%si e sun triangulo saco el rojo
                for idd=0:99
                    for jdd=0:99
                        if(is_not_white(new_colors(id+idd,jd+jdd,:)))
                            new_colors(id+idd,jd+jdd,1)= new_colors(id+idd,jd+jdd,1)*0;
                        end
                    end
                end
            case 3%si es un circulo saco el verde
                for idd=0:99
                    for jdd=0:99
                        
                        if(is_not_white(new_colors(id+idd,jd+jdd,:)))
                            new_colors(id+idd,jd+jdd,2)= new_colors(id+idd,jd+jdd,2)*0;
                        end
                    end
                end
        end
    end
    
end
end