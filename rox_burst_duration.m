function [bdur,bamp,n,btime,ibiamp,ibidur]=rox_burst_duration(bdata,bthresh,fs,minlength,type)

if  ~exist('fs','var')
    fs = 1000;
end

if ~exist('type','var') 
    type = 'graybiel';
    
end


d = mydiff(squeeze(bdata)>=bthresh); % mydiff von ([0 0 0 1 1 1 0 0])= [0 0 -1 0 0 1 0] -> -1 Start Burst, +1 Ende, um 1 nach vorne verschoben
i = find(d==1);
s = find(d==-1);

if isempty(i) || isempty(s)
    bdur = nan;
    n = 0;
    bamp = nan;
    btime = nan;
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
        
        bdur(a,1) = (istop(a)-istart(a))/fs*1000; %back to time scale
        bamp(a,1) = sum(bdata(istart(a):istop(a))-(bthresh/2)); %AU
%         btime(a,1) = round(nanmean([istart(a) istop(a)]));

        if a>1;
        ibidur(a,1)=(istart(a)-istop(a-1))/fs*1000;
        ibiamp(a,1)=nanmean(bdata(istop(a-1):istart(a)));
        end
        
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
        ibidur=(i(2:end)-(s(1:end-1)-1));
        
        for a = 1:length(bdur)
            bamp(a,1) = sum(bdata(istart(a):istop(a)));
            if a>1;
            ibiamp=nanmean(bdata(istop(a-1):istart(a)));
            end
            [~,itime] = max(bdata(istart(a):istop(a)));
            btime(a,1) = istart(a)+itime-1;
%             btime(a,1) = round(nanmean([istart(a) istop(a)]));
        end        
end



if exist('minlength','var')
    bamp(bdur<minlength)=[];
    btime(bdur<minlength)= [];
    bdur(bdur<minlength)=[];
    n = numel(bdur);
end
    
if isempty(bdur)
    bamp=nan;
    bdur = nan;
    btime = nan;
    n= 0;
end