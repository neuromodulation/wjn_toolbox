function cnt = wjn_load_connectome(connectome,cut)

if ~exist('cut','var')
    cut = 'none';
end

[lf,lt,lc]=leadf;
standardvars = ['''ea_fibformat'',''fibers'',''filename'',''fname'',''fourindex'',''idx'',''tt'',''voxmm'''];

if strcmp(cut,'kdbg')
    loadvars = [standardvars ',''kdbg'',''bgcrop'''];
elseif strcmp(cut,'kdt')
    loadvars = [standardvars ',''kdt'''];
else
    loadvars = standardvars;
end

switch connectome
    case 'ppmi'
        fname=fullfile(lc,'dMRI','ppmi.mat');
    case 'group10'
        fname= fullfile(lc,'dMRI','Groupconnectome (Horn 2013) thinned out x 10.mat');
    case 'group500'
        fname=fullfile(lc,'dMRI','Groupconnectome (Horn 2013) thinned out x 500.mat');        
end

eval(['cnt=load(fname,' loadvars ')']);