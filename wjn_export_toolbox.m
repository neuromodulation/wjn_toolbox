function wjn_export_toolbox

mf = getsystem;

wjndir = fullfile(mf,'wjn_toolbox');

copyfile(fullfile(wjndir,'wjn_vm_list.m'),mf)

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
    disp('Updated wjn toolbox!')
    
