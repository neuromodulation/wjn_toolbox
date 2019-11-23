function source_coherence(folder,file,refchans,freqranges,condition,nshuffle,normalisation)
%function source_coherence(folder,file,refchans,freqranges,condition,nshuffle,normalisation)
% 
root = cd;

D=spm_eeg_load(file);
if ~iscell(refchans);
    refchans = cellstr(refchans);
end
if ~exist('normalisation','var')
    normalisation = 1;
end

if ~exist(folder,'dir')
    mkdir(folder);
end
calcstring = '(';
for a = 1:numel(refchans)
if a < numel(refchans)
        eval('calcstring = [calcstring ''i'' num2str(a) ''+'' ]')
else
            eval('calcstring = [calcstring ''i'' num2str(a) '')/'' num2str(a)]')
end
end

[mf,dbf,sys]=getsystem;
imagefiles = {};
[ff,fname,ext]=fileparts(file);
fw = freqranges;

for b = 1:size(fw,1);
for a=1:numel(refchans);
    
%         pause(1)
keep D a b fw fname mf dbf sys fold normalisation refchans file root folder freqranges condition nshuffle calcstring reff
        
        [~,id,~] = fileparts(D.fname);
        cd(folder);
        dirname = [refchans{a} '_' num2str(fw(b,1)) '_' num2str(fw(b,2))];
        cdir = fullfile(folder,dirname);
%         pause(1)
        if ~exist(dirname,'dir')
        mkdir(dirname);
        end
        clear matlabbatch
