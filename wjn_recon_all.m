function D=wjn_recon_all(filename)
tic
disp('START RECON ALL.')
disp('LOAD DATA')
D=spm_eeg_load(filename);del={};
%% CHECK FOR DATATYPE AND CHANNEL TYPE
if ~strcmp(D.type,'continuous');warning('Only continuous data. Trying to unepoch.');D=wjn_unepoch(D.fullfile);del=[del D.fullfile];end 
[D,em]=wjn_remove_empty_channels(D.fullfile);if ~isempty(em),del=[del D.fullfile];end
if length(unique(D.chantype)) == 1 && strcmp(unique(D.chantype),'Other'),D=wjn_fix_chantype(D.fullfile);end
%% GET FNAME AND SAVEPATH
disp('GENERATE FNAME AND SAVEPATH.')
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname]);mkdir(fpath)
disp(fname);disp(fpath);
%% PRINT RAW DATA
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'RAW');mkdir(fpath)
wjn_recon_print_raw(D.fullfile,fpath);
%% WAVEFORM CHARACTERIZATION
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'SPW');mkdir(fpath)
[D,SPW,T] = wjn_recon_spw(D);save(D)
wjn_recon_print_spw_raw(D,D.SPW,fpath)
wjn_recon_print_spw(D,D.SPW,fpath)
writetable(T,fullfile(fpath,['SPW_table_' fname '.csv']))
%% COMPUTE POWER 
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'POW');mkdir(fpath)
normfreq=[5 45; 55 95];
[D,D.COH]=wjn_recon_power(D.fullfile,normfreq);save(D)
wjn_recon_print_power(D.COH,fpath);
%% AVERAGE BAND POWER
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'BPOW');mkdir(fpath)
freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];measures = {'mpow','rpow','logfit'};
[D.COH]=wjn_recon_bandaverage(D.COH,measures,freqbands,bandfreqs);save(D)
wjn_recon_print_bandaverage(D.COH,fpath);
%% PEAK IDENTIFICATION
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'PPOW');mkdir(fpath)
D.COH=wjn_recon_peakpower(D.COH,measures,freqbands,bandfreqs);save(D)
wjn_recon_print_bandpeaks(D.COH,fpath);
%% CONNECTIVITY COMPUTATION
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'COH');mkdir(fpath)
[D,D.COH]=wjn_recon_connectivity(D);
wjn_recon_print_connectivity(D.COH,fpath)
%% AVERAGE BAND CONNECTIVITY
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname],'BCOH');mkdir(fpath)
freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];
measures = {'coh','icoh','plv','wpli','ccgranger'};
[D.COH]=wjn_recon_bandaverage(D.COH,measures,freqbands,bandfreqs);save(D)
wjn_recon_print_bandaverage(D.COH,fpath);
D.SPW=SPW;save(D);for a = 1:length(del),d=spm_eeg_load(del{a});d.delete();clear d,end
