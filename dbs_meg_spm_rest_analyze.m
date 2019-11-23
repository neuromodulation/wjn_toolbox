function dbs_meg_spm_rest_analyze(S)

if nargin == 0
    S = [];
end

if isfield(S, 'D')
    if ~isa(S.D, 'meeg')       
        S.D = spm_eeg_load(S.D);
    end
else
    S.D = spm_eeg_load;
end

if ~isfield(S, 'refchan')
    [selection, ok]= listdlg('ListString', chanlabels(S.D), 'SelectionMode', 'single' ,'Name', 'Select reference channel' , 'ListSize', [400 300]);
    if ~ok
        return;
    end
    S.refchan = chanlabels(S.D, selection);
    S.refchan = S.refchan{1}; 
end

if ~isfield(S, 'freqrange')
    S.freqrange = spm_input('Frequency range (Hz):', '+1', 'r', '', 2);
end

S.centerfreq = mean(S.freqrange);
S.tapsmofrq  = 0.5*diff(S.freqrange);

D = S.D;
refchan = S.refchan;
%%
res = mkdir(D.path, [refchan '_' num2str(S.freqrange(1)) '_' num2str(S.freqrange(2)) 'Hz']);
cd(fullfile(D.path, [refchan '_' num2str(S.freqrange(1)) '_' num2str(S.freqrange(2)) 'Hz']));
outdir = pwd;
%%
range = S.freqrange;
%%
ranges = {[5 45], [55 95]};
rangeres = [2.5, 7.5];
rangelabels = {'low', 'high'};
%%

f = 0;
for i = 1:numel(ranges)
    if range(1)>=ranges{i}(1) && ...
            range(2)<=ranges{i}(2)
        f = i;
    end
end

mask = fullfile(D.path, 'cohimages', refchan, rangelabels{f}, 'sigmask.nii');

ind = D.pickconditions(D.condlist);
data = D.ftraw(0);
data.trial = data.trial(ind);
data.time =  data.time(ind);

magind = strmatch('MEGMAG', D.chantype);
if ~isempty(magind)
    for i = 1:numel(data.trial)
        data.trial{i}(magind, :) = [];
    end
    data.label(magind) = [];
    D = chantype(D, magind, 'Other');
end


S.D = D;
%%
cfg = [];
cfg.output ='powandcsd';
cfg.channelcmb= {refchan, 'MEG'};
cfg.keeptrials = 'no';
cfg.keeptapers='no';
cfg.taper = 'dpss';
cfg.method          = 'mtmfft';
cfg.foilim     = ranges{f};
cfg.tapsmofrq = rangeres(f);

inp = ft_freqanalysis(cfg, data);

cfg = [];
cfg.method = 'coh';
coh = ft_connectivityanalysis(cfg, inp);
%%
dummy=[];
dummy.label   = coh.labelcmb(:, 2);
dummy.powspctrm   = coh.cohspctrm;
dummy.freq    = coh.freq;
dummy.dimord  = 'chan_freq';

  
% mask = nifti(mask);
% [junk, lind] = min(abs(dummy.freq - range(1)));
% [junk, hind] = min(abs(dummy.freq - range(2)));
%   
% mask = squeeze(any(mask.dat(:, :, lind:hind), 3));
% 
% chanind = spm_eeg_mask2channels(D, mask);

% cfg=[];
% cfg.grad = D.sensors('MEG');
% cfg.zparam='powspctrm';
% cfg.xparam='freq';
% cfg.xlim= dummy.freq([lind hind]);
% cfg.zlim = [0 max(mean(dummy.powspctrm(:, lind:hind), 2))];
% cfg.comment ='xlim';
% cfg.commentpos='middlebottom';
% cfg.electrodes='highlights';
% cfg.highlight = spm_match_str(dummy.label, D.chanlabels(chanind));
% cfg.style = 'straight';
% figure;
% ft_topoplotTFR(cfg, dummy);
% colorbar;
% set(gcf, 'Position', get(0,'ScreenSize'));
% print('-dtiff', '-r600', fullfile(outdir, 'cohpattern.tiff'));
% close(gcf)
%%
if ~isfield(S, 'lambda')
    S.lambda = '0.01%';
