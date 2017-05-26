function [smCUE,meCUE,laCUE,allCUE] = cuefinder(data)


rd=data/prctile(data,95);
drd=zeros(size(rd));
drd(2:end,1)=diff(rd);

[pks,locs]=findpeaks(drd,'minpeakheight',0.2);

ismCUE=locs(rd(locs) < 0.4 & rd(locs)>0.3);
imeCUE=locs(rd(locs) < 0.7 & rd(locs)>0.6);
ilaCUE=locs(rd(locs) < 1.2 & rd(locs)>0.9);

smCUE=zeros(size(rd));
meCUE=zeros(size(rd));
laCUE=zeros(size(rd));
allCUE = zeros(size(rd));


smCUE(ismCUE)=1;
meCUE(imeCUE)=1;
laCUE(ilaCUE)=1;
allCUE(ismCUE)=1;
allCUE(imeCUE)=1;
allCUE(ilaCUE)=1;
x=1:length(data);

figure;
plot(x,rd);hold on;plot(x,drd,'color','r');hold on;
plot(x(ismCUE),rd(ismCUE),'b+');hold on;plot(x(imeCUE),rd(imeCUE),'g+');hold on;plot(x(ilaCUE),rd(ilaCUE),'r+');
title([num2str(numel(ismCUE)) ' small, ' num2str(numel(imeCUE)) ' medium, and ' num2str(numel(ilaCUE)) ' large events found.']);    
pause(2);
