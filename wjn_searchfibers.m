function f=wjn_searchfibers(fname,mni,connectome,mm,cont)
[lf,lt]=leadf;
addpath(genpath(lf));
if ~exist('cont','var')
    cont = 1;
end

if ~exist('connectome','var')
    connectome = 'group500';
end

if ischar(connectome)
    switch connectome
        case 'ppmi'
            connectome=load(fullfile(ea_getearoot,'connectomes','dMRI','ppmi.mat'));
        case 'group10'
            connectome=load(fullfile(ea_getearoot,'connectomes','dMRI','Groupconnectome (Horn 2013) thinned out x 10.mat'));
        case 'group500'
            connectome=load(fullfile(ea_getearoot,'connectomes','dMRI','Groupconnectome (Horn 2013) thinned out x 500.mat'));        
    end
end

if ischar(mni)
    mname = mni;
    mni=[];
    nii=wjn_read_nii(mname);
    i=find(nii.img>0);
    for a = 1:length(i)
        [x,y,z] = ind2sub(nii.dim,i(a));
        nmni = [x y z 1]*nii.mat';
        mni(a,:) = nmni(1:3);
    end
end    

if ~exist('mm','var')
    mm = 2;
end
mm=mm/2;


if ~cont
    ix = connectome.fibers(:,4);
    istart = find(mydiff(ix));
    istop = istart+connectome.idx-1;
    iss = [istart;istop];
else
    iss = 1:size(connectome.fibers,1);
end


disp('...searching fibers...')

if isfield(connectome,'kdbg') && cont
    kdt = 0;
    kdbg = 1;
    i= rangesearch(connectome.kdbg,mni,mm,'Distance','Chebychev');
        ix = connectome.bgcrop(:,4);
elseif isfield(connectome,'kdt') && cont
    kdbg = 0;
    kdt=1;
    i = rangesearch(connectome.kdt,mni,mm,'Distance','Chebychev');

else
    kdt = 0;
    kdbg = 0;
    i= rangesearch(connectome.fibers(iss,1:3),mni,mm,'Distance','Chebychev');
end

ni=[];
if ~isempty(i)
    if ~iscell(i)
        ni = [ni; i];
    else
        for b = 1:length(i)
            ni = [ni; i{b}'];
        end
    end
end

if kdbg
    connectome = rmfield(connectome,'bgcrop');
    connectome = rmfield(connectome,'kdbg');
elseif kdt
    connectome = rmfield(connectome,'kdt');
    ix = connectome.fibers(:,4);
else
    ix = connectome.fibers(:,4);
end

nn= unique(ix(unique(ni)));
disp(['...' num2str(length(nn)) ' fibers found...'])
disp('...sorting fibers...')
% keyboard
ix = connectome.fibers(:,4);


d.ids = nn;
d.fibers = connectome.fibers(ismember(ix,nn),:);
d.fourindex = connectome.fourindex;
d.ea_fibformat = connectome.ea_fibformat;
d.idx = connectome.idx(nn);
try
    d.voxmm = connectome.voxmm;
catch
end
disp('...writing connectome mat file...')
save([fname '.mat'],'-struct','d');
disp('...writing connectome trk file...')
wjn_ftr2trk(fname);

% 
% 
% figure
% plot3(mni(:,1),mni(:,2),mni(:,3),'k.');
% hold on
% if size(mni,1) == 2
%     [X,Y,Z]=sphere(20);
%     surf(X*mm+mni(1,1),Y*mm+mni(1,2),Z*mm+mni(1,3))
%     surf(X*mm+mni(2,1),Y*mm+mni(2,2),Z*mm+mni(2,3))
% end
% for a = 1:length(fc)
%     plot3(fc{a}(:,1),fc{a}(:,2),fc{a}(:,3),'b-');
% end

