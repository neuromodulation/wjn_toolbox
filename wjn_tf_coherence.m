function nD=wjn_tf_coherence(filename,chancomb)

    D=wjn_sl(filename);
    
    for a = 1:size(chancomb,1)
        channels{a} = [chancomb{a,1} '-' chancomb{a,2}];
                
        data1 = D(ci(chancomb{1,1},D.chanlabels),:,1);
        data2 = D(ci(chancomb{1,2},D.chanlabels),:,1);
        [tf(a,:,:,1),fp]=cwt(data1,D.fsample);
        tf(a,:,:,2)=cwt(data2,D.fsample);
        [coh(a,:,:,1),~,f]=wcoherence(data1,data2,D.fsample);
         coh(a,:,:,2)= wcoherence(data1(randperm(D.nsamples)),data2,D.fsample);
    end
    
    keyboard
f=sort(f);

i = unique(wjn_sc(f,[1:f(end)]));
ff=f(i);
coh = coh(:,i,:,:);
tf = tf(:,i,:,:);

nD=clone(D,['coh_' D.fname],[length(channels),length(f) D.nsamples 2]);
nD=frequencies(nD,':',f);
nD=chanlabels(nD,':',channels);
nD=conditions(nD,[1 2],{'coh','scoh'});
nD.tf = tf;
nD(:,:,:,:) = coh;
save(nD);
