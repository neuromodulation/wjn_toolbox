function wjn_export_toolbox_to_git



wjndir = ['E:' filesep 'GitHub' filesep 'wjn_toolbox'];

    copyfile(fullfile(mf,'*.m'),wjndir,'f');
 
  
 
    delete(fullfile(wjndir,'*(*conflict*)*.m'));
    delete(fullfile(wjndir,'*(*Konflikt*)*.m'));
    delete(fullfile(wjndir,'*.asv'));
    script_list = ffind(fullfile(wjndir,'*.m'));
    save(fullfile(wjndir,date))
    disp('Updated wjn toolbox!')
    
