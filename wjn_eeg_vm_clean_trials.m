function D=wjn_eeg_vm_clean_trials(filename)

D=wjn_sl(filename);

gotrials = ci('go',D.conditions);
movetrials = ci('move',D.conditions);
stoptrials = ci('stop',D.conditions);

n=0;
nb=0;
gt=[];
for a = 1:length(gotrials)
    if ismember(gotrials(a)+1,movetrials) && ismember(gotrials(a)+2,stoptrials)
        n=n+1;
        gt = [gt gotrials(a) gotrials(a)+1 gotrials(a)+2];
        ggotrials(n) = gotrials(a);
        gmovetrials(n) = gotrials(a)+1;
        gstoptrials(n) = gotrials(a)+2;
    else
        nb = nb+1;
    end
end

disp(['Removed ' num2str(nb) ' trials due to artefacts in adjacent conditions.'])
% keyboard
% abad = setdiff

rt = D.trialonset(gmovetrials)-D.trialonset(ggotrials);
mt = D.trialonset(gstoptrials)-D.trialonset(gmovetrials);
pt = D.trialonset(gstoptrials)-D.trialonset(ggotrials);

ibad = [pt>nanmean(pt)+2*std(pt)];
rt(ibad) = [];
mt(ibad) = [];
pt(ibad) = [];

gmovetrials(ibad) = [];
ggotrials(ibad) = [];
gstoptrials(ibad) = [];

ggt = sort([ggotrials gmovetrials gstoptrials]);
D.ggt = ggt;
D.bt = setdiff(1:D.ntrials,ggt);
D=badtrials(D,D.bt,1);
save(D);
D=wjn_remove_bad_trials(D.fullfile);

D.noutliers = sum(ibad);
disp(['Removed ' num2str(D.noutliers) ' trials due to behavioural outliers.'])

D.mt = mt';
D.pt = pt';
D.rt = rt';

if isfield(D,'blocks')
    n=1;
    for a = 1:length(D.blocks)
        nb = sum(ismember(D.bt,D.blocks{a}));
        nblocks{a} = n:n+numel(D.blocks{a})-nb-1;
        n=nblocks{a}(end)+1;
    end
        D.nblocks = nblocks;
end
% keyboard
save(D)









