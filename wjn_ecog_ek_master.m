close all
clear all 
files = ffind('s_*raw.mat')

% files = [ffind('s_*2_2_raw.mat');ffind('s_*2_1_raw.mat')];

% i = ci({'AA','AB','FB','RS05','ND','KK'},files);

for a = 1:length(files)
if ~exist(['tf_dcont_' files{a}],'file')
    try
        wjn_ecog_ek_pb_burst_preprocessing(files{a},1)
    catch
    end
end
close all
end