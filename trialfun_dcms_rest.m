function trl = trialfun_dcms_rest(cfg)

dataset = cfg.dataset;

event = ft_read_event(dataset);
hdr = ft_read_header(dataset);

trialn = 1024*round((hdr.Fs./300));

if ~isempty(event)
    
    cogent_trig  = [event(find(strcmp('UPPT001_up', {event.type}))).value];
    cogent_indx  = [event(find(strcmp('UPPT001_up', {event.type}))).sample];
    
    if isempty(cogent_trig)
        cogent_trig  = [event(find(strcmp('STI101_up', {event.type}))).value];
        cogent_indx  = [event(find(strcmp('STI101_up', {event.type}))).sample];
    end
else
    cogent_trig =[];
    cogent_indx =[];
end


%%
start_indx = cogent_indx(cogent_trig == 11);
if isempty(start_indx)
    start_indx = 1;
end

end_indx = cogent_indx(ismember(cogent_trig, [14,21])) - 4 * hdr.Fs;
if isempty(end_indx)
    end_indx = hdr.nTrials*hdr.nSamples - 4 * hdr.Fs;
end

trl = start_indx:trialn:end_indx;
trl = [trl(1:(end-1))' trl(2:end)'-1 zeros(length(trl)-1, 1)];