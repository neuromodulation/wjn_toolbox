function [ix,pix,rpks]=auto_mv(s,sr)
% [istart,ivmax,ipeak,ivmin,istop,ss]=auto_mv(s,sr)

s(isnan(s)) = 0;
ns = s;
ns(s<=std(s)) = 0;
d = fdesign.lowpass('N,Fc',5,20,sr);
Hd = design(d,'butter');
l = length(s);
t = linspace(0,l/sr,l);
fs = filter(Hd,ns);
% ss = smooth(fs,sr*0.05);
as = abs(fs);
mas = as - nanmedian(as);

ad  = diff(mas);
td = t(2:end);



sad = filter(Hd,ad);
% sad = smooth(fad,sr*0.2);
figure,
subplot(3,1,1:2)
plot(td,sad);


sdsad = 2*std(sad);

[pks,pix] = findpeaks(sad,'minpeakheight',sdsad,'minpeakdistance',sr*1);
rpks = pks/max(pks)*100;

hold on
plot(td(pix),sad(pix),'k+','LineStyle','none')
plot(td,ones(size(td))*sdsad,'linestyle','--','color','k')
hold on
subplot(3,1,3)
for a = 1:numel(pix);
    tempsig = sad(pix(a)-.5*sr:pix(a));
    plot(tempsig)
    il=find(sad(pix(a)-.5*sr:pix(a))<sdsad,1,'last')
    hold on
    plot([il il],[0 max(tempsig)],'color','r','lineStyle','--','lineWidth',1.5)
    xil(a) = pix(a)-.5*sr+il-1;
end

subplot(3,1,1:2)
hold on
plot(td(xil),sad(xil),'r+')
figone(20,30)
ix = xil-2;
