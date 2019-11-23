function D=wjn_average_additional_conditions(filename,confields,robust)

if ~exist('robust','var')
    robust = 0;
end

if ischar(confields)
    confields = {confields};
end

D=spm_eeg_load(filename);
allconds = [];
for a=1:length(confields)+1
    if a==1
        oconds = D.conditions;
    else
        D=conditions(D,':',D.(confields{a-1}));
        save(D)
    end  
    nD=wjn_average(D.fullfile,robust,['m' num2str(a)]);
    if a ==1
             d(:,:,:,:) = nD(:,:,:,:);
    else
        d(:,:,:,size(d,4)+1:size(d,4)+nD.nconditions) = nD(:,:,:,:);
    end
    allconds = [allconds nD.conditions];
end

D=conditions(D,':',oconds);
save(D)

nD = clone(nD,['mm' D.fname],size(d));
nD=conditions(nD,':',allconds);
D=nD;





