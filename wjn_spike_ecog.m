function D=wjn_spike_ecog(filename)
D=wjn_spikeconvert(filename,[],1,1,1000)
% D=wjn_downsample(D.fullfile,1000,400);
% D=wjn_filter(D.fullfile,[48 52],'stop');
% D=wjn_filter(D.fullfile,1,'high');

% D=wjn_linefilter(D.fullfile);
D=wjn_ecog_rereference(D.fullfile);