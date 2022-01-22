classdef WidowXMKII < SerialLink
 
	properties
	end
 
	methods
		function ro = WidowXMKII()
			objdir = which('WidowXMKII');
			idx = find(objdir == filesep,2,'last');
			objdir = objdir(1:idx(1));
			 
			tmp = load(fullfile(objdir,'@WidowXMKII','matWidowXMKII.mat'));
			 
			ro = ro@SerialLink(tmp.sr);
			 
			 
		end
	end
	 
end
