function f=wjn_searchfibers(fname,mni,connectome,mm,cont)
% f=wjn_searchfibers(fname,mni,connectome,mm,cont)
% fname = name of output file
% mni = mni coordinates or binary nifti filename with roi
% mm = search radius for fibers (default = 1 mm)
% cont = if 1 (default) all traversing fibers are found, if 0 only fibers ending in the roi
% will be found.




[lf,lt]=leadf;
addpath(genpath(lf));
if ~exist('cont','var')
    cont = 1;
end

if ~exist('connectome','var')
    connectome = 'HCP';
end

if ischar(connectome)
    connectome = load(fullfile(ea_getearoot,'connectomes','dMRI',connectome,'data.mat'));
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
    nregions = 1;
elseif iscell(mni)
    nregions = length(mni);
end

if ~exist('mm','var')
    mm = 1;
end



for a = 1:nregions
    
    if nregions>1
        fname = [fname '_' num2str(a)];
        cmni = mni{a};
    end
    if isnan(cmni(1,1))
        continue
    end
    
    if ~cont
        ix = connectome.fibers(:,4);
        istart = find(mydiff(ix));
        istop = istart+connectome.idx-1;
        iss = [istart;istop];
    else
        iss = 1:size(connectome.fibers,1);
    end
    
    
    disp('...searching fibers...')
    
    % if isfield(connectome,'kdbg') && cont
    %     kdt = 0;
    %     kdbg = 1;
    %     i= rangesearch(connectome.kdbg,mni,mm,'Distance','Chebychev');
    %         ix = connectome.bgcrop(:,4);
    % elseif isfield(connectome,'kdt') && cont
    %     kdbg = 0;
    %     kdt=1;
    %     i = rangesearch(connectome.kdt,mni,mm,'Distance','Chebychev');
    %
    % else
    kdt = 0;
    kdbg = 0;
    i= rangesearch(connectome.fibers(iss,1:3),cmni,mm,'Distance','Chebychev');
    % end
    
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
    
    % if kdbg
    %     connectome = rmfield(connectome,'bgcrop');
    %     connectome = rmfield(connectome,'kdbg');
    % elseif kdt
    %     connectome = rmfield(connectome,'kdt');
    %     ix = connectome.fibers(:,4);
    % else
    ix = connectome.fibers(:,4);
    % end
    
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
%     disp('...writing connectome trk file...')
%     wjn_ftr2trk(fname);
end
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

