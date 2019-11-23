function chk=wjn_rsmeg_prepare_megfile(p)

   

lp = length(p);
if isnumeric(p)
   np = p;
   clear p;
end
root = wjn_rsmeg_list('root');
% keyboard

for a =1:lp
    if exist('np','var')
        p{a} = wjn_rsmeg_list(np(a));
    end
   
    megfolder = fullfile(root,'megfiles',p{a}.id);
    if ~exist(megfolder,'dir')
         chk(a)=0;
        continue
       
    end
    cd(megfolder)
    try
        D=wjn_sl(p{a}.megfile);
    catch
        [fdir,fname,ext]=fileparts(p{a}.megfile);
        D=spm_eeg_load(fullfile(fdir,['backup_' fname ext]));
        D=wjn_spm_copy(D.fullfile,p{a}.megfile);
    end
    if ~isfield(D,'isprepared') && D.fsample>301
       
    
        Do=D;
        drug = strrep(p{a}.megfile(end-6:end-4),'_','');

        D=wjn_downsample(D.fullfile,300,150,'d');
        Do.move(['backup_' Do.fname]);
        clear Do;
        D=wjn_reepoch(D.fullfile,1024,drug);
        D.move(p{a}.megfile);
    end
        D=spm_eeg_load(p{a}.megfile);
        surfaces = {'iskull','cortex','oskull','scalp'};
        for b = 1:length(surfaces)
     
            [fdir,ffiles,fullfiles]=ffind(['*' surfaces{b} '*.gii'],1,1);
            eval([surfaces{b} ' = ''' fullfiles{end} ''';']);
        end

        D=wjn_meg_correct_mri(D.fullfile,iskull,cortex,oskull,scalp);
        drug = strrep(p{a}.megfile(end-6:end-4),'_','');
        D.drug = drug;
        
           

        D.isprepared = 1;
        save(D)
        delete('cmrd*.*')
        delete('rd*.*')
        delete('d*.*')
        chk(a) = 1;
    end
    cd(root)
end
        