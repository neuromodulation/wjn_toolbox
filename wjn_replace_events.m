function D=wjn_replace_events(filename,origfile)
load(filename)
D.trials.events=[];
save(fullfile(D.path,D.fname),'D')
clear D
Ds=spm_eeg_load(filename);

hdr =ft_read_header(origfile);
t=linspace(0,hdr.nSamples/hdr.Fs,hdr.nSamples);
events =ft_read_event(origfile);
for a = 1:length(events)
    events(a).time=t(events(a).sample);
end
events=rmfield(events,'sample');
load(filename)
D.trials.events=events;
save(fullfile(D.path,D.fname),'D')
D=spm_eeg_load(fullfile(D.path,D.fname));