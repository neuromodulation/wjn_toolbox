clear
% close all
filename = 'spmeeg_cr_joyL';
D=spm_eeg_load(filename)
S.D = D.fullfile;
S.timewin = [-Inf Inf];
D=spm_eeg_bc(S)
matlabbatch=[];
lfpchans = D.indchantype('LFP');
for a=1:length(lfpchans)
    thresh(a) = prctile(abs(D(lfpchans(a),:,1))',97);
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a).channels{1}.chan = D.chanlabels{lfpchans(a)};
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a).fun.threshchan.threshold = thresh(a) ;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a).fun.threshchan.excwin = 200;
end
    
    
    matlabbatch{1}.spm.meeg.preproc.artefact.D(1) = {D.fullfile};
    matlabbatch{1}.spm.meeg.preproc.artefact.mode = 'mark';
    matlabbatch{1}.spm.meeg.preproc.artefact.badchanthresh = 0.2;
    matlabbatch{1}.spm.meeg.preproc.artefact.append = true;
    

    
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+1).channels{1}.type = 'LFP';
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+1).fun.flat.threshold = 0;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+1).fun.flat.seqlength = 5;
%     
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+2).channels{1}.type = 'LFP';
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+2).fun.zscore.threshold = 5;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+2).fun.zscore.excwin = 500;
    
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+3).channels{1}.type = 'LFP';
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+3).fun.zscorediff.threshold = 5;
    matlabbatch{1}.spm.meeg.preproc.artefact.methods(a+3).fun.zscorediff.excwin = 500;
%     
   
%     
%     matlabbatch{1}.spm.meeg.preproc.artefact.methods(5).channels{1}.type = 'LFP';
%     matlabbatch{1}.spm.meeg.preproc.artefact.methods(5).fun.peak2peak.threshold = thresh/2;


matlabbatch{1}.spm.meeg.preproc.artefact.prefix = 'a';
    
    spm_jobman('run',matlabbatch)
%%
% filename = 'spmeeg_mb_joyL.mat';
% D=spm_eeg_load(['a' filename])
% close all
clear
D=spm_eeg_load('spmeeg_k_JoyL.mat')
S.D = D.fullfile
S.threshold = 2,
S.excwin=100,
S.chanind=D.indchantype('LFP'),
S.mode = 'mark',
S.append = 0
D = spm_eeg_artefact_zscore_linear(S)

events = D.events;
n=0;
for a = 1:length(events);
    ntype = events(a).type;
    t{a}=ntype;
    if strncmpi(ntype,'artefact',numel('artefact'))
        n=n+1;
        type{n,1} = ntype;
    value{n,1} = events(a).value;
    duration(n,1) = events(a).duration;
    time(n,1) = events(a).time;
    end
end



    
    
figure
for a = 1:length(D.chanlabels)
    rs = (D(a,:,1)./nanmax(D(a,:,1))+a*2);
    plot(D.time,rs);
    hold on
    iartefacts = floor(time(ci(D.chanlabels{a},value),1).*D.fsample);
    iduration = floor(duration(strcmp(value,D.chanlabels{a}),1)*D.fsample);
    for b=1:length(iartefacts)
        if iartefacts(b)+iduration(b)<=D.nsamples;
            plot(D.time(iartefacts(b):iartefacts(b)+iduration(b)),-ones(1,size(iartefacts(b):iartefacts(b)+iduration(b),2))+a*2,'color','k','linewidth',5)
        elseif iartefacts(b) < D.nsamples;
             plot(D.time(iartefacts(b):D.nsamples),-ones(1,size(iartefacts(b):D.nsamples,2))+a*2,'color','k','linewidth',5)
        end
    end
    ylim([0 length(D.chanlabels)*2+1])
    
end
set(gca,'YTick',2:2:length(D.chanlabels)*2+1,'YTicklabel',D.chanlabels)
figone(30,30)

