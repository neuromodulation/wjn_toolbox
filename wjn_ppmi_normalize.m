clear all
close all
clc
root = fullfile('E:','ppmi','preprocessed');
folders = subdir(fullfile(root,'rest.nii'));
folders = {folders(:).folder}';
folders(ci('spm_coreg_norm',folders))=[];

% DOC = wjn_ppmi_read_doc(fullfile(root,'DOC.csv'))
load(fullfile(root,'docs.mat'));
savedir = fullfile('E:','ppmi','data');

for a = [105:length(folders)]
    close all
    clc
    keep a root folders DOC UPDRS savedir
    
    fn = stringsplit(folders{a},'\');
    cSubject = str2num(fn{4});
    dn = stringsplit(fn{5},'-');
    cAcqDate = [dn{2} '/' dn{3}(1:2) '/' dn{1}];
    if strcmp(cAcqDate(1),'0')
        nulldate='0';
        cAcqDate = cAcqDate(2:end);
    else
        nulldate = '';
    end
    id= find(DOC.Subject==cSubject);
    if length(id)>4
        id=id(ismember(id,ci(cAcqDate,DOC.AcqDate)));
        id = id(1);
    else
        id = id(1);
    end
    cDOC = DOC(id,[2 3 4 5 6 10]);
    
    if cDOC.Visit == 1
        cV = 'BL';
    elseif cDOC.Visit < 11
        cV = ['V0' num2str(cDOC.Visit-1)];
    elseif cDOC.Visit == 90
        cV = 'V08';
    else
        cV = ['V' num2str(cDOC.Visit-1)];
    end
    
    aUPDRS= UPDRS(find(UPDRS.PATNO==cSubject),[3 4 6:end-4]);
    iu = ci(cV,aUPDRS.EVENT_ID);
    if isempty(iu)
        tempDate = [nulldate cAcqDate];
        iu = ci(tempDate([1:3 end-3:end]),aUPDRS.INFODT);
    end
    
    
    cUPDRS = aUPDRS(iu(1),:);
    tUPDRS = nansum(table2array(cUPDRS(1,6:end-6)));
    rhUPDRS = nansum(table2array(cUPDRS(1,5+ [4 6 8 10 12 14 16 24 26 28 30])));
    lhUPDRS = nansum(table2array(cUPDRS(1,5+ [5 7 9 11 13 15 17 25 27 29 31])));
    
    fname = [num2str(DOC.Subject(id)) '_' DOC.Group{id} '_' cV '_' num2str(DOC.Age(id)) '_' num2str(tUPDRS) '_' num2str(rhUPDRS) '_' num2str(lhUPDRS)];
    
    
    
    cd(folders{a});
    mkdir('spm_coreg_norm')
    copyfile('rest.nii',fullfile('spm_coreg_norm','rest.nii'));
    if exist('raw_anat_t1.nii','file')
        copyfile('raw_anat_t1.nii',fullfile('spm_coreg_norm','anat_t1.nii'))
        copyfile('raw_anat_t2.nii',fullfile('spm_coreg_norm','anat_t2.nii'))
    else
        copyfile('anat_t1.nii',fullfile('spm_coreg_norm','anat_t1.nii'))
        copyfile('anat_t2.nii',fullfile('spm_coreg_norm','anat_t2.nii'))
    end
    cd('spm_coreg_norm')
%     rest = load_nii('rest.nii');
    sfiles ={};
    for b=1:300
        sfiles{b} = ['rest.nii,' num2str(b)];
    end
    
clear matlabbatch
matlabbatch{1}.spm.spatial.realign.estwrite.data = {sfiles'}';
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
spm_jobman('run',matlabbatch)

volnum = ea_load_nii('rrest.nii');
volnum = volnum.volnum;
sfiles ={};
for b=1:volnum
    sfiles{b} = ['rest.nii,' num2str(b)];
end

clear matlabbatch
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {'anat_t1.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.source = {'meanrest.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.other = strcat('r',sfiles');
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
spm_jobman('run',matlabbatch)


clear matlabbatch
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {'anat_t1.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = ['anat_t1.nii','meanrest.nii',strcat('r',sfiles)]';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'E:\Dropbox (Personal)\matlab\spm12\tpm\TPM.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
spm_jobman('run',matlabbatch)

nii=ea_load_nii('wrrest.nii');
mnii = ea_load_nii('wmeanrest.nii');
t1nii = ea_load_nii('wanat_t1.nii');

for b = 1:size(nii.img,4)
    temp = nii.img(:,:,:,b);
    mat(:,b) = temp(:);
end

data = table2struct(cDOC);
data.fname = fname;
data.cDOC = cDOC;
data.cUPDRS = cUPDRS;
data.aUPDRS = aUPDRS;
data.tUPDRS = tUPDRS;
data.lhUPDRS = lhUPDRS;
data.rhUPDRS = rhUPDRS;
data.mat = mat;
data.t1 = t1nii;
data.m = mnii;
save(fullfile(savedir,fname),'data');

spm_check_registration('wanat_t1.nii','wrrest.nii,10')
myprint(fullfile(savedir,'spmcheckreg',fname))
end


