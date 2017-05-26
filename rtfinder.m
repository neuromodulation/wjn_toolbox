function [startchn,vmaxstartchn,ampmaxchn,vmaxstopchn,stopchn,results]=stopfinder4(d,Fs,filename)
keep d Fs filename
close all
nr=0;
%peakrange = timerange;
options.WindowStyle = 'normal';
options.Resize = 'on';
n=0;    
t=linspace(0,length(d)/Fs,length(d));

oldevents = questdlg('Do you want to load an old event file?');

if length(oldevents) == 2;

rd = d;
rrd = d;
%[B,A]=butter(2,15/(Fs*0.5),'low');
span = 50; % Size of the averaging window

window = ones(span,1)/span; 
fd = convn(rd,window,'same');
mfrd = fd./prctile(fd,97.5);
smfrd = mfrd;
%smfrd(mfrd<=0)=0;


pthresh=find(smfrd > 0.2);
dpthresh(1)=0;
dpthresh(2:length(pthresh),1)=diff(pthresh);
rdpthresh=dpthresh/prctile(dpthresh,95);
[trash,plocs]=findpeaks(rdpthresh,'minpeakheight',0.1);
upthresh=pthresh(plocs);
clear trash
% pthresh=find(smfrd > 0.2);
% dpthresh(1)=0;
% dpthresh(1:length(pthresh),1)=derivative(pthresh);
% rdpthresh=dpthresh/prctile(dpthresh,95);
% [trash,plocs]=findpeaks(rdpthresh,'minpeakheight',0.1);
% upthresh=pthresh(plocs);
clear trash
for a = 1:length(upthresh);
    if upthresh(a) > 5000 && upthresh(a) < length(smfrd) - 7000 && ~isempty(find(smfrd(upthresh(a):upthresh(a)+7000,1) < 0.2,1,'first'));
        n=n+1;
        thresh(n,1)=upthresh(a);
        thresh(n,2)=upthresh(a)+find(smfrd(upthresh(a):upthresh(a)+7000,1) < 0.2,1,'first');
        
        [pks(n,1),threshpeaks(n,1)] = max(smfrd(thresh(n,1):thresh(n,2),1)); 
        threshmax(n,1)=threshpeaks(n,1)+thresh(n,1);
        threshmed(n,1)=round(median(thresh(n,:),2));
    end
end

clear pthresh upthresh dpthresh plocs rdpthresh
n=0;

%[unused,threshpeaks]= max(smfrd(thresh(:,1):thresh(:,2)),[],2);

%plot(t,smfrd);hold on;plot(t(threshmax),smfrd(threshmax),'r+');plot(t(threshmed),smfrd(threshmed),'m+');

%[pks,locs]=findpeaks(smfrd,'minpeakheight',0.2,'minpeakdistance',4000);

figure;
for a=1:length(threshmax);
    
    plot(-5:0.001:+5,smfrd(threshmax(a)-5*Fs:threshmax(a)+5*Fs),'color','k');
    hold on;
    plot(-5:0.001:+5,smfrd(threshmed(a)-5*Fs:threshmed(a)+5*Fs)+1.5,'color','r');
    hold on;
end

set(gca,'xtick',[-5:0.5:5]);
title([num2str(numel(threshmax)) ' peaks found in the data']);
legend('threshmax','threshmed');
str = {'threshmax','threshmed'};
locs = eval(str{listdlg('ListString',str,'ListSize',[160 50],'SelectionMode','single','PromptString','Choose peak definition mode')});
peakrange = str2double(inputdlg({'peakrange: '},'peakrange',1,{'2000'},options));


pkfig=figure;
pkplot=plot(t*1000,smfrd);hold on;plot(t(locs)*1000,smfrd(locs),'r+');
extrapksquest=questdlg('Do you want to add peaks manually?');

if length(extrapksquest)==3;
    
    extralocstring = inputdlg({'Put in all peaklocs you want to add, separated by a comma:'},'extrapks',1,{'[]'},options);
    extralocs = eval(extralocstring{1})';
    extrapks = smfrd(extralocs);
    
    [locs,isort] = sort([locs ; extralocs]);
    pkmerge = [pks;extrapks];
    pks = pkmerge(isort);
    plot(t(locs)*1000,smfrd(locs),'b+')
    title(['Added ' num2str(length(extralocs)) ' peaks manually resulting in ' num2str(length(locs)) ' peaks overall'])
    pause(5);
else 
    close
end

%assignin('caller','locs',eval(maxormedian));

