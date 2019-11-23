function [y,mply,r,p,dly]=wjn_fit_lnom(x,y,n,modelspec)

nn = length(x);

ply = nan(nn,nn);


for a = 1:nn
    [Train, Test] = crossvalind('LeaveMOut', size(x,1), n);
    clear model
    if ~exist('modelspec','var')
        modelspec = 'linear';
    end
%     keyboard
    model = fitlm(x(Train,:),y(Train),modelspec);
%     oly(Test,a) = y(a:a+n-1);
    ply(Test,a) = model.predict(x(Test,:));
    
end

mply=nanmean(ply,2);

[~,~,r,p]=wjn_pc(mply,y);

figure
wjn_corr_plot(mply,y)
xlabel('Original y')
ylabel('Predicted y')
title('VALUE')
figone(7)
dly = abs(y-mply);