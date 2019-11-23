function sdata = wjn_smoothx(data,sk)

for a = 1:size(data,1)
    sdata(a,:)=wjn_smoothn(data(a,:),sk);
end