% 
% dsmfrd = zeros(size(smfrd));
% dsmfrd(2:length(smfrd-1),1) = diff(smfrd);
% %dsmfrd = derivative(smfrd);
% rdsmfrd = dsmfrd./max(dsmfrd);
% frdsmfrd = convn(rdsmfrd,window,'same');
% dfrdsmfrd = zeros(size(frdsmfrd));
% dfrdsmfrd(2:length(smfrd-1),1) = diff(frdsmfrd);
% rdfrdsmfrd = dfrdsmfrd./max(dfrdsmfrd);
% frdfrdsmfrd = convn(rdfrdsmfrd,window,'same');

n=0;nr=0;
% x=zeros(size(smfrd));
% y=zeros(size(smfrd));
% z=zeros(size(smfrd));
% z2=z;
% y2=y;
% x(locs)=1;
locs(locs > length(smfrd)-10000) = [];
pks(locs > length(smfrd)-10000) = [];
locs(locs < 10000) = [];
pks(locs < 10000) = [];
% for a = 1:length(locs);
% %     if locs(a) < length(smfrd)-3000 && locs(a) > 5000;
%        
%        
%        [pstart,locstart] = findpeaks(frdfrdsmfrd(locs(a)-peakrange:locs(a)),'minpeakdistance',peakrange-1,'minpeakheight',0.01,'npeaks',1);  
%        [pend,locend] = findpeaks(frdfrdsmfrd(locs(a):locs(a)+peakrange),'minpeakdistance',peakrange-1,'minpeakheight',0.01,'npeaks',1);
%        
%        
%        if isempty(locstart) == 0 && isempty(locend) == 0;
%            
%            n=n+1;
%            vstart(a,1)=locs(a)-peakrange+locstart;       
%            %[istart,~]=find(frdfrdsmfrd(vstart(n)-peakrange/2 : vstart(n)) > pstart*1/8 & frdfrdsmfrd(vstart(n)-peakrange/2 : vstart(n)) < pstart*1/2,1,'first');
%            [istart,value]=find(frdfrdsmfrd(vstart(a)-peakrange/2 : vstart(a)) <= pstart * 1/2 ,1,'last');
% 
% 
%            
%            cistart(a,1)=vstart(a)-peakrange/2+istart;
% 
% 
%            vend(a,1)=locs(a)+locend;
%            
%            %[iend,~]=find(frdfrdsmfrd(vend(n): vend(n)+peakrange/2) > pend*1/20 & frdfrdsmfrd(vend(n): vend(n)+peakrange/2) < pend *1/15,1,'last');
%            [iend,trash]=find(frdsmfrd(vend(a):vend(a)+peakrange/2) >= 0 & frdfrdsmfrd(vend(a):vend(a)+peakrange/2) <= 0.05 ,1,'first');
%            clear trash
%            if isempty(iend);
%                [iend,trash]=find(frdfrdsmfrd(vend(a): vend(a)+peakrange/2) <= pend*1/4,1,'first');
%            
%            end
%            clear trash
%            ciend(a,1)=vend(a)+iend;
%          
%            
%            if  ~isempty(ciend(a,1)) && ~isempty(cistart(a,1)) && smfrd(cistart(a,1)) < 0.2 * pks(a) && smfrd(ciend(a,1)) < 0.2 * pks(a);
%                nr=nr+1;
%             
%                ccistart(a,1)=cistart(n,1);
%                cciend(a,1)=ciend(a,1);
% %                z2(cistart(a,1),1)=1;
% %                y2(ciend(a,1),1)=1;
%                [vmaxstart(a),locvmax(a)]=max(frdsmfrd(cistart(a,1):locs(a)));
%                [vmaxend(a),locvmaxend(a)]=min(frdsmfrd(ciend(a,1)-1000:ciend(a,1)));
%                diffvmaxend(a)=min(frdfrdsmfrd(ciend(a,1)-1000:ciend(a,1)));
%                clocvmax(a)=cistart(a,1)+locvmax(a);
%                clocmaxend(a)=ciend(a,1)-1000+locvmaxend(a);
% %                results(nr,:) = [nr,vmaxstart(nr),vmaxend(nr),diffvmaxend(nr),pks(a),ciend(n,1)-cistart(n,1)];
%                locampmax(a)=threshmax(a);
%            end
%        end
%        
% %     end
% end
% 

rlocs = round(locs*0.1);
rpeakrange=round(peakrange*0.1);
nrrd=rrd;
nrrd(isnan(rrd))=0;
rrrd=decimate(nrrd,10,'fir');
drrrd=zeros(size(rrrd));

drrrd(2:length(rrrd))=diff(rrrd);
rdrrrd=drrrd/max(drrrd)*100;



