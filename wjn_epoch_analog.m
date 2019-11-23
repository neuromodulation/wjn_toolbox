function D=wjn_epoch_analog(filename,timewin,conditionlabels,trl)
% D=wjn_epoch(filename,timewin,conditionlabels,trl)
if ~exist('conditionlabels','var')
    conditionlabels = 'Undefined';
end

if ~exist('prefix','var')
    prefix = 'e';
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
        D.eanalog.(anames{a})(b,:)= D.analog.(anames{a})(D.trl(b,1):D.trl(b,2));
        end
    end
save(D)
end
end



