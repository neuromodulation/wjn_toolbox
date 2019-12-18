function wjn_export_toolbox
root = cd;
mf = getsystem;

wjndir = fullfile(mf,'wjn_toolbox');
gitdir = 'E:\GitHub\wjn_toolbox';

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
    
if exist(gitdir,'dir')
    copyfile(fullfile(wjndir,'*.m'),gitdir,'f');
    cd(gitdir)
    system('git add -A')
    system(['git commit -am "Toolbox exported ' date '"'])
    !git push
end
    
cd(root);
    
    