function fdata = wjn_raw_filter(data,fs,freq)
%% fdata = wjn_quickfilter(data,fs,freq)

d = fdesign.bandpass('N,Fc1,Fc2',2,freq(1),freq(2),fs);
hd = design(d,'butter');
fdata=filter(hd,data);