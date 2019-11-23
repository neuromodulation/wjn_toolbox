function D=wjn_tf_sep_baseline(filename,baseline,cond,fun)

if ~exist('fun','var')
    fun = 'P';
end

D=spm_eeg_load(filename);

if sum(abs(baseline))>100
    baseline = baseline./1000;
end
% keyboard
for a = 1:D.ntrials
    
    cc = ci(cond,D.conditions(a),2);
    
    if ~isempty(cc)
%         keyboard
        if strcmp(fun,'P')
            
            mb = nanmean(D(:,:,D.indsample(baseline(1)):D.indsample(baseline(2)),a),3);
            sb = nanmean(D(:,:,D.indsample(baseline(1)):D.indsample(baseline(2)),a),3);
        elseif strcmp(fun,'Z')
            
            mb = nanmean(D(:,:,D.indsample(baseline(1)):D.indsample(baseline(2)),a),3);
            sb = nanstd(D(:,:,D.indsample(baseline(1)):D.indsample(baseline(2)),a),[],3);
        end
        la = a;
    end
    
    for b = 1:D.nchannels
        rtf(b,:,:,a) = bsxfun(@rdivide,...
            bsxfun(@minus,...
            squeeze(D(b,:,:,a)),...
            squeeze(mb(b,:)')),...
            squeeze(sb(b,:)'));
        
    end
    disp([D.conditions{a} ' corrected with ' D.conditions{la}])
end

% keyboard

if strcmp(fun,'P')
    rtf = rtf.*100;
end

nD = clone(D,['r' fun D.fname]);

nD(:,:,:,:) = rtf;
save(nD)
D=nD;

