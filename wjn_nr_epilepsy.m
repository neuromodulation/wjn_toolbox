clear all
lead16

root = 'Z:\LFP\neumann\convert2nii\nii_output\FCD';
dirs = wjn_dir;
methods = {'spm','spm','cat'};
fnames = {'mprage.nii','mp2rage2.nii','mprage.nii'};


for f = 1:length(dirs)
    if ~strcmp(dirs{f}(1),'a')
    for v = 1:3
        keep root dirs f v methods fnames
        folder = fullfile(root,dirs{f});
        fname = fnames{v};
        method = methods{v};
        cd(folder)
                
        % fname='mprage.nii';
        % method = 'spm';
        tpm = fullfile(spm('dir'),'\tpm\TPM.nii');
        tic
        if strcmp(method,'cat')
            
            dtpm = fullfile(spm('dir'),'toolbox\cat12\templates_1.50mm\Template_1_IXI555_MNI152.nii');
            stpm = fullfile(spm('dir'),'toolbox\cat12\templates_1.50mm\Template_0_IXI555_MNI152_GS.nii');
            
            matlabbatch{1}.spm.tools.cat.estwrite.data = {fullfile(folder,fname)};
            matlabbatch{1}.spm.tools.cat.estwrite.nproc = 2;
            matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {tpm};
            matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
            matlabbatch{1}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 0.5;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.cleanupstr = 0.5;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.darteltpm =dtpm;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shootingtpm =stpm;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.regstr = 0;
            matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.ROI = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native =1 ;
            matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.jacobian.warped = 1;
            matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [1 1];
            
            
            spm_jobman('run',matlabbatch)
            clear matlabbatch
            
            
            mgm = ea_load_nii(fullfile(folder,'mri',['mwp1' fname]));
            mwm = ea_load_nii(fullfile(folder,'mri',['mwp2' fname]));
            sk=10;
            
            spm_smooth(mgm.fname,fullfile(folder,'mri',['smwp1' fname]),[sk sk sk]);
            spm_smooth(mwm.fname,fullfile(folder,'mri',['smwp2' fname]),[sk sk sk]);
            
            sgm = fullfile(folder,'mri',['smwp1' fname]);
            swm = fullfile(folder,'mri',['smwp2' fname]);
            sgm=ea_load_nii(sgm);
            swm=ea_load_nii(swm);
            
        elseif strcmp(method,'spm')
            
            matlabbatch{1}.spm.spatial.preproc.channel.vols ={fullfile(folder,fname)};
            matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
            matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
            matlabbatch{1}.spm.spatial.preproc.channel.write = [1 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[tpm ',1']};
            matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
            matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[tpm ',2']};
            matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
            matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm ={[tpm ',3']};
            matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
            matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 1];
            matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[tpm ',4']};
            matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
            matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[tpm ',5']};
            matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
            matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm ={[tpm ',6']};
            matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
            matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
            matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
            matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
            matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
            matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
            matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
            matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
            matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
            matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
            spm_jobman('run',matlabbatch)
            clear matlabbatch
            mgm = ea_load_nii(fullfile(folder,['mwc1' fname]));
            mwm = ea_load_nii(fullfile(folder,['mwc2' fname]));
            sk=10;
            
            spm_smooth(mgm.fname,fullfile(folder,['smwc1' fname]),[sk sk sk]);
            spm_smooth(mwm.fname,fullfile(folder,['smwc2' fname]),[sk sk sk]);
            
            sgm = fullfile(folder,['smwc1' fname]);
            swm = fullfile(folder,['smwc2' fname]);
            sgm=ea_load_nii(sgm);
            swm=ea_load_nii(swm);
            
            
        end
        
        
        dim = mgm;
        dim.img = zeros(size(dim.img));
        sdim = dim;
        ssdim = dim;
        sk=2;
        
        for a = 1:size(mgm.img,1)/2
            for b = 1:size(mgm.img,2)
                for c = 1:size(mgm.img,3)
                    i = [a b c]';
                    
                    
                    
                    
                    mni = round(wjn_cor2mni(i',mgm.mat));
                    nmni = [-mni(1) mni(2:3)];
                    vi = wjn_mni2cor(nmni,mgm.mat);
                    
                    if vi(1)>mgm.dim(1)
                        vi(1) = mgm.dim(1);
                    end
                    if vi(2)>mgm.dim(2)
                        vi(2)=mgm.dim(2);
                    end
                    if vi(3)>mgm.dim(3)
                        vi(3)=mgm.dim(3);
                    end
                    if sk
                        
                        x=[wjn_sc(1:size(mgm.img,1),a-sk):wjn_sc(1:size(mgm.img,1),a+sk)];
                        y=[wjn_sc(1:size(mgm.img,2),b-sk):wjn_sc(1:size(mgm.img,2),b+sk)];
                        z=[wjn_sc(1:size(mgm.img,3),c-sk):wjn_sc(1:size(mgm.img,3),c+sk)];
                        
                        vx=[wjn_sc(1:size(mgm.img,1),vi(1)-sk):wjn_sc(1:size(mgm.img,1),vi(1)+sk)];
                        vy=[wjn_sc(1:size(mgm.img,2),vi(2)-sk):wjn_sc(1:size(mgm.img,2),vi(2)+sk)];
                        vz=[wjn_sc(1:size(mgm.img,3),vi(3)-sk):wjn_sc(1:size(mgm.img,3),vi(3)+sk)];
                        
                        sdg1=nanmean(nanmean(nanmean(mgm.img(x,y,z))));
                        sdg2=nanmean(nanmean(nanmean(mgm.img(vx,vy,vz))));
                        sdw1=nanmean(nanmean(nanmean(mwm.img(x,y,z))));
                        sdw2=nanmean(nanmean(nanmean(mwm.img(vx,vy,vz))));
                        sdim.img(i(1),i(2),i(3))=(sdg1-sdg2)+(sdw2-sdw1);
                        sdim.img(vi(1),vi(2),vi(3))=(sdg2-sdg1)+(sdw1-sdw2);
                        
                    end
                    
                    
                    
                    %             dg1=mgm.img(a,b,c);
                    %             dg2=mgm.img(vi(1),vi(2),vi(3));
                    %             dw1=mwm.img(a,b,c);
                    %             dw2=mwm.img(vi(1),vi(2),vi(3));
                    %             dim.img(i(1),i(2),i(3))=(dg1-dg2)+(dw2-dw1);
                    %             dim.img(vi(1),vi(2),vi(3))=(dg2-dg1)+(dw1-dw2);
                    
                    ssdg1=sgm.img(a,b,c);
                    ssdg2=sgm.img(vi(1),vi(2),vi(3));
                    ssdw1=swm.img(a,b,c);
                    ssdw2=swm.img(vi(1),vi(2),vi(3));
                    ssdim.img(i(1),i(2),i(3))=(ssdg1-ssdg2); %+(ssdw2-ssdw1);
                    ssdim.img(vi(1),vi(2),vi(3))=(ssdg2-ssdg1);% + (ssdw1-ssdg2);
                    
                    %             dim.img(i(1),i(2),i(3))=d1-d2;
                    %             dim.img(vi(1),vi(2),vi(3))=d2-d1;
                    %             dim.img(vi(1),vi(2),vi(3))=dim.img(i(1),i(2),i(3));
                end
            end
            disp(a)
        end
        
        % dim.img(:) = wjn_zscore(dim.img(:));
        
        % dim.dim = mgm.dim;
        % dim.fname = fullfile(folder,['d' fname]);
        % ea_write_nii(dim)
        
        
        
        ssdim.img(ssdim.img<0)=0;
        ssdim.dim = mgm.dim;
        ssdim.fname = fullfile(folder,['ssd_' method '_' fname]);
        ea_write_nii(ssdim)
        
        sdim.img(sdim.img<0)=0;
        sdim.dim = mgm.dim;
        sdim.img=sdim.img(1:sdim.dim(1),1:sdim.dim(2),1:sdim.dim(3));
        
        sdim.fname = fullfile(folder,['sd_' method '_'  fname]);
        ea_write_nii(sdim)
        % spm_smooth(sdim.fname,fullfile(folder,['ssd' fname]),[sk sk sk])
        % end
        
        
        sumdim = dim;
        sumdim.fname = fullfile(folder,['sum_' method '_' fname]);
        sumdim.img = sdim.img+ssdim.img;
        ea_write_nii(sumdim);
        
        if strcmp(method,'spm')
            matlabbatch{1}.spm.util.defs.comp{1}.def = {fullfile(folder,['iy_' fname])};
            matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {sdim.fname;ssdim.fname;sumdim.fname};
            matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 4;
            matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
            matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'r';
            spm_jobman('run',matlabbatch)
            
            
            clear matlabbatch
            matlabbatch{1}.spm.util.defs.comp{1}.def = {fullfile(folder,['y_' fname])};
            
            if strcmp(fname,'mp2rage2.nii')
                matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {fullfile(folder,fname);fullfile(folder,'mp2rage2.nii');fullfile(folder,fname);fullfile(folder,'mp2rage1.nii')};
            else
                 matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {fullfile(folder,fname)};
            end
            
            matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 4;
            matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
            matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
            matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'r';
            spm_jobman('run',matlabbatch)
        end
        toc
    end
    cd(root)
    movefile(folder,fullfile(root,['a' dirs{f}]))
    end
end

