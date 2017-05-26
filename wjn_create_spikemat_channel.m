function [ch]=wjn_create_spikemat_channel(d,fs,title);

if size(d,2) > size(d,1);
    d=d';
end

if size(d,2) >1;
    error('only single channel data allowed')
end

ch.title = title;
ch.comment = 'wjn_create_spikemat_channel';
ch.interval = 1/fs;
ch.scale = 1;
ch.offset=0;
ch.units = 'Uv';
ch.start = 0;
ch.length = length(d);
ch.times = linspace(0,length(d)/fs,length(d))';
ch.values = d;


