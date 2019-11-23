function [rho,prho,r,p,ry,py,oly,ply]=wjn_corr_loom(x,y)

nin = unique([find(isnan(x)) find(isnan(y))]);
x(nin)=[];
y(nin)=[];

figure
xn = x;
nr = size(x,2);
ip = [1:2:2*nr;2:2:2*nr];
for nxi = 1:nr
    x = xn(:,nxi);
[x,i]=sort(x);
y = y(i);

[r,p]=wjn_pc(x,y);

% if r<0
%     yy=-y;
% else
    yy=y;
% end

for a = size(x,1):-1:1
    nx=x;
    ny=y;
    nx(a) =[];
    ny(a) = [];
    
    [lx,ly] = mycorrline(nx,ny,min(x),max(x));
    
    ry(a,1)=a;
    ny = yy;
    ny(a) = [];
    py(a,1) = rank(yy(a),ny)+1;
    oly(a,1) = y(a);
    ply(a,1) = ly(wjn_sc(lx,x(a)));
    
end

[rho,prho]=wjn_pc(ry,py);
[~,~,r,p]=wjn_pc(oly,ply);
% figure
subplot(nr,2,ip(1,nxi))
hold on
wjn_corr_plot(ry,py);
xlabel('original rank')
ylabel('predicted rank')
title('RANK')
subplot(nr,2,ip(2,nxi))
hold on
wjn_corr_plot(oly,ply)
xlabel('Original y')
ylabel('Predicted y')
title('VALUE')
figone(7*nr,13)
end