end
S.fixedori = 0;
S.timewindows = {[D.time(1) D.time(end)]};
S.contrast = 1;
S.preview = 0;
S.bycondition = 0;
S.singleimage = 1;
S.usewholetrial = 0;
S.cohshuffle = 0;
S.geteta = 1;
S.gridres = 10;
S.mniout = 1;

spm_eeg_ft_beamformer_freq(S);

movefile(fullfile(D.path, 'images'), fullfile(outdir, 'images'));
movefile(fullfile(D.path, 'ori.mat'), fullfile(outdir, 'ori.mat'));

outfile = fullfile(outdir, 'images', ['img_' spm_str_manip(fname(S.D), 'r') '_coh.nii']);
soutfile = fullfile(outdir, 'images', ['simg_' spm_str_manip(fname(S.D), 'r') '_coh.nii']);
spm_smooth(outfile, soutfile, [8 8 8]);
%%
vol = spm_vol(soutfile);
[Y,XYZ] = spm_read_vols(vol);
thresh = nanmean(Y(:))+2*nanstd(Y(:));
%%
[p, ff, x] = fileparts(soutfile);

Y(Y<thresh) = NaN;
vol.fname = fullfile(p, ['thresh' ff '.nii']);
spm_write_vol(vol, Y);


XYZ = inv(vol.mat)*[XYZ;ones(1,size(XYZ,2))];
XYZ = XYZ(1:3,:);

Y=Y(:);
XYZ(:,isnan(Y))=[];
Y(isnan(Y))=[];

[junk, ind] = max(Y);
gXYZ = vol.mat*[XYZ(:, ind); 1];
pos = gXYZ(1:3,:)';


load(fullfile(outdir, 'ori.mat'));
try
    seta = filtsource;
end

[junk, ind] = min(sqrt(sum((seta.pos - repmat(pos, size(seta.pos, 1), 1)).^2, 2)));

mom = imag(seta.avg.csd{ind})./norm(seta.avg.csd{ind});

spm_figure('GetWin','Graphics'); clf

sdip= [];
sdip.n_seeds = 1;
sdip.n_dip   = 1;
sdip.Mtb     = 1;
sdip.j{1}    = mom(:);
sdip.loc{1}  = pos(:);
spm_eeg_inv_ecd_DrawDip('Init', sdip, fullfile(spm('dir'), 'canonical', 'single_subj_T1.nii'));
spm_eeg_inv_ecd_DrawDip('drawdip', 1, 2);
spm_orthviews('Xhairs', 'off');
colormap('gray');
print('-dtiff', '-r600', fullfile(outdir, 'dipole.tiff'));

save(fullfile(outdir, 'dipole.mat'), 'pos', 'mom');
%%
vol  = D.inv{1}.forward(1).vol;
grad = D.inv{1}.datareg(1).sensors;

M1 = D.inv{1}.datareg(1).toMNI;
[U, L, V] = svd(M1(1:3, 1:3));
M1(1:3,1:3) =U*V';

vol = ft_transform_vol(M1, vol);
grad = ft_transform_sens(M1, grad);

refind = strmatch(refchan, data.label);

channel = ft_channelselection({'MEGREF', 'MEG'}, data.label);

[pvol, pgrad] = ft_prepare_vol_sens(vol, grad, 'channel', channel);

lf = ft_compute_leadfield(pos, pgrad, pvol)*mom;

gmegind = spm_match_str(pgrad.label, D.chanlabels(D.meegchannels('MEG')));

