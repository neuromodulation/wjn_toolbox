function [fdata,t] = wjn_spike_filter(filename,channel,freq,hilb)

data=load(filename);

fs = 1/data.(channel).interval;


d = fdesign.bandpass('N,Fc1,Fc2',6,freq(1),freq(2),fs);
hd = design(d,'butter');

data.(['f' channel]) = data.(channel);
data.(['f' channel]).values = filter(hd,data.(channel).values);

if hilb
    data.(['f' channel]).values = abs(hilbert(filter(hd,data.(channel).values)));
end
save(filename,'-struct','data')

fdata = data.(['f' channel]).values;
t = data.(['f' channel]).times;



