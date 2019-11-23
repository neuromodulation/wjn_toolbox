function [out,L] = wjn_nn_all_channels(X,T,ica,H,tD,nsubblocks,fname)
delete nn_lockindices.mat
vars = X.Properties.VariableNames;

for a = 1:length(vars)
    chans{a} = strtok(vars{a},'_');
end

chans = unique(chans);
for a = 1:length(chans)
    nX = X(:,ci([chans{a} '_'],vars));
    [net{a},Y{a},L(a)]=wjn_nn_classifier_2(nX,T,ica,H,tD,0,1,0,nsubblocks);
    if isempty(X.Properties.Description)
        myprint([X.Properties.Description '_' chans{a}])
    end
end
% keyboard
out = table();
out.chans = chans';
out.full_lmA = 1-[L(:).lm_full_mse]';
out.val_lmA = 1-[L(:).lm_val_mse]';
out.full_nnR = [L(:).nnRfull]';
out.full_nnA = [L(:).nn_full_accuracy]';
out.val_nnR = [L(:).nnRval]';
out.val_nnA = [L(:).nn_val_accuracy]';
out.nn_fpr = [L(:).nn_fpr]';
out.nn_tpr = [L(:).nn_tpr]';
out.nn_fpr99 = [L(:).nn_fpr99]';


if isempty(X.Properties.Description)
    save(X.Properties.Description,'chans','L','out')
end