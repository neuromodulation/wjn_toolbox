function nd  = mydiff(d,inter)
% calculate difference with equal vector length

if ~exist('inter','var')
    inter =0;
end


if size(d,1) ==1
    d=d';
end
nd = nan(size(d));
    
nd(2:end,:) = diff(d);

if inter
    nd(1) = nd(2);
end


