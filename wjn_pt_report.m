function p=wjn_pt_report(d1,d2,paired,ni)

if ~exist('d2','var') || isempty(d2)
    d2 = zeros(size(d1));
    onesample = 1;
else
    onesample = 0;
end


if ~exist('paired','var') || isempty(d2)
    paired = 0;
    dp1 = d1;
    dp2 = d2;
else
    paired = 1;
    dp1 = d1-d2;
    dp2 = zeros(size(dp1));
end

if ~exist('ni','var') 
    ni = 5000;
end

i = unique([find(isnan(dp1)) find(isnan(dp2))]);
d1(i)=[];
d2(i) = [];

p = permTest(ni,dp1,dp2);

    
figure
if onesample
    mybar(d1)
else
    mybar({d1 d2})
end

md1 = nanmean(d1);
md2 = nanmean(d2);
sd1 = nanstd(d1);
sd2 = nanstd(d2);

if p>0;
    myannotation({['Mean d1: ' num2str(md1,5) ' Std d1: ' num2str(sd1,5)],...
    ['Mean d2: ' num2str(md2,5) ' Std d2: ' num2str(sd2,5)],...
    ['P - Value : ' num2str(p,5)]})
else
    myannotation({['Mean d1: ' num2str(md1,5) ' Std d1: ' num2str(sd1,5)],...
    ['Mean d2: ' num2str(md2,5) ' Std d2: ' num2str(sd2,5)],...
    ['P - Value < 0.0001']})
end
