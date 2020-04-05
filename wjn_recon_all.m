function D=wjn_recon_all(filename)
tic
disp('START RECON ALL.')
if ~exist('printit','var'); printit=1;end
disp('LOAD DATA')
D=spm_eeg_load(filename);del={};
%% CHECK FOR DATATYPE AND CHANNEL TYPE
if ~strcmp(D.type,'continuous');warning('Only continuous data. Trying to unepoch.');D=wjn_unepoch(D.fullfile);del=[del D.fullfile];end 
[D,em]=wjn_remove_empty_channels(D.fullfile);if ~isempty(em),del=[del D.fullfile];end
if length(unique(D.chantype)) == 1 && strcmp(unique(D.chantype),'Other'),D=wjn_fix_chantype(D.fullfile);end
%% GET FNAME AND SAVEPATH
disp('GENERATE FNAME AND SAVEPATH.')
fname=D.fname;fname=fname(1:end-4);fpath = fullfile(D.path,['recon_all_' fname]);mkdir(fpath)
disp(fname);
disp(fpath);
%% PRINT RAW DATA
if printit;wjn_recon_print_raw(D.fullfile,fpath);end
%% WAVEFORM CHARACTERIZATION
prominence=1.96;
[D,SPW,T] = wjn_recon_spw(D,prominence);
wjn_recon_print_spw_raw(D,SPW,fpath)
wjn_recon_print_spw(D,SPW,fpath)
writetable(T,fullfile(fpath,['SPW_table_' fname '.csv']))
%% COMPUTE POWER 
normfreq=[5 45; 55 95];
[D,COH]=wjn_recon_power(D.fullfile,normfreq);
wjn_recon_print_power(COH,fpath);
%% AVERAGE BAND POWER
freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};
bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];
measures = {'mpow','rpow','logfit'};
[COH]=wjn_recon_bandaverage(COH,measures,freqbands,bandfreqs);
wjn_recon_print_bandaverage(COH,fpath);
%% PEAK IDENTIFICATION
COH=wjn_recon_peakpower(COH,measures,freqbands,bandfreqs);
wjn_recon_print_bandpeaks(COH,fpath);
%% CONNECTIVITY COMPUTATION
[D,COH]=wjn_recon_connectivity(D);
wjn_recon_print_connectivity(COH,fpath)
%% AVERAGE BAND CONNECTIVITY
freqbands  = {'all','lowfreq','theta','alpha','beta','low_beta','high_beta'};
bandfreqs = [3 35;4 12;4 8;8 12;13 35;13 20;20 35];
measures = {'coh','icoh','plv','wpli','ccgranger'};
[COH]=wjn_recon_bandaverage(COH,measures,freqbands,bandfreqs);
wjn_recon_print_bandaverage(COH,fpath);
D.COH=COH;
D.SPW=SPW;
save(D)
for a = 1:length(del)
    d=spm_eeg_load(del{a});
    d.delete();
    clear d
end
