function d = wjn_ecog_read_ns(filename)
%%
filename = 'AA071614datafileLEFT0003.ns2';

[t,data,ids]=GetAnalogData(fullfile(cd,filename),1000,[],[],[]);


figure
for a = 1:length(ids)
    plot(t,data(:,a)./max(data(:,a))+a)
    hold on
end