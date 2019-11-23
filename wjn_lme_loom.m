function [oly,ply,r,p,dly]=wjn_lme_loom(T,modelspec,leave_out)

ns = unique(T.(leave_out));
oly = [];
ply=[];
for a = 1:length(ns)
    nT = T;
    iout=nT.(leave_out)==ns(a);
    nT(iout,:)=[];
    model = fitlme(nT,modelspec);
    oly = [oly;T.(model.ResponseName)(iout)];
    ply = [ply; model.predict(T(iout,:))];
    
end

[~,~,r,p]=wjn_pc(oly,ply);


figure
wjn_corr_plot(oly,ply)
xlabel('Original y')
ylabel('Predicted y')
% title('VALUE')
figone(7)
dly = abs(oly-ply);