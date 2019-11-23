function [bdur,bamp,n,btime,bpeak,ibi,bregularity,basym]=wjn_burst_duration(bdata,bthresh,fs,minlength,type)

if  ~exist('fs','var')
    fs = 1000;
end

if ~exist('type','var') || isempty(type)
    type = 'graybiel';
end


d = mydiff(squeeze(bdata)>=bthresh); % mydiff von ([0 0 0 1 1 1 0 0])= [0 0 -1 0 0 1 0] -> -1 Start Burst, +1 Ende, um 1 nach vorne verschoben
i = find(d==1);
s = find(d==-1);
z = zeros(size(d));
ns = length(bdata)/fs;
if isempty(i) || isempty(s)
    bdur = nan;
    n = 0;
    bamp = nan;
    btime = nan;
    ibi = nan;
    bregularity = nan;
    return
end
if s(1)<i(1)
    i=[1; i];
end

i = i(1:length(s));
n= numel(i);



% bdur = (s-i)/fs*1000;
if strcmp(type,'graybiel')
    for a = 1:length(i)
        bstart = find(bdata(i(a):-1:1)<=(bthresh/2),1);
       
        
        if isempty(bstart)
            bstart = i(a)-1;
        end

         bstop = find(bdata(i(a):end)<=(bthresh/2),1);
        if isempty(bstop)
            bstop = (length(bdata)-i(a))-1;
        end
        istart(a) = (i(a)-bstart)+1; %index sample
        istop(a) = (i(a)+bstop)-1;
        z(istart(a):istop(a))=a;
        bdur(a,1) = (istop(a)-istart(a))/fs*1000; %back to time scale
        bamp(a,1) = nanmean(bdata(istart(a):istop(a))-(bthresh/2)); %AU
%         btime(a,1) = round(nanmean([istart(a) istop(a)]));
        [~,itime] = max(bdata(istart(a):istop(a)));
        btime(a,1) = istart(a)+itime-1;
    end
    
    idup= find(mydiff(istart)==0);
    
    if ~isempty(idup)      
        warning([ num2str(numel(idup)) ' duplicate bursts found.'])
%         keyboard
        istart(idup) = [];
        istop(idup) =[];
        bdur(idup) = [];
        bamp(idup) = [];
        btime(idup) = [];
    end
    
elseif strcmp(type,'brown')
        istart = i;
        istop = s;
        bdur = (s-i)./fs*1000;
        btime=zeros(size(bdata));
        for a = 1:length(bdur)
            bamp(a,1) = nanmean(bdata(istart(a):istop(a))-(bthresh));
            [~,itime] = max(bdata(istart(a):istop(a)));
            bpeak(a,1) = istart(a)+itime-1;
            btime(istart(a):istop(a))=a;
%             btime(a,1) = round(nanmean([istart(a) istop(a)]));
        end        
end


% keyboard
if exist('minlength','var')
    iout = find(bdur>=mean(bdur)+3*std(bdur)|bdur<=minlength);
    
    bamp(iout)=[];
    bdur(iout)=[];
    bpeak(iout)=[];
    n = numel(bdur);
    
    for a = 1:length(iout)
        btime(btime==a)=0;
        btime(btime>a)=btime(btime>a)-1;
    end
end
% keyboard

for a = 1:length(bdur)
    btime(btime==a) = bdur(a);
end

if isempty(bdur)
    bamp=nan;
    bdur = nan;
    btime = nan;
    bpeak = nan;
    n= 0;
    
end


ibi = nanmean(diff(btime./fs));
bregularity=1/nanstd(diff(btime./fs));

sdur = sort(bdur);
f=fitlm(sdur',[1:length(sdur)]');
basym = f.MSE;
% keyboard
n=n/ns;
% keyboard