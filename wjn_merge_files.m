function D=wjn_merge_files(filenames)

if ~iscell(filenames)
    filenames = {filenames};
end

nfiles = numel(filenames);




for a = 1:nfiles
    D=spm_eeg_load(filenames{a});
    dim = size(D);
    chans{a} = D.chanlabels;
    ntrials(a) = D.ntrials;
    conds{a} = D.conditions;
    if numel(dim) ==3;
        d{a} = D(:,:,:);
    else
        d{a} = D(:,:,:,:);
    end
end

for a = 1:nfiles;
    nchans(a) = numel(chans{a});
end

[~,id] = min(nchans);

D=spm_eeg_load(filenames{id});

for a=1:nfiles;
    if a~=id
        ichans = ci(D.chanlabels,chans{a});
        oichans = ci(chans{a},D.chanlabels)
    if numel(dim) ==3;
        nd{a} = d{a}(ichans,:,:);
    else
        nd{a} = d{a}(ichans,:,:,:);
    end
        
    else
        nd{a} = d{a};
    end
end

ndim = [size(nd{id},1) size(nd{id},2) sum(ntrials)];

nn = nd{id};
nrest = 1:nfiles;
nrest(find(nrest==id))=[];
cond = conds{id};
for i = 1:numel(nrest);
    a=nrest(i);
    if numel(dim) ==3;
        nn(:,:,size(nn,3)+1:size(nn,3)+ntrials(a)) = nd{a};
    else
        nn(:,:,:,size(nn,4)+1:size(nn,4)+ntrials(a)) = nd{a};
    end
    cond = [cond conds{a}];
end

nD = clone(D,['m' D.fname],ndim)

if numel(dim) ==3;
    nD(:,:,:) = nn(:,:,:);
else
    nD(:,:,:,:) = nn(:,:,:,:);
end
fileseq = [id nrest];

nD = conditions(nD,':',cond);
nD.wjn.merge.filenames = filenames(fileseq);
nD.wjn.merge.chans = chans(fileseq);
nD.wjn.merge.conditions = conds(fileseq);
nD.wjn.merge.ntrials = ntrials(fileseq);
save(nD);
D=nD;

