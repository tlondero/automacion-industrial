function [posFin]=orderPoints(posIni,umax,vmax)
    
	aux = posIni;
	
	[~, vmax_index] = max(aux(1,:));
	posFin(1,vmax_index) = vmax;
	aux(1,vmax_index) = 0;
	
	[~, vmax_index] = max(aux(1,:));
	posFin(1,vmax_index) = vmax;
	aux(1,vmax_index) = 0;
	
	[~, vmax_index] = max(aux(1,:));
	posFin(1,vmax_index) = 1;
	aux(1,vmax_index) = 0;
	
	[~, vmax_index] = max(aux(1,:));
	posFin(1,vmax_index) = 1;
	aux(1,vmax_index) = 0;
	
		
	[~, umax_index] = max(aux(2,:));
	posFin(2,umax_index) = umax;
	aux(2,umax_index) = 0;
	
	[~, umax_index] = max(aux(2,:));
	posFin(2,umax_index) = umax;
	aux(2,umax_index) = 0;
	
	[~, umax_index] = max(aux(2,:));
	posFin(2,umax_index) = 1;
	aux(2,umax_index) = 0;
	
	[~, umax_index] = max(aux(2,:));
	posFin(2,umax_index) = 1;
	aux(2,umax_index) = 0;
	
end
