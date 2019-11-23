function [oly,ply,r,p,dly]=wjn_fit_kfold(x,y,k)

if ~exist('k','var')
    k=5;
end
nn = length(x);
kind = crossvalind('kfold', nn, k);
   

for a = 1:k
    clear model
    model = fitlm(x(~(kind==a)),y(~(kind==a)));
%     oly(Test,a) = y(a:a+n-1);
    ply(kind==a,1) = model.predict(x(kind==a,1));
    
end

mply=nanmean(ply,2);

[~,~,r,p]=wjn_pc(mply,y);
oly = y;
% figure
wjn_corr_plot(mply,y)
xlabel('Original y')
ylabel('Predicted y')
title('VALUE')
figone(7)
dly = abs(oly-ply);