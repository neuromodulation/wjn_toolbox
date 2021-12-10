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
[fpath,fname] = wjn_recon_fpath(D.fullfile);
disp(fname);disp(fpath);
%% PRINT RAW DATA
try
    wjn_recon_print_raw(D.fullfile);
catch
    disp('wjn_recon_print_raw caused an error.')
end
%% WAVEFORM CHARACTERIZATION
try
    [D,SPW] = wjn_recon_spw(D,[7 35]);
    wjn_recon_print_spw_raw(D)
    wjn_recon_print_spw(D)
catch
    disp('wjn_recon_spw caused an error.')
end
%% BURST CHARACTERIZATION
try
    D=wjn_recon_bursts(D);
    wjn_recon_print_bursts(D);
catch
    disp('wjn_recon_bursts caused an error.')
end
%% COMPUTE POWER
try
    normfreq=[5 45; 55 95];
    [D,D.COH]=wjn_recon_power(D.fullfile,normfreq);
    wjn_recon_print_power(D);
catch
    disp('wjn_recon_power caused an error.')
end
%% AVERAGE BAND POWER
try
    freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];measures = {'mpow','rpow','logfit'};
    [D.COH]=wjn_recon_bandaverage(D.COH,measures,freqbands,bandfreqs);
    wjn_recon_print_bandaverage(D);
catch
    disp('wjn_recon_bandaverage caused an error.')
end
%% PEAK IDENTIFICATION
try
    freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];measures = {'mpow','rpow','logfit'};
    D.COH=wjn_recon_peakpower(D.COH,measures,freqbands,bandfreqs);save(D)
    wjn_recon_print_bandpeaks(D);
catch
    disp('wjn_recon_peakpower caused an error.')
end
%% CONNECTIVITY COMPUTATION
try
    [D,D.COH]=wjn_recon_connectivity(D);
    try
        wjn_recon_print_connectivity(D)
    catch
    end
catch
    disp('wjn_recon_connectivity caused an error.')
end
%% AVERAGE BAND CONNECTIVITY
try
    freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];
    measures = {'coh','icoh','plv','wpli','ccgranger'};
    [D.COH]=wjn_recon_bandaverage(D.COH,measures,freqbands,bandfreqs);save(D)
    wjn_recon_print_bandaverage(D.COH,fpath);
catch
    disp('wjn_recon_bandaverage for connectivity caused an error.')
end
%% CLEAN UP
for a = 1:length(del),d=spm_eeg_load(del{a});d.delete();clear d,end

