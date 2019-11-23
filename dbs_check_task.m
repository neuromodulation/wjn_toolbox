figure;
%%
i = 2;
j = 5;
imagesc(D.time, D.frequencies, squeeze(D(i, :, :, j)))
caxis(0.5*[-1 1]);
title([char(D.chanlabels(i)) ' ' char(D.conditions(j))]);
%%