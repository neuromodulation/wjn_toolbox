load fff folder
mf=getsystem;
s=ffind(fullfile(mf,'projects',folder,'*.m'))
for a = 1:length(s);
   
    myedit(s{a})
    disp(['Open nr.' num2str(a) ':' s{a}])
end