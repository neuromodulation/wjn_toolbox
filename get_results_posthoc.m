clear
global xSPM
spm eeg
ID = spm_input('ID',[],'s')
spmfiles = cellstr(spm_select(Inf,'mat','Select Folders',[],[],'SPM.mat'));
load('C:\Vim_meg\freq.mat')

for a = 1:length(spmfiles);
    get_results_freqs(freq,spmfiles{a},ID,0.01,'FWE',100);
    get_results_freqs(freq,spmfiles{a},ID,0.01,'FWE',0);
    get_results_freqs(freq,spmfiles{a},ID,0.05,'FWE',100);
    get_results_freqs(freq,spmfiles{a},ID,0.05,'FWE',0);
end
    