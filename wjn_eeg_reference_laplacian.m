function D = wjn_eeg_reference_laplacian(filename)
%% convert analyzer file to SPM format
try
    D=spm_eeg_load(filename);
catch
D=wjn_eeg_convert(filename);
end

%% convert from SPM to fieldTrip
data = D.ftraw(0);
%% rereference to laplacian
cfg = [];
cfg.method = 'spline';
ndata = ft_scalpcurrentdensity(cfg,data);
%% remove all channels except Cz,Fz,C3,C4
% cfg = [];
% cfg.channel = {'Cz','Fz','C3','C4','P3','P4'};
% nndata= ft_preprocessing(cfg,data);
%% convert from FieldTrip to SPM
nD=spm_eeg_ft2spm(ndata,['lr' D.fname]);
save(nD)