function poly5 = wjn_poly5(fname,fs,chanlabels)

for a = 1:length(chanlabels)
    channels{a}.unit_name = 'uV';
    channels{a}.name = chanlabels{a};
end
poly5 = TMSi.Poly5([fname '.Poly5'], fname,fs,channels);
