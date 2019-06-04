function nD = wjn_tf_corr(filename,prefix,x,cond,type)
% nD = wjn_tf_corr(filename,x,cond,type);
% 
% 

if ~exist('type','var')
    type = 'spearman';
end
D=wjn_sl(filename);

d = D(:,:,:,ci(cond,D.conditions));

for a = 1:size(d,4)
    xd=d(:,:,:,a);
    rd(a,:) = xd(:);
    disp(['reshape trial ' num2str(a) ' of ' num2str(size(d,4))])
end
disp(['calculate ' type ' correlation'])
% keyboard
[r,p]=corr(rd,x,'type',type);
xd(:) = r(:);
r = xd;
xd(:) = p(:);
p = xd;

dims = [size(r) 2];

nD = clone(D,[prefix 'rp' D.fname],dims);
nD = conditions(nD,1,['R-' cond]);
nD = conditions(nD,2,['P-' cond]);
nD(:,:,:,1) =r;
nD(:,:,:,2) = p;
save(nD)

