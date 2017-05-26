s=ffind('*.m')
for a = 1:length(s);
   
    edit(s{a})
    disp(['Open nr.' num2str(a) ':' s{a}])
end