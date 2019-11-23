function [oly,ply,r,p,dly]=wjn_fit_loom(x,y,modelspec)




for a = 1:size(x,1)
    nx=x;
    ny=y;
    nx(a,:) =[];
    ny(a) = [];
    
%     keyboard
if exist('modelspec','var')
    model = fitlm(nx,ny,modelspec);
else
    model = fitlm(nx,ny);
end
    oly(a,1) = y(a);
    ply(a,1) = model.predict(x(a,:));
    
end

[~,~,r,p]=wjn_pc(oly,ply);


% figure
wjn_corr_plot(oly,ply)
xlabel('Original y')
ylabel('Predicted y')
% title('VALUE')
figone(7)
dly = abs(oly-ply);