function lead_slice(folder)

if ~exist('folder','var')
    folder = uigetdir;
end

slices = {fullfile(folder,'ufbold.nii')};
anatomy = {fullfile(folder,'anat_t1.nii'),fullfile(folder,'anat_t2star.nii')};
atlas = fullfile('F:\UFBOLD\connect');

if ~exist(slices{1},'file')
[anatomy,slices]=lead_slice_import_dicom(folder);
end





root = cd;
%% SEGMENT



if ~exist(['iy_' anatomy{1}],'file')
matlabbatch  = [];
% for a = 1:length(anatomy)
% matlabbatch{1}.spm.spatial.preproc.channel(a).vols = anatomy(a);
% matlabbatch{1}.spm.spatial.preproc.channel(a).biasreg = 0.001;
% matlabbatch{1}.spm.spatial.preproc.channel(a).biasfwhm = 60;
% matlabbatch{1}.spm.spatial.preproc.channel(a).write = [0 0];
% end
matlabbatch{1}.spm.spatial.preproc.channel(1).vols = anatomy(1);
matlabbatch{1}.spm.spatial.preproc.channel(1).biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel(1).biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel(1).write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {fullfile(spm('dir'),'tpm\TPM.nii,1')};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {fullfile(spm('dir'),'tpm\TPM.nii,2')};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {fullfile(spm('dir'),'tpm\TPM.nii,3')};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {fullfile(spm('dir'),'tpm\TPM.nii,4')};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {fullfile(spm('dir'),'tpm\TPM.nii,5')};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {fullfile(spm('dir'),'tpm\TPM.nii,6')};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [1 0];
spm_jobman('run',matlabbatch)
end
[dir,file]=fileparts(anatomy{1});
ifile = ['iy_' file '.nii'];
cfiles = {['c2' file '.nii'],['c3' file '.nii'],['c1' file '.nii']};



files = wjn_subdir(fullfile(atlas,'*.nii'));

for a = 1:length(files)
matlabbatch = [];
matlabbatch{1}.spm.spatial.normalise.write.subj.def = {ifile};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {files{a}};
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
    78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
spm_jobman('run',matlabbatch);
[dir,file]=fileparts(files{a});
side = stringsplit(dir,filesep);
atlas_names{a} = fullfile(root,[file '_' side{end} '.nii']);
movefile(fullfile(dir,['w' file '.nii']),atlas_names{a});
pause(10)
end

D4 = [cfiles atlas_names];
for a = 1:length(slices)
    fdir=slices{a}(1:end-4);
    mkdir(fdir);
    fnames=[wjn_nii_cut_slice(slices{a},anatomy),wjn_nii_cut_atlas(slices{a},D4)];
    
    for b = 1:length(fnames)
        try
            movefile(fnames{b},fdir)
        end
    end

        nii =ea_load_nii(fullfile(fdir,fnames{end-1})); 
        load(fullfile(fdir,fnames{end}));
        slice = ea_load_nii(slices{a});
        slice.img(:,:,:,1)=0;
        TR = slice.private.timing.tspace;
        fs = round(1/TR);
        slice.img(:,:,:,1:5*fs)=[];
        nii.img(:,:,1,3:end) = nii.img(:,:,1,3:end).*(nii.img(:,:,1,3)<.1);
        nsamples = size(slice.img,4);
        nvoxels = slice.dim(1)*slice.dim(2);
        time= linspace(0,nsamples/fs,nsamples);
        voxel_volume=(nii.voxsize(1)*nii.voxsize(2)*nii.voxsize(3));
        n=0;
        data=[];channel=[];signal = [];catlas = [];volume = [];
      
        for b = 1:length(structures)
            
            vol=nansum(nansum(squeeze(nii.img(:,:,1,b)))).*voxel_volume;
            signal=[];
            
             
        
            if vol>=voxel_volume || b<4
                  
                n=n+1;
                 signal = shiftdim(squeeze(slice.img.*squeeze(nii.img(:,:,1,b)>.1)),2);
                catlas(:,:,1,n) = squeeze(nii.img(:,:,1,b)>.01).*n;
                  signal(signal==0)=nan;
               
                if b>2
                    mdl = fitlm(data([1 2],:)',nanmean(signal(:,:),2));
                    data(n,:) = mdl.Residuals.Raw;
                    
                else
                    data(n,:) = nanmean(signal(:,:),2);
                end 
                
                volume(n) =  vol;
                chan = stringsplit(structures{b},'-');
                if b ==1
                    channel{n} = 'wm';
                elseif b==2
                    channel{n} = 'csf';
                elseif b == 3 
                    channel{n} = 'gm';
                else
                    channel{n} = chan{2}(1:end-4);
                end
            end
        end
        
       figure
       wjn_plot_raw_signals(time,data,channel)
       D=wjn_import_rawdata([slices{a}(1:end-4) '.mat'],data,channel,fs);
       D.volume = volume;  
       D.voxel_volume = voxel_volume;
       save(D);

       
       anat = ea_load_nii(fullfile(fdir,fnames{length(anatomy)+1}));
       for b = 1:size(anat.img,4)
            catlas(catlas==0)=nan;
           figure
           subplot(1,2,1)
           i=imagesc(squeeze(anat.img(:,:,1,b))'),axis xy
           colormap('gray')
            hold on
           subplot(1,2,2)
           for c=1:size(catlas,4)
          	i=imagesc(squeeze(catlas(:,:,1,c))');axis xy
            i.AlphaData=i.CData./max(unique(catlas)).*.5;
            hold on
           end
          colormap('parula')
          myprint(fnames{b}(1:end-4))
       end
       D.atlas = catlas;
       D.anatomy = anat;
       D=chantype(D,':','LFP');
    save(D)

       
end

for a = 1:length(atlas_names)
    delete(atlas_names{a})
end



    