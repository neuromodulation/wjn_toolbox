function D=rox_epocha(filename,timewin,conditionlabels,trl,prefix)
% D=wjn_epoch(filename,timewin,conditionlabels,trl)
if ~exist('conditionlabels','var')
    conditionlabels = 'Undefined';
end

if ~iscell(conditionlabels)
    conditionlabels={conditionlabels};
end

conds = conditionlabels;
D=spm_eeg_load(filename);

if sum(abs(timewin)) > 500
    timewin = timewin/1000;
end


if exist('trl','var') && ~isempty(trl)
    if size(trl,2)==1
        for a = 1:length(trl)
            ntrl(a,:) = [D.indsample(trl(a))+timewin(1)*D.fsample D.indsample(trl(a))+(timewin(1)+diff(timewin))*D.fsample timewin(1)*D.fsample];
            if length(conds)==1
                conditionlabels{a}=conds{1};
            end

        end
    elseif size(trl,2)==3
        ntrl = trl;
    else
        error('wrong trl vector')
    end
%     
%  
S=[];
S.trl=ntrl;
S.conditionlabels=conditionlabels;
D.trl = S.trl;
D.ttrl = D.trl/D.fsample;
D.conditionlabels = S.conditionlabels;
save(D)

% keyboard


if isfield(D,'analog') && ~isempty(fieldnames(D.analog))
    anames = fieldnames(D.analog);
    for a = 1:length(anames)
        for b = 1:size(D.trl,1)  
        epochedtrials=D.analog.(anames{a})(D.trl(b,1):D.trl(b,2));
        if size(epochedtrials,1)>1
            epochedtrials=epochedtrials';
        end
        D.eanalog.(anames{a})(b,:)= epochedtrials;
        end
    end
save(D)
end
end

% 
% S=[];
% S.D = D.fullfile; 
%     S.prefix = prefix;
% if  ~exist('trl','var') || isempty(trl)
%     S.trialength = timewin(1)*1000;
%     D=spm_eeg_epochs(S);
%     D=conditions(D,':',conds{1});
% 
%     save(D);
% else 
%     S.trl = ntrl;
%     S.conditionlabels = D.conditionlabels;
%     
%     D=spm_eeg_epochs(S);
% 
% end

