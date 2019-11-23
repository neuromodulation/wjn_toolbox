function wjn_fetch_m1

root = cd;
cd('E:\GitHub\m1');
!git status
!git fetch

copyfile('E:\GitHub\m1\code\*.m',fullfile(mdf,'crcns-m1','code'),'f');

cd(fullfile(mdf,'crcns-m1','code'))
cd(root)