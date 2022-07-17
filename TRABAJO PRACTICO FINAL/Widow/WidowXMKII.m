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
            obj.currPos = [init_pos, obj.table_height+0.05];
            T = [obj.rotation, obj.currPos';
                    0, 0, 0, 1];
            obj.moveWidow(T);
        end
        function moveWidow(obj,T)             
            obj.Qtarget = obj.Widow.ikine(T, 'mask', [1 1 1 1 0 1]);
            obj.Widow.plot(obj.Qtarget);
            xlim([-obj.Lp-obj.L4*2-0.2, obj.Lp+obj.L4*2+0.2]);
            ylim([-obj.Lp-obj.L4*2-0.2, obj.Lp+obj.L4*2+0.2]);
            zlim([-0.6, obj.Lp+obj.L4+obj.L1]);
            obj.currPos = T(1:3,4,end);
        end
        function moveWidowXY(obj,pos)
            obj.currPos(1) = pos(1);
            obj.currPos(2) = pos(2);            
            T = [obj.rotation, obj.currPos; 0, 0, 0, 1];
            obj.Qtarget = obj.Widow.ikine(T, 'mask', [1 1 1 1 0 1]);
            obj.Widow.plot(obj.Qtarget);
            xlim([-obj.Lp-obj.L4*2-0.2, obj.Lp+obj.L4*2+0.2]);
            ylim([-obj.Lp-obj.L4*2-0.2, obj.Lp+obj.L4*2+0.2]);
            zlim([-0.6, obj.Lp+obj.L4+obj.L1]);
            obj.currPos = T(1:3,4,end);
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
        function showReachableSpace(obj,abst1,abst2,abst3,abst4)
            hold on
            cla
            obj.moveWidowXY(obj.currPos);
            t1 = linspace(-double(abst1),double(abst1),double(abst1))*pi/180;
            t2 = linspace(-double(abst2),double(abst2),10.0)*pi/180;
            t3 = linspace(-double(abst3),double(abst3),10.0)*pi/180;
            t4 = linspace(-double(abst4),double(abst4),40.0)*pi/180;            
            [T1,T2,T3,T4] = ndgrid(t1,t2,t3,t4);
            
            xM = cos(T1).*(obj.Lp*cos(T2)+obj.L4*cos(T2+T3)+obj.L5*cos(T2+T3+T4)); % and use it in x y z as T4
            yM = sin(T1).*(obj.Lp*cos(T2)+obj.L4*cos(T2+T3)+obj.L5*cos(T2+T3+T4));
            zM = obj.L1+obj.Lp*sin(T2)+obj.L4*sin(T2+T3)+obj.L5*sin(T2+T3+T4);
            plot3(xM(:),yM(:),zM(:),'o')
            hold off
        end
         function P=createDownwardTrajectory(obj,xyCoords,step,downward)
            xi=xyCoords(1);
            yi=xyCoords(2);
            if(downward)
                z=linspace(obj.table_height + 0.05,obj.table_height,step);
            else
                z=linspace(obj.table_height,obj.table_height + 0.05,step);
            end
            x=z*0+xi;
            y=z*0+yi;
            P=[x;y;z];
        end
    end 
    methods(Static)
        function T=createLineTrajectory(InitialPosition,FinalPosition,step)
            xi=InitialPosition(1);
            yi=InitialPosition(2);
            xo=FinalPosition(1);
            yo=FinalPosition(2);
            if(xi ~= xo)
                b=(yo-yi)/(xo-xi);
                m=yo-xo*b;
                x=linspace(xi,xo,step);
                y=x*b+m;
            else
                y = linspace(yi,yo,step);
                x = xo+y*0;
            end
            T=[x;y];
        end
       
    end
end