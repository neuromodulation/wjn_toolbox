function wjn_import_toolbox

wjn_backup_toolbox

mf = getsystem;

wjndir = fullfile(mf,'wjn_toolbox');
 
    delete(fullfile(wjndir,'*(*conflict*)*.m'));
    delete(fullfile(wjndir,'*(*Konflikt*)*.m'));
    delete(fullfile(wjndir,'*.asv'));
% copyfile(fullfile(wjndir,'wjn_vm_list.m'),mf)


    copyfile(fullfile(wjndir,'*.m'),mf,'f');
    copyfile(fullfile(wjndir,'*.mexw*'),mf,'f');
 
  

    script_list = ffind(fullfile(mf,'*.m'));
    save(fullfile(mf,date))
    disp('Imported wjn toolbox!')
    