dummy=[];
dummy.label=pgrad.label(gmegind);
dummy.powspctrm=abs(lf(gmegind));
dummy.freq = 0;
dummy.dimord='chan_freq';
dummy.grad = D.inv{1}.datareg(1).sensors;
%%
cfg=[];
cfg.channel = 'MEG';
cfg.zparam='powspctrm';
cfg.zlim = [0 max(dummy.powspctrm)];
cfg.xparam='freq';
cfg.comment ='xlim';
cfg.commentpos='middlebottom';
cfg.electrodes='off';
cfg.style = 'straight';
figure;
ft_topoplotTFR(cfg, dummy);
colorbar;
set(gcf, 'Position', get(0,'ScreenSize'));
print('-dtiff', '-r600', fullfile(outdir, 'absleadfield.tiff'));
%%
close(gcf)
%%
S = [];
S.D = D;
S.sources.pos = pos;
S.sources.ori = mom;
S.sources.label = {'Beamformer'};
S.lambda ='0.01%';
S.voi = 'no';
S.outfile = fullfile(outdir, 'source_data.mat');
S.conditions = D.condlist;
S.appendchannels = [D.chanlabels(strmatch('STN', D.chanlabels)), {'stim', 'rec', 'recfixed'}];
Dsource = spm_eeg_ft_beamformer_source(S);
%%
sind = [2:numel(data.trial) 1];

sdata =  Dsource.ftraw(0).trial(sind);

for i = 1:numel(sdata)
    sdata{i} = sdata{i}(1, :);
end

cfg = [];
cfg.relnoise = 0;
cfg.vol = vol;
cfg.grad = grad;
cfg.channel = channel;

cfg.dip.pos = pos;
cfg.dip.mom = mom;


cfg.dip.signal = sdata;

% for i = 1:numel(cfg.dip.signal)
%     cfg.dip.signal{i} = 10*cfg.dip.signal{i};
% end

sdata = ft_dipolesimulation(cfg);

[sel1, sel2] = spm_match_str(data.label, sdata.label);

%
for i = 1:numel(data.trial)
    data.trial{i}(sel1, :) = data.trial{i}(sel1, :)+ sdata.trial{i}(sel2, :);
    data.trial{i}(refind, :) = data.trial{sind(i)}(refind, :); 
end

Dout = spm_eeg_ft2spm(data, 'cohdummy.mat');

Dout.inv = D.inv;
Dout = sensors(Dout, 'MEG', sensors(D, 'MEG'));
Dout = fiducials(Dout, fiducials(D));

Dout.origchantypes = D.origchantypes;

S1 = [];
S1.D = Dout;
S1.task = 'defaulttype';
Dout = spm_eeg_prep(S1);

Dout = badchannels(Dout, [], badchannels(D, D.indchannel(Dout.chanlabels)));

S1 = [];
S1.task = 'project3D';
S1.modality = 'MEG';
S1.updatehistory = 0;
S1.D = Dout;

Dout = spm_eeg_prep(S1);
save(Dout);
%%
data = Dout.ftraw(0);


cfg = [];
cfg.output ='powandcsd';
cfg.channelcmb={refchan, 'MEG'};
cfg.keeptrials = 'no';
cfg.keeptapers='no';
cfg.taper = 'dpss';
cfg.method          = 'mtmfft';
cfg.foilim     = ranges{f};
cfg.tapsmofrq = rangeres(f);

inp = ft_freqanalysis(cfg, data);
%%
cfg = [];
cfg.method = 'coh';
coh = ft_connectivityanalysis(cfg, inp);
%%
dummy=[];
dummy.label   = coh.labelcmb(:, 2);
dummy.powspctrm   = coh.cohspctrm;
dummy.freq    = coh.freq;
dummy.dimord  = 'chan_freq';

[junk, lind] = min(abs(dummy.freq - range(1)));
[junk, hind] = min(abs(dummy.freq - range(2)));
  
cfg=[];
cfg.grad = D.sensors('MEG');
cfg.zparam='powspctrm';
cfg.xparam='freq';
cfg.xlim= dummy.freq([lind hind]);
cfg.zlim = [0 max(mean(dummy.powspctrm(:, lind:hind), 2))];
cfg.comment ='xlim';
cfg.commentpos='middlebottom';
cfg.style = 'straight';
cfg.electrodes = 'off';
figure;
ft_topoplotTFR(cfg, dummy);
colorbar;
set(gcf, 'Position', get(0,'ScreenSize'));
print('-dtiff', '-r600', fullfile(outdir, 'simcohpattern.tiff'));
close(gcf)





