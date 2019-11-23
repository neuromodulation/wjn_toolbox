

% Number of electrode contacts in the strip (for optimizing threshold)
NumElec = 54;

% read in nifi image of normalized electode contact spheres
[pathname,fname,ext]=fileparts('/Volumes/Nexus/Electrophysiology_Data/DBS_Intraop_Recordings/FreeSurfer/DBS3001_preop/mri/glstrip_spheres_anat_t1.nii');
Vol=ea_load_nii(fullfile(pathname,[fname ext]));
nii=Vol.img;
voxmm = Vol.voxsize;

%% examine the voxel value distribution
 minval = min(nii(:));
 maxval = max(nii(:));
% [histnii, v0] = hist(nii(:), linspace(minval,maxval,1000));
% figure; bar(v0,histnii)
% figure; imagesc(squeeze(nii(55,:,:)))

%% determine the optimal threshold for segmenting the known number of contacts
% use this voxel value step size for adjusting threshold
stepsize = 0.05;
k=0; n=[];
threshvals = 0:stepsize:maxval;
for thresh = threshvals
    k=k+1;
    CC = bwconncomp(nii>thresh);
    n(k) = CC.NumObjects;
    %fprintf('thresh = %f, NumObjects = %d\n', thresh, n(k))
end
% use the higherst threshold that results in the desired contact count
thresh = threshvals(find(n==NumElec,1,'last'));
CC = bwconncomp(nii>thresh);

%% calculate the centroid of each set of voxels representing a contact
% note - dimentions must be shuffeld to obtain correct orientation
ElecMNI = arrayfun(@(x) x.Centroid([2,1,3]), regionprops(CC,'Centroid'), 'uniformoutput', 0);

%% visualize the results as voxels
% figure; hold on;
% for i=1:CC.NumObjects
%     [I,J,K] = ind2sub(Vol.dim,CC.PixelIdxList{i});
%     plot3(I,J,K,'.', 'markersize', 20)
%     plot3( ElecMNI{i}(1), ElecMNI{i}(2), ElecMNI{i}(3), '*')
% end
% axis equal

%covert to matrix
ElecMNI = reshape(cell2mat(ElecMNI'),3,length(ElecMNI))';

% transform to MNI space
MNI = ea_load_nii('/Users/brainmodulationlab/Documents/MATLAB/lead/templates/space/MNI_ICBM_2009b_NLIN_ASYM/t1.nii');
ElecMNI = MNI.mat*[ElecMNI(:,1) ElecMNI(:,2) ElecMNI(:,3) ones(size(ElecMNI,1),1)]';
ElecMNI = ElecMNI';
ElecMNI(:,4) = [];

%% plot the electrodes on the ICBM surface 
% using just the left hemisphere here...
load('/Users/brainmodulationlab/Documents/MATLAB/lead/templates/space/MNI_ICBM_2009b_NLIN_ASYM/cortex/CortexHiRes.mat')

figure; hold on;
Hp = patch('vertices',Vertices_lh,'faces',Faces_lh,...
    'facecolor',[.85 .50 .50],'edgecolor','none',...
    'facelighting', 'gouraud', 'specularstrength', .50);
camlight('headlight','infinite');
axis on; axis equal
plot3(ElecMNI(:,1), ElecMNI(:,2), ElecMNI(:,3), 'g.', 'markersize', 25)
