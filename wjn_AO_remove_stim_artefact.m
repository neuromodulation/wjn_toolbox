function D=wjn_AO_remove_stim_artefact(filename)

D=spm_eeg_load(filename);

t = D.time;
T=D.AO.T;
Ts = D.AO.CStimMarker_1(1,:)/44000;
si = D.indsample(Ts-T(1));
ts = t(si);

%% Interpolate STIM

ssi = sort([-1:13]'+si);
ssi = ssi(:);
pct = numel(ssi)/D.nsamples*100;
d=D(:,:,1);
d(:,ssi,1)=nan;
for a = 1:size(d,1)   
    fd(a,:) = fillmissing(d(a,:),'linear');
end

D.AO.ssi = ssi;
D.SO.si=si;
D.AO.Ts = Ts;
D.AO.ts = ts;
save(D)


D=clone(D,['a' D.fname]);
D(:,:,:) = fd;
D.AO.ssi = ssi(:);
D.SO.si=si;
save(D)

% D=wjn_filter(D.fullfile,80,'low');
% D=wjn_filter(D.fullfile,[48 52],'stop');
% D=wjn_filter(D.fullfile,2,'high');
% D=wjn_downsample(D.fullfile,300);

% D=wjn_tf_wavelet(D.fullfile,[1:100],20)

%%

% figure,imagesc(D.time,D.frequencies,squeeze(log(D(20,:,:,1)))),axis xy

