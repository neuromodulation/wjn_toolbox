function nD=wjn_artefact_rejection(filename,nt)
%%
D=spm_eeg_load(filename);

close all
if ~exist('nt','var')
matlabbatch =[];
matlabbatch{1}.spm.meeg.preproc.artefact.D = {D.fullfile};
matlabbatch{1}.spm.meeg.preproc.artefact.mode = 'mark';
matlabbatch{1}.spm.meeg.preproc.artefact.badchanthresh = 0.5;
matlabbatch{1}.spm.meeg.preproc.artefact.append = 0;
matlabbatch{1}.spm.meeg.preproc.artefact.methods.channels{1}.type = 'LFP';
matlabbatch{1}.spm.meeg.preproc.artefact.methods.channels{2}.type = 'EEG';
matlabbatch{1}.spm.meeg.preproc.artefact.methods.fun.zscore.threshold = 3;
matlabbatch{1}.spm.meeg.preproc.artefact.methods.fun.zscore.excwin = 100;
matlabbatch{1}.spm.meeg.preproc.artefact.prefix = 'a';
spm_jobman('run',matlabbatch)

D=spm_eeg_load(['a' D.fname])

ar= D.events;
t=D.time;
nt=zeros(size(t));
for a = 1:length(ar)
    type{a} = ar(a).type;
    channel{a} = ar(a).value;
    time(a) = ar(a).time;
    duration(a) = ar(a).duration;
    nt(sc(t,time(a)):sc(t,time(a)+duration(a)))=1;
end
    

end

close all
figure
sigbar(t,nt)
for a =1:D.nchannels;
    plot(t,squeeze(D(a,:,1)-mean(D(a,:,1))./std(D(a,:,1))*.5+a))
    hold on
end
sigbar(t,nt)
for a =1:D.nchannels;
    plot(t,squeeze(D(a,:,1)-mean(D(a,:,1))./std(D(a,:,1))*.5+a))
    hold on
end
xlim([t(1) t(end)])

d=D(:,:,1);
d(:,find(nt))=[];
l=length(d);
nnt=linspace(0,l/D.fsample,l);
dim=size(D);
dim(2) = l;
nD=clone(D,['w' D.fname],dim);
nD(:,:,1) = d;
save(nD);


