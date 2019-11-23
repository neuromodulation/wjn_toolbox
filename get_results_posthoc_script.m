global xSPM
spm eeg

lfp = {'LFP_R01','LFP_R12','LFP_R23'};
conditions = {'R','RT'};
freqrange = {'low','high'};
kind = {'native','headloc'};
load C:\Vim_meg\freq.mat
root = 'C:\Vim_meg\LN04';
ID = 'LN04';
n=0;
% results ={};
% save(fullfile(root,'sensor_level_results.mat'),results);
ranges = [];
desc = {};
threshold = [0.01,0.05];
extent = [100 , 0];
for c = 1:length(conditions);
    for l = 1:length(lfp);
        for f = 1:length(freqrange);
            for k = 1:length(kind);
                for t = 1:length(threshold);
                    for e = 1:length(extent);
                        n=n+1;
                        fname = fullfile(root,conditions{c},'sensor_level',kind{k},'cohimages',lfp{l},freqrange{f},'SPM.mat');
                        desc(length(ranges)+1) = {[conditions{c} ' ' lfp{l} ' ' freqrange{f} ' ' kind{k}...
                            ' FWE p <= ' num2str(threshold(t)) ' k = ' num2str(extent(e))]};
                        ranges(length(ranges)+1,:) = [nan nan];
                        x=get_results_freqs(freq{k},fname,ID,threshold(t),'FWE',extent(e));
                        ranges =[ranges;x];
                        end
                end
                

                  
            end
        end
    end
end
xlswrite(fullfile(root,'sensor_results.xls'),{ID ' ' root ' '});
xlswrite(fullfile(root,'sensor_results.xls'),desc',1,'B2')
xlswrite(fullfile(root,'sensor_results.xls'),ranges,1,'C2')
               