function wjn_backup_toolbox
mf = getsystem;

wjndir = fullfile(mf,'wjn_toolbox_backup');


if ~exist(wjndir,'dir')
    mkdir(wjndir);
end
    copyfile(fullfile(mf,'*.m'),wjndir,'f');
    copyfile(fullfile(mf,'*.mexw*'),wjndir,'f');
 
  
 
    delete(fullfile(wjndir,'*(*conflict*)*.m'));
    delete(fullfile(wjndir,'*(*Konflikt*)*.m'));
    delete(fullfile(wjndir,'*.asv'));
    script_list = ffind(fullfile(wjndir,'*.m'));
    save(fullfile(wjndir,date))
    disp('Backed up wjn toolbox!')
    
