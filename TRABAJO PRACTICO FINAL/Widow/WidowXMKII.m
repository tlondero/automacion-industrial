classdef WidowXMKII < handle
    properties 
        Widow;
        currPos;
        Qtarget;
        Lp;
        L1;
        L2;
        L3;
        L4;
        L5;
        table_height;
        rotation;
    end
    methods
        %Metodos de la clase
        function obj=WidowXMKII(L1,L2,L3,L4,L5,table_height,init_pos)
            obj.L1 = L1;
            obj.L2 = L2;
            obj.L3 = L3;
            obj.L4 = L4;
            obj.L5 = L5;            
            obj.Lp = sqrt(L2^2+L3^2);
            
            L(1)=Link([0 L1 0 0]);
            L(2)=Link([0 0 0 pi/2]);
            L(3)=Link([0 0 obj.Lp 0]);
            L(4)=Link([0 0 L4 0]);
            L(5)=Link([0 0 L5 0]);
            
            obj.Widow=SerialLink(L);
            obj.Widow.name = 'WidowXMKII';
            
            obj.rotation = [1, 0, 0;
                            0, 0, -1;
                            0, 1, 0];
            
            obj.table_height = table_height;
            obj.currPos = [0,0,obj.table_height+0.05];            
            obj.moveWidow(init_pos);
        end
        function moveWidow(obj,position, rotation_)
            
            if ~exist('rotation_')
                rotation_ = obj.rotation;
            end
            
            [s_T, ~] = size(position);            
            P = [position, ones(s_T,1).*obj.currPos(3)];            
            T = [rotation_, P'; 0, 0, 0, 1];
            
            obj.Qtarget = obj.Widow.ikine(T, 'mask', [1 1 1 1 0 1]);
            obj.Widow.plot(obj.Qtarget);
            xlim([-obj.Lp-obj.L4*2-0.2, obj.Lp+obj.L4*2+0.2]);
            ylim([-obj.Lp-obj.L4*2-0.2, obj.Lp+obj.L4*2+0.2]);
            zlim([0, obj.Lp+obj.L4+obj.L1]);
            obj.currPos = [position, obj.currPos(3)];
        end
        function pos=getPosition(obj)
            pos=obj.currPos;
        end
        function valid=isReachable(obj,position)
            q=obj.Widow.ikine(transl(position), 'mask', [1 1 1 0 0 0]);
            valid=~isempty(q);
        end
        function getWidowInPosition(obj,down)
            if (down)
                obj.currPos(3) = obj.table_height;
            else
                obj.currPos(3) = obj.table_height + 0.05;
            end            
        end                 
        function showReachableSpace(obj)
            t1 = linspace(-180,180,180)*pi/180;
            t2 = linspace(-90,90,10)*pi/180;
            t3 = linspace(-90,90,10)*pi/180;
            t4 = linspace(-180,180,40)*pi/180;            
            [T1,T2,T3,T4] = ndgrid(t1,t2,t3,t4);
            
            xM = cos(T1).*(obj.Lp*cos(T2)+obj.L4*cos(T2+T3)+obj.L5*cos(T2+T3+T4)); % and use it in x y z as T4
            yM = sin(T1).*(obj.Lp*cos(T2)+obj.L4*cos(T2+T3)+obj.L5*cos(T2+T3+T4));
            zM = obj.L1+obj.Lp*sin(T2)+obj.L4*sin(T2+T3)+obj.L5*sin(T2+T3+T4);

    %             R = [[cos(T1).*cos(T2+T3+T4) -cos(T1).*sin(T2+T3+T4) sin(T1)];
    %                 [sin(T1).*cos(T2+T3+T4) -sin(T1).*sin(T2+T3+T4) -cos(T1)];
    %                 [sin(T2+T3+T4) cos(T2+T3+T4) zeros(size(T1))]];

            plot3(xM(:),yM(:),zM(:),'o')
        end
    end 
    methods(Static)
        function T=createLineTrajectory(InitialPosition,FinalPosition)
            %T = [-t.*1+x0; t.*0+y0; t.*0+z0].';
            xi=InitialPosition(1);
            yi=InitialPosition(2);
            xo=FinalPosition(1);
            yo=FinalPosition(2);
            b=(yo-yi)/(xo-xi);
            m=yo-xo*b;
            x=linspace(xi,xo,100);
            y=x*b+m;
            T=[x;y];
        end
    end
end