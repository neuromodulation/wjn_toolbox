function [Dn] = reepoch(file)
cdir = cd;
D=spm_eeg_load(file);
nsample = D.fsample*0.25; 

[path,ID,~]=fileparts(file);

d=[];ttrials=[];
for a=1:D.ntrials;
    if strcmp(D.conditions(a),'R') ||  strcmp(D.conditions(a),'RT') ...
            || strcmp(D.conditions(a),'R_OFF') ||  strcmp(D.conditions(a),'RT_OFF')
        d = [d squeeze(D(:,:,a))] ;
        ttrials = [ttrials a];
    end
end
dim = size(D);
ndim = dim; 
ndim(2) = nsample;
ndim(3) = floor(length(d)/nsample);
Dn = clone(D,['re' D.fname],ndim,2);
n=1;
for a = 1:ndim(3);
    Dn(:,1:ndim(2),a) = d(:,n:n+ndim(2)-1);
    n = n+ndim(2);
end

nfileind = D.fileind(ttrials);
ncond = D.conditions(ttrials);
it = 1:D.nsamples:length(ttrials)*D.nsamples;
n=1;
for a = 1:Dn.ntrials; 
    nt = a*Dn.nsamples;
    xi(a) = find(it<nt,1,'last');
    Dn.oconditions(a) = ncond(xi(a));
    Dn.fileind(a) = nfileind(xi(a));  
end
Dn.xi = xi;
n=0;
for a = 1:16:Dn.ntrials;  
    n=n+1;
    if a+15 <= Dn.ntrials;
    Dn = conditions(Dn,a:a+15,[Dn.oconditions{a} num2str(n)]);
    end
    nconds = n;
end

cd(D.path);load(['../tremor_definition/' ID '_tremor_definition.mat'],'tfreq','tf','nchans','tfpads','tchans','C','U')
rp=[];up=[];

flow = sc(C.f,1.5);
fhigh = sc(C.f,20);

for a = 1:nchans;
[pks,ttf] = findpeaks(U.srpow(a,flow:fhigh),'minpeakheight',median(U.srpow(a,:))+2*std(U.srpow(a,:)))
    if ~isempty(ttf);
       [junk,ittf]=max(pks);
        utf(a,1) = ttf(ittf)+flow-1;
        utfreq(a,1) = C.f(utf(a));
        utfpads(a,1:2) = [sc(C.f,(utfreq(a)-1)) sc(C.f,utfreq(a)+1)];
    else
        utf(a,1) = nan;
        utfreq(a,1) = nan;
        utfpads(a,1:2) = nan;
    end
end

if ~nansum(utf);
    mode = 'median + standard deviation';
    for a = 1:nchans;
    [pks,ttf] = findpeaks(U.srpow(a,flow:fhigh),'minpeakheight',median(U.srpow(a,:))+std(U.srpow(a,:)))
        if ~isempty(ttf);
           [junk,ittf]=max(pks);
            utf(a) = ttf(ittf)+flow-1;
            utfreq(a) = C.f(utf(a));
            utfpads(a,1:2) = [sc(C.f,utfreq(a)-1) sc(C.f,utfreq(a)+1)];
        else
            utf(a) = nan;
            utfreq(a) = nan;
            utfpads(a,1:2) = nan;
        end
    end    
else
    mode = 'median + 2 * Standard Deviation';
end
uchans = ~isnan(utf);
for b = 1:length(tchans);
    junk=[];junk1=[];junk2=[];
    if tchans(b)
        for c = 1:C.nseg;
            junk1 = [junk1 mean(C.spow(c,b,tfpads(b,1):tfpads(b,2)),3)];
        end
        rp(b,:) = junk1;
    end
     if uchans(b)
        for c = 1:C.nseg;
            junk2 = [junk2 mean(U.spow(c,b,utfpads(b,1):utfpads(b,2)),3)];
        end
        up(b,:) = junk2;
     end
end
rp = max(rp,1);
up = max(up,1);
nrp = rp(ttrials);
nup = up(ttrials);
t = 1:D.nsamples/D.fsample:length(ttrials)*(D.nsamples/D.fsample);
if strmatch('Undefined',Dn.condlist)
    x = 1:4:4*(Dn.nconditions-1);
    Dn.new_conditions = 1:nconds-1;
else
    x = 1:4:4*Dn.nconditions;
    Dn.new_conditions = 1:nconds;
end

ry = interp1(t,nrp,x,'nearest');
uy = interp1(t,nup,x,'nearest');
% plot(t,nup,'o',x,uy,'+');%hold on;
% plot(x,y,'g+');
Dn.unrecemg = uy;
Dn.recemg = ry;
Dn = badtrials(Dn,Dn.indtrial('Undefined'),1);

Dn.chanlabels
Dn.chantype
save(Dn);
cd(cdir);