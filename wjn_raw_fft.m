function [pow,f,rpow]=wjn_raw_fft(data,fs)

for a = 1:size(data,1);
[pow(a,:),f] = pwelch(data(a,:),hanning(round(fs)),0,round(fs),fs);
rpow(a,: ) = pow(a,:)./max(pow(a,:));
end
