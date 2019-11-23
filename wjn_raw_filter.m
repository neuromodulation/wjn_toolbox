function fdata = wjn_raw_filter(data,fs,freq)
%% fdata = wjn_quickfilter(data,fs,freq)

fdata=ft_preproc_bandpassfilter(data,fs,freq);