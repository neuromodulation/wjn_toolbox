timestamp = datestr(now);
if exist('backup.bck','file')

    save('backup.bck','-mat','-append')
else
    
    save('backup.bck','-mat')
end
d = cd;
% [~,d,~] = fileparts(d);
% copyfile('backup.bck',['D:\backup\bsl\' strrep(strrep(d,':',''),'\','_') '-' strrep(strrep(timestamp,':',''),' ','_') '.mat'],'f');

clear timestamp