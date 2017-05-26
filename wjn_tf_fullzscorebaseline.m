function D=wjn_tf_fullzscorebaseline(filename,method)

if ~exist('method','var')
    method = 'zscore';
end


D=spm_eeg_load(filename);
nd = D(:,:,:,:);
if isfield(D,'artefacts')
    disp('removing artefacts from baseline')
    for a = 1:size(D.artefacts)
        nd(:,:,D.indsample(D.artefacts(a,1)):D.indsample(D.artefacts(a,2)),:)=nan;
        disp('removing artefacts from baseline')
    end
end



nD=clone(D,['r' D.fname]);
for a = 1:D.nchannels
    for b = 1:D.nfrequencies
        switch method
            case 'zscore'
                nD(a,b,:,1) = (D(a,b,:,1)-nanmean(nd(a,b,:,1)))./nanstd(nd(a,b,:,1));
            case 'median'
                nD(a,b,:,1) = 100.*(D(a,b,:,1)-nanmedian(nd(a,b,:,1)))./nanmedian(nd(a,b,:,1));
            case 'mean'
                nD(a,b,:,1) = 100.*(D(a,b,:,1)-nanmean(nd(a,b,:,1)))./nanmean(nd(a,b,:,1));
        end
        disp([num2str(a) '/' num2str(D.nchannels) ' ' D.chanlabels{a} ' F: ' num2str(D.frequencies(b)) ' Hz'])
    end
end

save(nD);
D=nD;