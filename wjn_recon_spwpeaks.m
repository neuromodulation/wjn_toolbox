function SPW=wjn_recon_spwpeaks(SPW,thresh)

if ~exist('thresh','var')
    thresh=0;
end

measures ={'data','tvalue'};

for n = 1:length(measures)

data = SPW.avg.(measures{n});
data(data==0)=nan;
time = SPW.avg.time;

for b = 1:length(SPW.avg.conditions)

for a = 1:size(data,1)
    zdata = wjn_zscore(data(a,:,b));
    [mp,ip]=findpeaks(zdata);
    [mn,in]=findpeaks(-zdata);
    irmp = mp<thresh;
    mp(irmp)=[];ip(irmp)=[];
    irmn = mn<thresh;
    mn(irmn)=[];in(irmn)=[];
    i = [in ip];
    m = [-mn mp];
    [~,mi]=max(abs(m));
    if isempty(mp)
        mm(a)=nan;
        ti(a)=nan;
    else
    mm(a)=m(mi);
    ti(a) = time(i(mi));
    end
end

SPW.avg.([measures{n} '_peaks'])(:,b) = mm;
SPW.avg.([measures{n} '_delays'])(:,b) = ti;
end
end
