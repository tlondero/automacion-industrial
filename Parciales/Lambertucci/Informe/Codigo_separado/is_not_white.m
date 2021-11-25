function not_white=is_not_white(val)
    if((round(val(1),2)==1) && (round(val(2),2)==1) && (round(val(3),2)==1))
        not_white=0;
    else
        not_white=1;
    end
end