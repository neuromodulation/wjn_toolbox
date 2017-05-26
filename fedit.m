function fedit(filename)
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
myedit(fullfile(mf,'projects',folder,filename))