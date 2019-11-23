function [matrix,structure,raw]=wjn_rs_atlas_matrix(input,atlas)

if ~exist('atlas','var')
    atlas = 'Automated Anatomical Labeling 2 (Tzourio-Mazoyer 2002)';
end


if isstruct(input)
    try
        nin = input.nii;
        if isfield(input,'data')
            d = input.data;
        else
            d = nin.img(:);
        end
        catch
        nin = input;
        d = nin.img(:);
    end
else
    nin=ea_load_nii(input);
    d = nin.img(:);
end

try
    nia = ea_load_nii(atlas);
    [atlasfolder,atlas]=fileparts(atlas);
    nia = ea_load_nii(fullfile(atlasfolder,[atlas '.nii']));
catch
    atlasfolder = fullfile(ea_getearoot,'templates\space\MNI_ICBM_2009b_NLIN_ASYM\labeling\');
    [~,atlas]=fileparts(atlas);
    nia = ea_load_nii(fullfile(atlasfolder,[atlas '.nii']));
end

if ~isequal(nin.dim,nia.dim)
    try
        nia=ea_load_nii(fullfile(atlasfolder,['r' atlas '.nii']));
    catch
        spm_reslice({nin.fname,nia.fname})
            nia = ea_load_nii(fullfile(atlasfolder,['r' atlas '.nii']));
    end

end


structures = unique(round(nia.img(round(nia.img)>=1)));
% keyboard
if length(structures)==1
 for nn = 1:size(d,2)
            matrix(nn,1)= nanmean(d(round(nia.img)==1,nn));
            raw{nn} = d(round(nia.img)==1,nn);
            [~,structure,~]=fileparts(atlas);
end
else


text =  importdata(fullfile(atlasfolder,[atlas '.txt']));

for a =1:length(text)
    name=stringsplit(text{a},' ');
    n(a)=str2num(name{1});
    structure{a} = name{2};
end
for nn = 1:size(d,2)
for a = 1:length(structure)
    matrix(nn,a)= nanmean(d(nia.img==n(a),nn));
    raw{nn,a}=d(round(nia.img)==n(a),nn)';
end
end

end

