function ch=wjn_create_spikemat_event_channel(title,times,values,fs)

ch.title = title;
ch.comment = 'wjn_create_spikemat_event_channel';
ch.interval = 1/fs;
ch.start = times(1);
ch.times = times;
ch.length= length(times);
if length(values)~=length(times)
    ch.values = zeros(size(times));
    try 
        ch.values(values)=1;
    catch 
        disp('converting input times')
        i=wjn_indsample(values,times);
        ch.values(i)=1;
    end
else
    ch.values = values;
end

