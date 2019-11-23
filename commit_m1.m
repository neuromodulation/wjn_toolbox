function commit_m1

root = cd;

cd(fullfile(gitdir,'m1'))
!git commit -am "auto_commit by wjn"
!git push
cd(root)