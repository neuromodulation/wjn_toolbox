function D=wjn_AO_rereference_stim(filename)

D=spm_eeg_load(filename);

chanlist = D.AO.STIM_CHANLIST;
d=squeeze(D(:,:,1));
n=0;
nd=[];
nchannels ={};
for a =1 :length(chanlist)
    nchans = ci(chanlist{a}(1:end-1),D.chanlabels);
    i = ci(chanlist(a),D.chanlabels,1);
    if ismember(i-1,nchans) && ismember(i+1,nchans)
        n=n+1;
        nd(n,:) = D(i-1,:,1)-D(i+1,:,1);
        nchannels{n} = [D.chanlabels{i-1} '-' D.chanlabels{i+1}];
    end
end

md=[d;nd];

nD=clone(D,['rs' D.fname],[size(md) 1]);

nD(:,:,:) = md;
nD=chanlabels(nD,':',[D.chanlabels nchannels]);
nD=chantype(nD,':',[D.chantype repmat({'LFP'},1,size(nd,1))]);
save(nD);
D=nD;
