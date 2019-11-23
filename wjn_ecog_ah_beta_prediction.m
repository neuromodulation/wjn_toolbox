clear all, close all
root = fullfile(mdf,'ecog_beta_prediction');
cd(root)
% 
% 
% files = ffind('tf*baselines*.mat');
% 
% for a = 2:length(files)
%     D=wjn_sl(files{a});
%     D=wjn_filter(D.fullfile,[58 62],'stop');
%     D=wjn_filter(D.fullfile,1,'high');
%     D=wjn_tf_wavelet(D.fullfile,[1:200],35);
%    try
%     D=wjn_tf_wavelet_coherence(D.fullfile,{'STN1','Strip1'},[1:40],35);
%    catch
%    end
% end

%% COHERENCE


files = ffind('dffbaselines*.mat');   

for a =1 :length(files)
    D=wjn_sl(files{a});
    chancomb = coherence_finder('STN','Strip',D.chanlabels);
    
    D=wjn_tf_coherence(D.fullfile,chancomb)
   
    
end
    