function s=get_scripts(folder)
if ~exist('folder','var')
    try
        load fff folder
    catch
        mf = getsystem;
        ff = uigetdir(mf)
        [~,folder]=fileparts(ff)
        save fff folder
    end
end
mf = getsystem;
s=ffind(fullfile(mf,'projects',folder,'*.m'))
for a = 1:length(s);
    addpath(fullfile(mf,'projects',folder))
    edit(fullfile(mf,'projects',folder,s{a}))
    disp(['Open nr.' num2str(a) ':' s{a}])
end