%         pause(1)
        matlabbatch{1}.spm.tools.beamforming.data.dir = {[cd '\' dirname]};
        matlabbatch{1}.spm.tools.beamforming.data.D = {fullfile(D.path,D.fname)};
        matlabbatch{1}.spm.tools.beamforming.data.val = 1;
        matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'sensors';
        matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
        matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
        matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
        matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.resolution = 10;
        matlabbatch{2}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI template';
        matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
       
        matlabbatch{3}.spm.tools.beamforming.features.woi = [-Inf Inf];
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.foi = fw(b,:);
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.taper = 'dpss';
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.keepreal = 0;
        matlabbatch{3}.spm.tools.beamforming.features.plugin.csd.hanning = 1;
        matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 0.01;
        matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
        matlabbatch{4}.spm.tools.beamforming.inverse.plugin.dics.fixedori = 'yes';
        
%         close all
     
        
    for shuffle = 0:nshuffle;
        if shuffle
            sh = 1;
        else
            sh = 0;
        end
               
%                 if ~exist(fullfile(folder,dirname,['sm_dics_refcoh' condition '_dics_refcoh_' fname '.nii']),'file')
                  if ischar(condition) || (iscell(condition) && numel(condition) == 1);
                    if ischar(condition)
                   nc = {condition};
                   else
                       nc = condition;
                   end
                matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = refchans{a};
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = sh;
                if strcmp(nc{1},'all')
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.all = 1;
                 matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
                else
                    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.condlabel = nc;
                 matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = nc;
                end
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = fw(b,:);
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
                  matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'no';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
               
               elseif iscell(condition) && numel(condition) > 1
                    nc = condition;
               matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.name = refchans{a};
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.reference.refchan.shuffle = sh;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.whatconditions.all = 1;
                 matlabbatch{3}.spm.tools.beamforming.features.whatconditions.all = 1;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.sametrials = false;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.woi = [-Inf Inf];
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.contrast = 1;
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.foi = fw(b,:);
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.taper = 'dpss';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'bycondition';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.scale = 'no';
                matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.modality = 'MEG';
                 end
                
                  
              
                matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
                if normalisation && numel(nc) == 1
                  matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
                    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'singleimage';
                elseif normalisation && iscell(condition) && numel(condition) > 1
                    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'all';
                    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'bycondition';
                elseif ~normalisation 
                    matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.normalise = 'no';
                    matlabbatch{5}.spm.tools.beamforming.output.plugin.image_dics.result = 'bycondition';
                else 
                    error('normalisation not defined')
                end
                matlabbatch{6}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
                tic
                % search for images
                
                
                if (numel(nc) == 1 && ~sh && ~exist(fullfile(cdir,['sm_dics_refcoh_cond_' nc{1} '_' id '.nii']),'file')) || ...
                    (numel(nc) == 1 && sh && ~exist(fullfile(cdir,['sm_dics_refcoh_shuffled_cond_' nc{1} '_' id '.nii']),'file'))
                irun = 1;
                elseif numel(nc )>=2 &&  ~sh
                    for nn = 1:numel(nc)
                        ex(nn) = ~exist(fullfile(cdir,['sm_dics_refcoh_cond_' nc{nn} '_' id '.nii']),'file')
                    end
                    
                    if sum(ex)
                        irun = 1;
                    else irun = 0;
                    end
                elseif numel(nc )>=2 &&  sh
                    for nn = 1:numel(nc)
                        ex(nn) = ~exist(fullfile(cdir,['sm_dics_refcoh_shuffled_cond_' nc{nn} '_' id '.nii']),'file')
                    end
                    
                    if sum(ex)
                        irun = 1;
                    else 
                        irun = 0;
                    end
                else
                    irun = 0;
                end
                    
                   
                if irun
                    tic
                spm_jobman('run',matlabbatch);
                toc
                delete(fullfile(folder,dirname,'BF.mat'))
                        if sh && nshuffle >= 2;
                            movefile(fullfile(cdir,['dics_refcoh_shuffled' id '.nii']),fullfile(cdir,['dics_refcoh_shuffled_cond_' condition '_'  id '_' num2str(shuffle) '.nii']))
                     
                        end
                        
                 if numel(nc) ==1;
                   if ~sh
                     movefile(fullfile(cd,['dics_refcoh_' id '.nii']),fullfile(cd,['dics_refcoh_cond_' nc{1} '_'  id '.nii']))
                   elseif sh
                        movefile(fullfile(cd,['dics_refcoh_shuffled_' id '.nii']),fullfile(cd,['dics_refcoh_shuffled_cond_' nc{1} '_'  id '.nii']))
                    end
                end
                
                 %% mask Source coherence from EEG Template
                 
               [imagefiles,imagefolder] = ffind(fullfile(folder,dirname,'dics_refcoh_*.nii'))
               
               for i = 1:length(imagefiles)
                   
                   cim = fullfile(imagefolder,imagefiles{i});
                Vi = {cim;...
                    fullfile(spm('dir'),'EEGtemplates','iskull.nii')};
                Vo = fullfile(imagefolder,['m_' imagefiles{i}]);
                f = 'i1.*(i2>1)';
                spm_imcalc(Vi,Vo,f)
              
              
                %% Smooth
                P = Vo;
                Q = fullfile(imagefolder,['sm_' imagefiles{i}]);
                spm_smooth(P,Q,[16 16 16]);
                
               end
               
               delete(fullfile(imagefolder,'m_*.nii'))  
                else
                    warning('taking old images!!!')
                end

                 
               %% find images         
              
               
        
%         close all
        %% stats
%         if nshuffle(1)>= 5 
%         clear matlabbatch
%             delete(fullfile(folder,dirname,'SPM.mat'))
%             mf = getsystem;
%             load(fullfile(mf,'meg_toolbox', 'cohimage_ttest_job.mat'));
%              spm_jobman('initcfg')
%             matlabbatch{1}.spm.stats.factorial_design.dir{1} = [folder '\' dirname];
% 
%             matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {ofname};
%          
%             matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = sfname';
%             matlabbatch{1}.spm.stats.factorial_design.masking.em = {fullfile(spm('dir'),'EEGtemplates','iskull.nii')};
%             spm_jobman('serial', matlabbatch);
%            
%             clear matlabbatch
%            get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.01,'FWE',100);
%            get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.01,'FWE',0);
%            get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.05,'FWE',100);
%            [dpeaks,table] = get_results(fullfile(folder,dirname,'SPM.mat'),fname,0.05,'FWE',0);
%            save(['table_' condition '_' fname '.mat'],'table','dpeaks') 
% %         imagefiles = [imagefiles ofname sfname];
%         end
       
