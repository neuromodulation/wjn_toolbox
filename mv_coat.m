function ns=mv_coat(s,sr)
% clear
% x = load('cr_joyR')
% os = x.Joystick.values;
% sr = 1/x.Joystick.interval;
s = os;
% s(s<=sem(s))=0;
close all
% clear all
l=length(s);
t = linspace(0,l/sr,l);
figure
plot(t,s);
figone(20,30)

options.WindowStyle = 'normal';
options.Resize = 'on';

tf = str2double(inputdlg({'Start of useful block in seconds:','End of useful block in seconds:','direction of signal (-1/+1)'},'timer',1,{'1','max','+1'},options));
if isnan(tf(2))
    tf(2) = t(end);

end
    
s(1:sc(t,tf(1))) = nan;
s(sc(t,tf(2)):end)=nan;
ms = s*tf(3);
ms = ms-nanmedian(ms);
nms=ms;
% nms(ms<=nanstd(ms)) = 0;
plot(t,nms)
[ix,pix,pks]=auto_mv(nms,sr);

figure
subplot(2,1,1)
plot(t,nms)
hold on
plot(t(ix),ms(ix),'r+')
subplot(2,1,2)
for a = 1:length(ix);
   tempsig= ms(ix(a)-.5.*sr:ix(a)+.5.*sr);
plot(linspace(-500,500,length(tempsig)),tempsig)
hold on
end