function output_table = wjn_mnicoord_parcellation(filename,mni_coords,data_table,parcellation_image)
% output = wjn_mnicoord_parcellation(mni_coords,values,parcellation_image)
% requires lead dbs and spm12 in path

%% Load parcellation image
nii_p = ea_load_nii(parcellation_image);
T = readtable([parcellation_image(1:end-4) '.txt']);
T(:,3:length(data_table.Properties.VariableNames)+2) = array2table(nan(size(T,1),length(data_table.Properties.VariableNames)));  
T.Properties.VariableNames = [{'Index','Name'} data_table.Properties.VariableNames];

%% Find distances for MNI coordinate
pa = [];
for a = 1:length(T.Index)
    i=find(nii_p.img(:) == T.Index(a));
    [x,y,z]=ind2sub(nii_p.dim,i);
    mni_p = wjn_cor2mni([x y z],nii_p.mat);
    for b =1:size(mni_coords,1)
        d=pdist2(mni_coords(b,:),mni_p);
        if min(d)<1 % Threshold of maximal distance (default 5 mm)
            pa(a,b)=min(d);
        else
            pa(a,b)=nan;
        end
    end
    disp(T.Name{a});
end
            
%% Define parcel affiliation from distances

if strcmp(T.Name{1},'Unknown')
    [~,parcel_index]=min(pa(2:end,:),[],1);parcel_index=parcel_index+1;
else
    [~,parcel_index]=min(pa(1:end,:),[],1);
end

unique_indices = unique(parcel_index);

for a = 1:length(unique_indices)
    T(unique_indices(a),3:end) = array2table(nanmean(table2array(data_table(parcel_index==unique_indices(a),:)),1));
end

writetable(T,[filename '_' parcellation_image(1:end-4) '.csv']);
disp('Table written, now write niftis...')

%% Write nifti files for all parcellated values.

for a = 3:size(T,2)

        nii_out = nii_p;
        nii_out.img(:) = 0;

    for b = 1:size(T,1)
        nii_out.img(find(nii_p.img(:)==T.Index(b)))=table2array(T(b,a));
    end
    nii_out.fname = [T.Properties.VariableNames{a} '_' filename '_' parcellation_image(1:end-4) '.nii'];
%     nii_out.img(isnan(nii_out.img(:)))=0;
    disp(['Write ' nii_out.fname])
    ea_write_nii(nii_out);
end
disp('Parcellation and nifti creation done.')