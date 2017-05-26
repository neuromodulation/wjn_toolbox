function myprint(varargin)
filename = varargin{1};

[fold,file,ext]=fileparts(filename);
if ~exist(fold,'dir')
    mkdir(fold);
end
print(gcf,fullfile(fold,file),'-dpng','-r600','-opengl');
print(gcf,fullfile(fold,file),'-dpdf','-r600');
% exloop = 0;
% n = 0;
% newfile = filename;
% 
% saveas(gcf,fullfile(fold,[file '.fig']),'fig');
