function [pow,f,rpow,lpow]=wjn_raw_fft(data,fs,tw)

if ~exist('tw','var')
    tw = fs;
end

for a = 1:size(data,1)
[pow(a,:),f] = pwelch(data(a,:),hanning(round(tw)),0.5,round(tw),fs);
rpow(a,: ) = 100.*pow(a,:)./sum(pow(a,wjn_sc(f,[5:45 55:95])));
try
    lpow(a,:)= fftlogfitter(f,pow(a,:));
end
end
