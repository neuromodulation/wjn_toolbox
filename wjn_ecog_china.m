clear all
close all
root = 'E:\Dropbox\Motorneuroscience\motor_ecog\motor area EEG';
cd(root)
files = ffind('tf*.mat');
for a = 1:length(files)
%     D=spm_eeg_convert(files{a});
%     D=wjn_linefilter(D.fullfile);
%     D=wjn_tf_wavelet(D.fullfile,3:40,50);
      D=wjn_sl(files{a});
%       D=wjn_tf_normalization(D.fullfile);
      D=wjn_tf_smooth(D.fullfile,0,250);
      D=wjn_tf_full_bursts(D.fullfile);
      if a==1
          allbursts = D.bursts.bursts{1};
          for b = 2:D.nchannels
              allbursts(end+1:end+numel(D.bursts.bursts{b}))=D.bursts.bursts{b};
          end  
      else
          
          for b =1:D.nchannels
              allbursts(end+1:end+numel(D.bursts.bursts{b}))=D.bursts.bursts{b};
          end  
      end
end

