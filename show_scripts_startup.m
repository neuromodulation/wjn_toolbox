function output=show_scripts_startup
load(fullfile(getsystem,'scripts.mat'))
l = length(scripts);
n = 0;
for a = l-10:l;
    n=n+1;
    output{n,1} = fullfile(scripts{a,2},scripts{a,3});
    disp([num2str(n) ' ' output{n}]);
end
