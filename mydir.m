function mydir(dir)

mkdir(dir)
cd(dir)
copyfile ../fff.mat .

current=cd;
save fff current -append