function wjn_commit_m1(mes)

root = cd;
cd('E:\GitHub\m1');

copyfile(fullfile(mdf,'crcns-m1','code','*.m'),'E:\GitHub\m1\code\','f');
!git status
system(['git commit -am " ' mes ' "'])
!git push
