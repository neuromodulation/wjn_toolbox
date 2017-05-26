function [data,t,f]=quick_TF(data,nfft,overlap,fs)
%[data,t,f]=quick_TF(data,nfft,overlap,fs)
l = length(data);
t = linspace(0,l/fs,l);

if ~overlap
    nnt = nfft;
else
nnt = overlap*nfft;
end
nseg = l/nnt;

for a = 1:nseg-2;
    [tf(a,:),f]=pwelch(data(a*nnt:a*nnt+nfft),hann(nfft),0,nfft,fs);
    nt(a) = t(a*nnt)
end

figure
imagesc(nt,f,tf'),axis xy
t=nt;