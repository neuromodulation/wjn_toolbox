function wjn_export_toolbox

mf = getsystem;

wjndir = fullfile(mf,'wjn_toolbox');

if ~exist(wjndir,'dir')
    mkdir(wjndir);
end
    copyfile(fullfile(mf,'*.m'),wjndir,'f');
 
  
 
    delete(fullfile(wjndir,'*(*conflict*)*.m'));
    delete(fullfile(wjndir,'*.asv'));
    script_list = ffind(fullfile(wjndir,'*.m'));
    save(fullfile(wjndir,date))
    disp('Updated wjn toolbox!')
    
