classdef WidowXMKII < handle
    properties 
        Widow;
        currPos;
        Qtarget;
    end
    methods
        %Metodos de la clase
        function obj=WidowXMKII(L1,L2,L3,L4,L5)
            Lp=sqrt(L2^2+L3^2);
            L(1)=Link([0 L1 0 0]);
            L(2)=Link([0 0 0 pi/2]);
            L(3)=Link([0 0 Lp 0]);
            L(4)=Link([0 0 L4 0]);
            L(5)=Link([0 0 L5 0]);
            obj.Widow=SerialLink(L);
            obj.Widow.name = 'WidowXMKII';
        end
        function moveWidow(obj,position)
            obj.Qtarget = obj.Widow.ikine(transl(position), 'mask', [1 1 1 0 0 0]);
            obj.Widow.plot(obj.Qtarget);
            obj.currPos=obj.Qtarget(end,:);
        end
        function pos=getPosition(obj)
            pos=obj.currPos;
        end
        function valid=isReachable(obj,position)
            q=obj.Widow.ikine(transl(position), 'mask', [1 1 1 0 0 0]);
            valid=~isempty(q);
        end
    end
end