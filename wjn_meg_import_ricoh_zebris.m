function D=wjn_meg_import_ricoh_zebris(confile,mrk_file,sfp_file)

[fpath,file]=fileparts(confile)

ft_defaults

%% MEG data
% meg_path = 'C:\user\sander\data\trr295_data\';
% % meg_file = 'ber009_StimOFF_rest_run-01.con';  % associated mrk-file is '221024-6.mrk';
% % mrk_file = '221024-6.mrk';
% meg_file = 'ber009_StimON_rest_run-01.con';  % associated mrk-file is '221024-2.mrk';
% mrk_file = '221024-2.mrk';
% dataset = fullfile(meg_path, meg_file);
hdr = ft_read_header(confile);

% cfg = [];
% cfg.dataset = confile;
% cfg.channel = 'AG*';
% cfg.hpfilter = 'yes'; % to remove slow drift
% cfg.hpfreq = 1;
% cfg.hpfiltord = 5;
% data = ft_preprocessing(cfg);


%% Read HPIs in MEG coordinate system from .mrk file
coilset = ft_read_headshape(mrk_file);
coilset = ft_convert_units(coilset, 'mm');

%% HPIs (marker coils) in MEG coordinate system
coilset.pos = coilset.fid.pos(end-4:end,:);
coilset.label = coilset.fid.label(end-4:end,:);
coilset.label

%% Read anatomical landmarks and coils measured by Zebris in HEAD coordinate system
shape_hc = ft_read_sens(sfp_file, 'fileformat','zebris_sfp');

%% HPIs (marker coils) in HEAD coordinate system
sz = size(shape_hc.chanpos);
nas_coil = sz(1)-13;         
lpa_coil = sz(1)-15;
rpa_coil = sz(1)-14;
shape_hc.label(sz(1)-15:sz(1)-13,:)

%% Determine transform MEG to HEAD coordinate system and transform array geoemetry
% coil order: Coil1 = Na, Coil2 = LPA, Coil3 = RPA, Coil4, Coil5
coil2common  = ft_headcoordinates(coilset.pos(1,:),coilset.pos(2,:),coilset.pos(3,:)); % headcoordinates wants na, lpa, rpa    
hs2common = ft_headcoordinates(shape_hc.chanpos(nas_coil,:),shape_hc.chanpos(lpa_coil,:),shape_hc.chanpos(rpa_coil,:)); % na, lpa, rpa (Zebris)
t = inv(hs2common)*coil2common
data.grad = ft_convert_units(data.grad, 'mm');
data_hc.grad = ft_transform_geometry(t,data.grad);
coilset_hc = ft_transform_geometry(t,coilset);

%% Display all
% SQUID array
ft_plot_sens(data_hc.grad,'edgecolor', 'blue');  % ,'coil',true, 'facecolor', 'red');    
hold on
% ZEBRIS fiducials
plot3(shape_hc.fid.pnt(:,1),shape_hc.fid.pnt(:,2),shape_hc.fid.pnt(:,3),'red*','MarkerSize',15)
axis equal
hold on
% ZEBRIS surface points
plot3(shape_hc.chanpos(1:sz(1)-16,1),shape_hc.chanpos(1:sz(1)-16,2),shape_hc.chanpos(1:sz(1)-16,3),'green*','MarkerSize',8)
axis equal
hold on
% Coils measured with SQUID array and transformed
plot3(coilset_hc.pos(1:3,1),coilset_hc.pos(1:3,2),coilset_hc.pos(1:3,3),'yellowd','MarkerSize',15)
axis equal
hold on
% Coils measured with Zebris 
plot3(shape_hc.chanpos(sz(1)-15:sz(1)-13,1),shape_hc.chanpos(sz(1)-15:sz(1)-13,2),shape_hc.chanpos(sz(1)-15:sz(1)-13,3),'magentad','MarkerSize',15)
axis equal
hold on
% 
% cfg = [];
% cfg.method = 'sobi'; % 'fastica'; % 'sobi'; % 'fastica';
% cfg.sobi.p_correlations = 10; % 400;
% cfg.sobi.n_sources = 40;
% cfg.fastica.numOfIC = 30;
% ica_comp = ft_componentanalysis(cfg, data);
% 
% cfg = [];
% cfg.channel =  [1:10]; % show components in blocks of 10
% cfg.layout    = 'vertical'; % specify the layout file that should be used for plotting
% cfg.viewmode = 'vertical';
% cfg.compscale = 'local';
% cfg.blocksize = 5; % show 5 second long blocks
% cfg.ylim = [-5 5]*1e-14; % initial scaling
% ft_databrowser(cfg, ica_comp);