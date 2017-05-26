function [leaddir,templates,connectomes,atlases] = leadf
% [leaddir,templates,connectomes,atlases] = leadf

[~,~,~,~,~,leaddir]=getsystem;
templates = fullfile(getsystem,'leaddbs','templates');
connectomes = fullfile(getsystem,'leaddbs','connectomes');
atlases = fullfile(templates,'space\MNI_ICBM_2009b_NLIN_ASYM\atlases');
end