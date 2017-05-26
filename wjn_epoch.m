function D=wjn_epoch(filename,timewin,conditionlabels,trl,prefix)
% D=wjn_epoch(filename,timewin,conditionlabels,trl)
if ~exist('conditionlabels','var')
    conditionlabels = 'Undefined';
end

if ~exist('prefix','var')
    prefix = '';
end


if ~iscell(conditionlabels)
    conditionlabels={conditionlabels};
end

conds = conditionlabels;
D=spm_eeg_load(filename);

if sum(abs(timewin)) > 500
    timewin = timewin/1000;
end


if exist('trl','var')
    for a = 1:length(trl);
        ntrl(a,:) = [D.indsample(trl(a)+timewin(1)) D.indsample(trl(a)+timewin(1))+diff(timewin)*D.fsample timewin(1)*D.fsample];
        if length(conds)==1;
            conditionlabels{a}=conds{1};
        end
            
    end

    
 
S=[];
S.trl=ntrl;
S.conditionlabels=conditionlabels;
D.trl = S.trl;
D.ttrl = D.trl/D.fsample;
D.conditionlabels = S.conditionlabels;
save(D)
end



S=[];
S.D = D.fullfile; 
    S.prefix = prefix;
if  ~exist('trl','var')
    S.trialength = timewin(1)*1000;
    D=spm_eeg_epochs(S);
    D=conditions(D,':',conds{1});

    save(D);
else 
    S.trl = D.trl;
    S.conditionlabels = D.conditionlabels;
    
    D=spm_eeg_epochs(S);

end