%locsplotter=[ccistart,clocvmax',locampmax',clocmaxend',cciend];
%locsplotterp=locsplotter;
% locsplotterp(locsplotter == 0,1:5) = [];
%locsplotter(locsplotter == 0) = nan;
%rlocsplotterp=round(locsplotterp.*0.1);
%srdlocsplotterp=sort(reshape(rlocsplotterp,numel(rlocsplotterp),1));
%srdlocsplotterp(srdlocsplotterp==0)=[];
rt=1:length(rrrd);
a=0;
n=0;
clear okevent;
% def=figure;
while a <= length(locs)-1;
    a=a+1;
    close;
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 1 scrsz(3) scrsz(4)])
    set(gcf,'Selected','on')

    plot(rt,rrrd,'k');
    %hold on;
   % plot(rt(srdlocsplotterp),rrrd(srdlocsplotterp),'r+');
    hold on;
    plot(rt,rdrrrd,'r');hold on; plot(rt,zeros(size(rt)),'k');
   % hold on;
   % plot(rt(srdlocsplotterp),rdrrrd(srdlocsplotterp),'k+');
    xlim([rlocs(a)-rpeakrange rlocs(a)+rpeakrange]);
    title(['Peak nr. ' num2str(a) ' of ' num2str(length(locs))]);
    [xdata,trash,button]=ginput;
    
    if (~isempty(button) && ~isempty(find(button==8, 1))) || length(find(button)) < 5;
        a=a-1;
    elseif (~isempty(button) && ~isempty(find(button==27, 1,'last')))
      
        
    elseif ~isempty(find(button == 49,1)) && ~isempty(find(button == 50,1)) && ~isempty(find(button == 51,1)) && ~isempty(find(button == 52,1)) && ~isempty(find(button == 53,1)) && isempty(find(button==27, 1,'last'));
        n=n+1;
       % event(n,:) = locsplotter(a,:);
        xdata=round(xdata.*10);
     
            event(n,1)=xdata(find(button == 49,1,'last'));
       
       
            event(n,2)=xdata(find(button == 50,1,'last'));
     
       
            event(n,3)=xdata(find(button == 51,1,'last'));
 

            event(n,4)=xdata(find(button == 52,1,'last'));
       
 
            event(n,5)=xdata(find(button == 53,1,'last'));
   
        resulter(n,:)=round(event(n,:)*0.1);
        results(n,:)=[n,trapz(abs(drrrd(resulter(n,1):resulter(n,3),1))),drrrd(resulter(n,2)),rrrd(resulter(n,3)),trapz(abs(drrrd(resulter(n,3):resulter(n,5),1))),drrrd(resulter(n,4)),event(n,5)-event(n,1)];
        clear xdata button
    else
        a = a-1;
    end
            

%             results(n,:) = [n,smfrd(okevent(n,2)),smfrd(okevent(n,3)),smfrd(okevent(n,4)),okevent(n,5)-okevent(n,1)];
            %display(event(n,:));
end


clear start locvmax locampmax locvmaxstart locvmaxend stop t
save([filename '_eventfile'])

elseif length(oldevents) == 3;
    [file,path]=uigetfile('_eventfile');
    load(fullfile(path,file));
    breaquest=questdlg('Do you want to go to keyboard mode?');
    if length(breaquest) == 3;
    keyboard;
    end
end

start=event(:,1);
locvmaxstart=event(:,2);
locampmax=event(:,3);
locvmaxstop=event(:,4);
stop = event(:,5);


startchn=zeros(size(d));
vmaxstartchn=zeros(size(d));
ampmaxchn=zeros(size(d));
vmaxstopchn=zeros(size(d));
stopchn=zeros(size(d));
startchn(start,1)=1;
vmaxstartchn(locvmaxstart,1)=1;
ampmaxchn(locampmax,1)=1;
vmaxstopchn(locvmaxstop,1)=1;
stopchn(stop,1)=1;
t=1:length(d);

figure;
plot(t,smfrd);hold on;plot(t(locs),smfrd(locs),'m+');hold on;plot(t(start),smfrd(start),'r+');hold on;plot(t(stop),smfrd(stop),'y+');hold on;plot(t,stopchn,'color','r');hold on; plot(t,vmaxstopchn,'color','y');
title([num2str(n) ' events found from ' num2str(numel(locs)) ' peaks']);




for a = 1:length(start); mstart(:,a) = d(start(a,1)-1000:start(a,1)+peakrange);end
for a = 1:length(stop); mend(:,a) = d(stop(a,1)-peakrange:stop(a,1)+1000);end
figure;
subplot(2,1,1);
plot(-1000:1:peakrange,mstart,'color',[0.5 0.5 0.5],'LineWidth',0.5);hold on;plot(-1000:1:peakrange,mean(mstart,2),'color','k','LineWidth',2);
title('Start of uncorrected movement');
subplot(2,1,2);
plot(-peakrange:1:1000,mend,'color',[0.5 0.5 0.5],'LineWidth',0.5);hold on;plot(-peakrange:1:1000,mean(mend,2),'color','k','LineWidth',2);
title('End of uncorrected movement');




