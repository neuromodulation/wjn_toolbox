function tifprint(filename)
% myprint(filename,renderer (-zbuffer,-opengl),

% print(gcf,filename,'-dtifff','-r300','-zbuffer');
% print(gcf,filename,'-dtifff','-r300','-painters');
% print(gcf,filename,'-dtifff','-r300','-opengl');
[path,fname] = fileparts(filename);

    print(gcf,fullfile(path,[fname '.tiff']),'-dtiff','-r600','-opengl');
    myprint(filename)

% exloop = 0;
% n = 0;
% 
% newfile =fname;
% mf = getsystem;
% while exloop == 0;
%     n = n+1;
%     if exist([mf 'all_figures\' newfile '.tiff'],'file');
%         newfile = [fname '_' num2str(n)];
%     else
%         exloop = 1;
%        copyfile(fullfile(path,[fname '.tiff']),[mf 'all_figures\tif\' newfile '.tiff'])
%     end
% end

saveas(gcf,fullfile(path,[fname '.fig']),'fig');
% newfile = fname;
% exloop = 0;
% n = 0;
% while exloop == 0;
%     n = n+1;
%     if exist([mf 'all_figures\' newfile '.fig'],'file');
%         newfile = [fname '_' num2str(n)];
%     else
%         exloop = 1;
%         saveas(gcf,[mf 'all_figures\' newfile],'fig');
%     end
% end
% load(fullfile(mf,'figures.mat'))
% s = size(figures,1);
% figures{s+1,1} = s+1;
% figures{s+1,2} = cd;
% figures{s+1,3} = newfile;
% timestamp = datestr(now);
% figures{s+1,4} = timestamp;
% save(fullfile(mf,'figures.mat'),'figures');
% 
% xlswrite(fullfile(mf,'figures.xls'),{'No','Path','Figure','Date'},1,'A1')
% xlswrite(fullfile(mf,'figures.xls'),figures,1,'A2')
% 
% if length(varargin)>1;
%     if ~renderer
%         for a = 2:length(varargin);
%             data.(inputname(a)) = varargin{a};
%         end
%         save([filename '.fig'],'-append','-mat')
%     end
% end
% 
