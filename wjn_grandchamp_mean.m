function nD=wjn_grandchamp_mean(filename,baseline,method,condition)
% nD=wjn_grandchamp_mean(filename,baseline,method,condition)
% if condition is defined, it has to be the first trial before other trials
% that should be corrected


if ~exist('method','var')
    method = 'additive';
end

if ~exist('condition','var')
    condition = 'all';
end

%%
D=spm_eeg_load(filename);

nt = D.ntrials;
nc = D.nchannels;
nf = D.nfrequencies;

if sum(abs(baseline))>1000
    baseline = baseline/1000;
end

% ib = sc(D.time,baseline(1)):sc(D.time,baseline(2));
ib = D.indsample(baseline(1)):D.indsample(baseline(2));


d=nan(size(D(:,:,:,:)));

if strcmp(condition,'all')
    for a = 1:nc
        for b = 1:nf
            for c  = 1:nt
                if strcmp(method,'additive')
                d(a,b,:,c) = (D(a,b,:,c)-squeeze(nanmean(D(a,b,ib,c),3)))./nanstd(squeeze(D(a,b,ib,c)));
                elseif strcmp(method,'gain')
                    d(a,b,:,c) = 100*((D(a,b,:,c)-squeeze(nanmean(D(a,b,ib,c),3)))./squeeze(nanmean(D(a,b,ib,c),3)));
                end
            end
        end
    end
elseif ~strcmp(condition,'all')
    ic = ci(condition,D.conditions);
    for a = 1:nc
        for b = 1:nf
            for c = 1:length(ic)
                mb(c) = squeeze(nanmean(D(a,b,ib,ic(c)),3));
                sb(c) = squeeze(nanstd(D(a,b,ib,ic(c))));
            end
            mmb = nanmean(mb);
            msb = nanmean(sb);
            
            
            for c  = 1:nt
                if strcmp(method,'additive')
                    d(a,b,:,c) = (D(a,b,:,c)-mmb)./msb;
                elseif strcmp(method,'gain')
                    d(a,b,:,c) = 100*(D(a,b,:,c)-mmb)./mmb;
                end
            end
        end
    end
    
end
nD=clone(D,fullfile(D.path,['g' D.fname]));
nD(:,:,:,:) = d;
save(nD);