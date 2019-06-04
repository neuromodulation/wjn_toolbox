function rtf = wjn_raw_baseline(tf,f)
tf = squeeze(tf);
if size(tf,1)==length(f)
    tf = tf';
end
% keyboard
i = isnan(tf);
tf(i)=0;
rtf = bsxfun(@rdivide,...
    bsxfun(@minus,...
    tf,...
    nanmean(tf)),...
    nanstd(tf))';
rtf(i')=nan;