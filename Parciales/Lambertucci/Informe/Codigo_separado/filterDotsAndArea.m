
function blobData = filterDotsAndArea(fig)
%aqui solo saco los que son vacios
blobData=iblobs(fig);
[~, blobCount]=size(blobData);
if blobCount>1
    i=1;
    while(blobCount-1)
        if((blobData(1,i).area>9000) || (blobData(1,i).area<10))
            blobData(i)=[];
            blobCount=blobCount-1;
        else
            i=i+1;
        end
    end
    
end
end

