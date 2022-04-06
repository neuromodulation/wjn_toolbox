function fnames = wjn_nii_parcellate(input_images,parcellation_image)

%% Load parcellation image
nii_p = ea_load_nii(parcellation_image);
T = readtable([parcellation_image(1:end-4) '.txt']);
T(:,3) = array2table(nan(length(T.Var1),1));
T.Properties.VariableNames = {'Index','Name','Value'};

%% Run loop through input images
for a = 1:length(input_images)
    T(:,3) = array2table(nan(length(T.Index),1));
    % Reslice input image to parcellation and store as temp
    spm_imcalc({parcellation_image,input_images{a}},'temp.nii','i2');
    
    % Read the resliced image
    nii = ea_load_nii('temp.nii');
    
    % Run through the indices and average values from the input image

    for b = 1:length(T.Index)
        T.Value(b) = nanmean(nii.img(nii_p.img==T.Index(b)));
        disp([T.Name{b} ' - ' num2str(T.Value(b))])
    end
    fnames{a} = [input_images{a}(1:end-4) '_' parcellation_image(1:end-4) '.csv'];
    writetable(T,[input_images{a}(1:end-4) '_' parcellation_image(1:end-4) '.csv']);
end