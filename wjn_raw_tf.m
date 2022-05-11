function [tf,t,f,rtf]=wjn_raw_tf(data,fs,timewindow,timestep)

tf=[];rtf=[];
nfft = round(timewindow/fs*1000);
timestep = round(timestep/fs*1000);
for a = 1:size(data,1)


[~,f,t,ctf]=spectrogram(data(a,:)',hann(nfft), ...
    nfft-timestep,nfft,fs,'yaxis','power');
tf(:,:,a)=ctf;
try
    rtf(:,:,a) = wjn_raw_baseline(tf(:,:,a),f);
end
end