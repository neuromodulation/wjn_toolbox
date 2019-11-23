function wjn_fox_lnom(T,n,modelspec)

nn=size(T,1);
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