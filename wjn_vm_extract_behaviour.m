function D = wjn_vm_extract_behaviour(filename,channels,trials);

circledistance = 125;
circlesize = 70;

if ~exist('channels','var')
    channels = {'X','Y'};
end

if ~exist('trials','var')
    trials = {'S  1','S  4','S  7','S 10'};
end

D=wjn_sl(filename);

i = ci(trials,D.conditions);

x = squeeze(D(D.indchannel(channels{1}),:,i))./100000;
y = squeeze(D(D.indchannel(channels{2}),:,i))./100000;
i0 = D.indsample(0);
i1 = i0+ceil(D.fsample*.2);

for a = 1:length(i)
    [~,ix0]=max(abs(x(i0:i1,a)));
    [~,iy0]=max(abs(y(i0:i1,a)));
    mx0 = round(x(i0+ix0-1,a));
    my0 = round(y(i0+iy0-1,a));
    
    if (mx0<1 &&mx0>=0) && my0>1
        t(a) = 1;
    elseif mx0>1 && my0>1
        t(a) = 2;
    elseif mx0>1 && (my0<1 && my0>=0)
        t(a) = 3;
    elseif mx0>1 && my0<-1
        t(a) = 4;
    elseif (mx0<1 &&mx0>=0) && my0<-1
        t(a) = 5;
    elseif mx0<-1 && my0<-1
        t(a) = 6;
    elseif mx0<-1 && (my0<1 && my0>=0)
        t(a) = 7;
    elseif mx0<-1 && my0>1
        t(a) = 8;
    end
        
    xt = mx0/5*circledistance;
    yt = my0/5*circledistance;
    
    
    
    
    