%            cla
%            close all


    end
    
    if ischar(condition)
        nc = {condition}
    elseif iscell(condition)
        nc = condition;
    end;
    
    can = fullfile(spm('dir'),'canonical','single_subj_T1.nii')
    freq = [num2str(fw(b,1)) '-' num2str(fw(b,2))]; 
    
    
    for con = 1:length(nc);
        close
      file = fullfile(cdir,['dics_refcoh_cond_' nc{con} '_'  id '.nii']);
      
       spm_orthviews('reset')
   spm_check_registration(can);
   hold on
   t1 = spm_vol_nifti(file)
            cm = colorlover(5);
   [dat, xyz] = spm_read_vols(t1);
        [unused, mxind] = max(dat(:));
        gma= xyz(:, mxind);
        alabel=get_mni_anatomy(gma);
        hold on;
        spm_orthviews('reposition', gma);
        spm_orthviews('addcolouredimage',1,file,cm(1,:))   
        spm_orthviews('redraw');
        stringtitle = [nc{con} '  ' strrep(refchans{a},'_',' ')   ': ' freq ' Hz LFP to MEG Coherence'];
        stringa = [' Peak: ' num2str(gma') ' mm'];
        an=annotation(gcf,'textbox',[0.2 0.9 0.5 0.1],'String',{stringtitle,stringa},'LineStyle','none');
        myfont(an);
        H = annotation('textbox',[0.53 0.4 0.45 0.1],'STring',{['Current location ' num2str(gma') 'mm'], 'Global Maximum for Coherence',alabel});    
        set(H,'FontSize',9,'FitHeightToText','on'); myfont(H);set(H,'Fontsize',11);set(H,'EdgeColor','none','linestyle','none')
        set(an,'Fontsize',20,'EdgeColor','none','HorizontalAlignment','center','FitHeightToText','on')
        spm_orthviews('XHairs','on')
        set(gca,'color','k')
        printname= [refchans{a} '_' nc{con} '_' freq '_' id '.png'];
       
        
        
        reff{a} = cdir;
         print(fullfile(reff{a},printname),'-dpng','-cmyk','-r100','-painters');
        save(fullfile(reff{a},'gma.mat'),'gma')
         close
    end
end
    



for con = 1:length(nc);
    for rf = 1:length(refchans);
        Vi{rf,1} = fullfile(reff{rf},['dics_refcoh_cond_' nc{con} '_'  id '.nii']);
    end   
                file = fullfile(folder,['mean_' freq '_' nc{con} '_' id '.nii' ]);
                
                spm_imcalc(Vi,file,calcstring)
                
        close

       spm_orthviews('reset')
   spm_check_registration(can);
   hold on
   t1 = spm_vol_nifti(file)
            cm = colorlover(5);
   [dat, xyz] = spm_read_vols(t1);
        [unused, mxind] = max(dat(:));
        gma= xyz(:, mxind);
        alabel=get_mni_anatomy(gma);
        hold on;
        spm_orthviews('reposition', gma);
        spm_orthviews('addcolouredimage',1,file,cm(1,:))   
        spm_orthviews('redraw');
        stringtitle = [nc{con} '  ' strrep(refchans{a},'_',' ')   ': ' freq ' Hz LFP to MEG Coherence'];
        stringa = [' Peak: ' num2str(gma') ' mm'];
        an=annotation(gcf,'textbox',[0.2 0.9 0.5 0.1],'String',{stringtitle,stringa},'LineStyle','none');
        myfont(an);
        H = annotation('textbox',[0.53 0.4 0.45 0.1],'STring',{['Current location ' num2str(gma') 'mm'], 'Global Maximum for Coherence',alabel});    
        set(H,'FontSize',9,'FitHeightToText','on'); myfont(H);set(H,'Fontsize',11);set(H,'EdgeColor','none','linestyle','none')
        set(an,'Fontsize',20,'EdgeColor','none','HorizontalAlignment','center','FitHeightToText','on')
        spm_orthviews('XHairs','on')
        set(gca,'color','k')
        printname= ['mean_' freq '_' nc{con} '_' id '.png'];
        print(printname,'-dpng','-cmyk','-r100','-painters');
        close
end
end


end


% cd(root);
% imagefiles = [ofname sfname]