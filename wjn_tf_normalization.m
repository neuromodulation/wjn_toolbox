function D=wjn_tf_normalization(filename,lim,mode)

if ~exist('mode','var')
    mode = 'rpow';
end

if ~exist('lim','var')
   lim=[3 47 53 97];
end

D=wjn_sl(filename);
f=D.frequencies;
for a = 1:D.nchannels
    for b = 1:D.ntrials
        mpow = squeeze(nanmean(D(a,:,:,b),3));
        s = nanstd(mpow([wjn_sc(f,lim(1)):wjn_sc(f,lim(2)) wjn_sc(f,lim(3)):wjn_sc(f,lim(4))]));
        r = nansum(mpow([wjn_sc(f,lim(1)):wjn_sc(f,lim(2)) wjn_sc(f,lim(3)):wjn_sc(f,lim(4))]));
        t.spow = D(a,:,:,b)./s;
        t.rpow = (D(a,:,:,b)./r).*100;
        d(a,:,:,b) = t.(mode);
    end
end

nD = clone(D,['n' D.fname]);
nD(:,:,:,:)= d;
save(nD);
D=nD;
