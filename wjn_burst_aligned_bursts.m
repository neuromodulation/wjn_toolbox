function wjn_burst_aligned_bursts(d)

%%
load bdata_MM06_LT.mat dpk ss sSTN

d = dpk

istn = ci(sSTN,d.channels);
icog = ci(ss,d.channels);

ith = istn;
iburst = icog;

thresh=prctile(d.bdur{ith},1);
close all
timerange = 2;
di = squeeze(d.burstduration(ith,:,:));
dr = squeeze(d.burstraster(iburst,:,:));
drr = dr(:,randperm(length(dr)));
s=size(dr);
dr = [nan(s) dr nan(s)];
drr = [nan(s) drr nan(s)];
    rt = d.t-d.t(1);
      ix = wjn_sc(rt,timerange);
      lt = linspace(-timerange,timerange,ix*2);
    n=0;
    bb=[];br = [];
for a  =1:size(di,1)
    i = find(di(a,:)>thresh); 
   
    for b = 1:length(i)
        n=n+1;
%         bb(n,:) = dr(a,s(2)+i(b)-ix:s(2)+i(b)+ix);
        l=lt(find(dr(a,s(2)+i(b)-ix+1:s(2)+i(b)+ix-1)==1));
        npre(b) = numel(find(l<=1 & l>=1));
        bb = [bb l];
        br = [br lt(find(drr(a,s(2)+i(b)-ix+1:s(2)+i(b)+ix-1)==1))];
    end
end

[h,t]=hist(bb,lt(1):.1:lt(end));

[hr,tr]=hist(br,lt(1):.1:lt(end));

figure,
bar(t,h)
hold on
plot(tr,hr)
pburst=sum(~npre)/length(npre)


% bar(tr,hr./b)
% figure
% plot(nansum(bb))