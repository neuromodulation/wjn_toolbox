function [r,p,i]=wjn_corr_bs(x,y)

[r,p]=corr(x,y);

cr=1;
i=[];
ny=y;
n=0;
while cr > r 
    n=n+1;
    ny=y;
    ny(i)=[];
    nx=1:length(ny);
    M=repmat(ny,[1 length(ny)]);
    M(find(eye(size(M))))=nan;
    ar=corr(nx',M,'rows','pairwise');
    [cr,icr]=max(ar);
    if cr > r
        i(n) = find(ny(icr)==y,1);
    end
end

