function [leaddir,templates,connectomes,atlases,parcellations] = leadf
% [leaddir,templates,connectomes,atlases] = leadf

[~,~,~,~,~,leaddir]=getsystem;
templates = fullfile(getsystem,'imaging','templates');
parcellations = fullfile(getsystem,'imaging','parcellations');
connectomes = fullfile(getsystem,'lead','connectomes');
atlases = fullfile(templates,'space\MNI_ICBM_2009b_NLIN_ASYM\atlases');
end