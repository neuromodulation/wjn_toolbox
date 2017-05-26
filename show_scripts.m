function s=show_scripts(folder)
if ~exist('folder','var')
load fff folder
end
mf = getsystem;
s=ffind(fullfile(mf,folder,'*.m'))
for a = 1:length(s);
%     edit(fullfile(mf,folder,s{a}))
    disp(['Open nr.' num2str(a) ':' s{a}])
end