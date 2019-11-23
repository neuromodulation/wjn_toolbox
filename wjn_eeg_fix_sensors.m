function D=wjn_eeg_fix_sensors(filename)

D=spm_eeg_load(filename);

data=D.ftraw;

data = rmfield(data,'elec');

ch=D.chanlabels;
ct=D.chantype;
cond=D.conditions;

nD=spm_eeg_ft2spm(data,filename);
nD=chanlabels(nD,':',ch);
nD=chantype(nD,':',ct);
nD=conditions(nD,':',cond);
save(nD)
D=spm_eeg_convert(nD.fullfile);

D=D.move(filename);
D=spm_eeg_load(filename);