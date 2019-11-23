function i = wjn_index_segments(seg,d)

i=[];
for a = 1:size(seg,1)
    i=[i,wjn_sc(d,seg(a,1)):wjn_sc(d,seg(a,2))];
end