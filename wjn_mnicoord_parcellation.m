function output_table = wjn_mnicoord_parcellation(filename,mni_coords,data_table,parcellation_image)
% output = wjn_mnicoord_parcellation(mni_coords,values,parcellation_image)
% requires lead dbs and spm12 in path
% keyboard
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
        if min(d)<10 % Threshold of maximal distance (default 5 mm)
            pa(a,b)=min(d);
        else
            pa(a,b)=nan;
        end
    end
    disp(T.Name{a});
end

% close all
% figure
% wjn_plot_surface('BrainMesh_ICBM152Left_smoothed.gii')
% hold on
% % plot3(mni_p(:,1),mni_p(:,2),mni_p(:,3),'b*')
% % plot3(mni_coords(:,1),mni_coords(:,2),mni_coords(:,3),'xr')
% plot3(mni_coords(~isnan(pa(1,:)),1),mni_coords(~isnan(pa(1,:)),2),mni_coords(~isnan(pa(1,:)),3),'og')
% plot3(mni_coords(parcel_index==1,1),mni_coords(parcel_index==1,2),mni_coords(parcel_index==1,3),'om')
% 
% alpha 0.1


%% Define parcel affiliation from distances
parcel_index=[];
for a = 1:size(pa,2)
    i = find(~isnan(pa(:,a)));
    if ~isempty(i)
        [~,ii]=min(pa(i,a),[],1,"omitnan");
        parcel_index(a) = i(ii);
    else
        parcel_index(a) = nan;
    end
end

unique_indices = unique(parcel_index);
Tavg = T;
Tsum = T;

for a = 1:length(unique_indices)
    if sum(parcel_index==unique_indices(a))>0
          i=find(parcel_index==unique_indices(a));
       Tavg(unique_indices(a),3:end) = array2table(nanmean(table2array(data_table(i,:)),1));
        Tsum(unique_indices(a),3:end) = array2table(nansum(table2array(data_table(i,:)),1));
    end
end
% keyboard
writetable(Tavg,[filename '_average_' parcellation_image(1:end-4) '.csv']);
writetable(Tsum,[filename '_sum_' parcellation_image(1:end-4) '.csv']);
disp('Table written, now write niftis...')

%% Write nifti files for all parcellated values.

for a = 3:size(T,2)

        nii_out = nii_p;
        nii_out.img(:) = 0;

    for b = 1:size(Tsum,1)
        nii_out.img(find(nii_p.img(:)==Tavg.Index(b)))=table2array(Tavg(b,a));
    end
    nii_out.fname = [Tavg.Properties.VariableNames{a} '_average_' filename '_' parcellation_image(1:end-4) '.nii'];

    disp(['Write average ' nii_out.fname])
    ea_write_nii(nii_out);

        nii_out = nii_p;
        nii_out.img(:) = 0;

    for b = 1:size(Tsum,1)
        nii_out.img(find(nii_p.img(:)==Tsum.Index(b)))=table2array(Tsum(b,a));
    end
    nii_out.fname = [Tsum.Properties.VariableNames{a} '_sum_' filename '_' parcellation_image(1:end-4) '.nii'];

    disp(['Write sum ' nii_out.fname])
    ea_write_nii(nii_out);

end
disp('Parcellation and nifti creation done.')