function D=wjn_average(filename,robust,prefix)

if ~exist('robust','var')
    robust = 0;
end

S = [];
S.D = filename;
if ~robust
    S.robust = 0;
else
    S.robust.savew=0;
    S.robust.bycondition =1;
    S.robust.ks = 3;
    S.robust.removebad = 1;
%     S.prefix = 'ra';
end

if exist('prefix','var')
    S.prefix = prefix;
end

D=wjn_sl(filename);
if isfield(D,'eanalog') && ~isempty(fieldnames(D.eanalog))
    anames = fieldnames(D.eanalog);
    for a = 1:length(anames)
        for b = 1:D.ntrials
        D.meanalog.(anames{a})(b,:) = nanmean(D.eanalog.(anames{a})(D.indtrial(D.conditions{b}),:),1);
        end
    end
end
save(D)
D=spm_eeg_average(S);

% keyboard
