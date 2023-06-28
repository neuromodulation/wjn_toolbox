function rtf = wjn_raw_baseline(tf,f,ind)
tf = squeeze(tf);
if size(tf,1)==length(f)
    tf = tf';
end
% keyboard
if ~exist('ind','var')
    ind = 1:size(tf,1);
end
i=isnan(tf);
tf(i)=0;
rtf = bsxfun(@rdivide,...
    bsxfun(@minus,...
    tf,...
    nanmean(tf(ind,:))),...
    nanstd(tf(ind,:)))';
rtf(i')=nan;