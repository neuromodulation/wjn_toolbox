function [trl, label] = stim_trialfun(S)

D = spm_eeg_load(S.D);

trialn = D.fsample;

r = S.seq;
freq = [];
lbl = [];
while ~isempty(r)
     [t r] = strtok(r, '_');
     if ~isempty(str2num(t))
         freq = [freq str2num(t)];
     elseif isempty(lbl)
         lbl = t;
     else
         lbl = [lbl '_' t]; 
     end
end

trl = [];
label = {};
for i = 1:length(freq)
    [t1, t2] = stim_bounds(D(D.indchannel('STIM'), :), D.fsample, freq(i));
    
    ctrl = t1:trialn:t2;
    ctrl = [ctrl(1:(end-1))' ctrl(2:end)'-1 zeros(length(ctrl)-1, 1)];
    
    trl  = [trl; ctrl];
    label = [label repmat({[lbl '_' num2str(freq(i))]}, 1, size(ctrl, 1))];
    
end



