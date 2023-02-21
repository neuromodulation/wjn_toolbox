function p=wjn_pt(d1,d2,ni)
%function p=wjn_pt(d1,d2,ni)

if ~exist('d2','var') || isempty(d2)
    d2 = zeros(size(d1));
end

if ~exist('ni','var')
    ni = 10000;
end

d1(isnan(d1))=[];
d2(isnan(d2))=[];

if size(d1,2)<size(d1,1)
    d1=d1';
end

if size(d2,2)<size(d2,1)
    d2=d2';
end

% % keyboard

if length(unique([d1,d2]))==1
    p=nan;
    return
end

mode='avg';

ns1=length(d1);
ns2=length(d2);


b=cat(2,d1,d2);
if strcmp(mode,'avg')
    mean1=mean(d1);   mean2=mean(d2);
elseif strcmp(mode,'med')
    mean1=median(d1);   mean2=median(d2);
end


for it=1:ni
    
    ind=randperm(ns1+ns2);
    
    
    for k=1:ns1
        repb1(k)=b(ind(k));
    end
    for k=(ns1+1):ns1+ns2
        repb2(k-ns1)=b(ind(k));
    end
    if strcmp(mode,'avg')
        repdiff(it)=mean(repb1(:))-mean(repb2(:));
    elseif strcmp(mode,'med')
        repdiff(it)=median(repb1(:))-median(repb2(:));
    end
    
    
end
tStat=(mean1-mean2);
cont=0;
for it=1:ni
    if abs(repdiff(it))>abs(tStat)
        cont=cont+1;
    end
end
p=cont/ni;

