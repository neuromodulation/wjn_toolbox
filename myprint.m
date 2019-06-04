function myprint(filename,printfig)

if ~exist('printfig','var')
    printfig = 0;
end

[fold,file,ext]=fileparts(filename);
if ~exist(fold,'dir')
    mkdir(fold);
end
print(gcf,fullfile(fold,file),'-dpng','-r300','-opengl');
print(gcf,fullfile(fold,file),'-dpdf','-r80');
% exloop = 0;
% n = 0;
% newfile = filename;
% 
if printfig
    savefig(gcf,fullfile(fold,[file]));
end