
load long_term2
X={[ubm0 ut3m0 ut8m0],[ubm1 ut3m1 ut8m1]};

X={[log(mbm0) log(mt3m0) log(mt8m0)] [log(mbm1) log(mt3m1) log(mt8m1)]};
p=anova_rm(X)

p0=ttestp(log(mbm0)-log(mbm1))
p3=ttestp(log(mt3m0)-log(mt3m1))
p8=ttestp(log(mt8m0)-log(mt8m1))



dub = ubm0-ubm1;
dut3 = ut3m0-ut3m1;
dut8 = ut8m0-ut8m1;

mubm0 = mean(ubm0);
subm0 = sem(ubm0);
mubm1 = mean(ubm1);
subm1 = sem(ubm1);
mdub = mean(dub);
sdub = sem(dub);


mut3m0 = mean(ut3m0);
sut3m0 = sem(ut3m0);
mut3m1 = mean(ut3m1);
sut3m1 = sem(ut3m1);
mdut3 = mean(dut3);
sdut3 = sem(dut3);


mut8m0 = mean(ut8m0);
sut8m0 = sem(ut8m0);
mut8m1 = mean(ut8m1);
sut8m1 = sem(ut8m1);
mdut8 = mean(dut8);
sdut8 = sem(dut8);

pb=ttestp(dub);
pt3=ttestp(dut3);
pt8=ttestp(dut8);

wjn_corr_plot(log(ualloff), log(balloff))
