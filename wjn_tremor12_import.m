function [data,t,titles,fs]=wjn_tremor12_import(filename)


d=importdata(filename);
data = d.data(:,2:end);
nt = d.data(:,1);
fs = 1000/median(diff(nt));
t = (nt-nt(1))/1000;
titles = d.colheaders(:,2:end);


figure
subplot(2,1,1)
plot(t,data)
[~,f,p]=wjn_raw_fft(data',fs);
subplot(2,1,2)
plot(f,p)

