function D=wjn_epoch(filename,timewin,conditionlabels,trl,prefix)
% D=wjn_epoch(filename,timewin,conditionlabels,trl,prefix)
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

if sum(abs(timewin)) >= 100
    timewin = timewin/1000;
end



if exist('trl','var') && ~isempty(trl)
    if size(trl,2)==1
        if length(trl)<1000
            for a = 1:length(trl)
                ntrl(a,:) = [D.indsample(trl(a))+timewin(1)*D.fsample D.indsample(trl(a))+(timewin(1)+diff(timewin))*D.fsample timewin(1)*D.fsample];
                if length(conds)==1
                    conditionlabels{a}=conds{1};
                end
            end
        else
            itrl = trl.*D.fsample+1;
            xtrl=[round(timewin(1)*D.fsample),round((timewin(1)+diff(timewin))*D.fsample)];
            ntrl = [itrl+xtrl(:,1) itrl+xtrl(:,2) repmat(timewin(1)*D.fsample,size(itrl))];
        end
    elseif size(trl,2)==3
        ntrl = trl;
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
    

    
    
    if isfield(D,'analog') && ~isempty(fieldnames(D.analog))
        anames = fieldnames(D.analog);
        for a = 1:length(anames)
            for b = 1:size(D.trl,1)
                disp(b)
                tmp = D.analog.(anames{a})(round(D.trl(b,1)):round(D.trl(b,2)));
                tmp2(a,b,:)=tmp;
                        
            end
            D.eanalog.(anames{a}) = squeeze(tmp2(a,:,:));
        end
        save(D)
    end
end

S=[];
S.D = D.fullfile;
S.prefix = prefix;
if  ~exist('trl','var') || isempty(trl)
    %S.trialength = timewin(1)*1000;
    onset=[1:round(timewin(1)*D.fsample):D.nsamples]';
    offset = onset+round(timewin*D.fsample)-1;
    ntrl = [onset offset zeros(size(onset))];
    S.trl = ntrl;
    D=spm_eeg_epochs(S);
    D=conditions(D,':',conds{1});
    save(D);
else
    S.trl = ntrl;
    S.conditionlabels = D.conditionlabels;
    D=spm_eeg_epochs(S);
end

