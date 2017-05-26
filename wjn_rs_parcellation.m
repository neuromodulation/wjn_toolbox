function rvalues=wjn_rs_parcellation(rsfile,label,outname)
[lf,lt]=leadf;
addpath(genpath(lf));
[fdir,fname] = fileparts(rsfile);
if ~exist('label','var') || isempty(label)
  labels={'sensorimotor','holomotor','motor','sensory','premotor','limbic','associative','M1','SMA','GPe','GPi','STN','Cerebellum','Hippocampus',...
      'rh_sensorimotor','lh_sensorimotor','rh_holomotor','lh_holomotor','rh_motor','lh_motor','rh_sensory','lh_sensory','rh_Cerebellum','lh_Cerebellum',...
      'rh_premotor','lh_premotor','rh_limbic','lh_limbic','rh_associative','lh_associative','rh_M1','lh_M1','rh_SMA','lh_SMA',...
      'rh_GPe','lh_GPe','rh_GPi','lh_GPi','rh_STN','lh_STN'};
    if ~exist('outname','var')
        outname = ['rs_parc_' fname];
    end
else
    labels = label;
    if ischar(label) 
        
        outname = label;
        labels={label};
    elseif ~exist('outname','var')
        outname = ['rs_parc_' fname];
    end
end

for a = 1:length(labels)
    fname=fullfile(lt,'parcellations',[labels{a} '.nii'])
    rvalues.(labels{a}) = wjn_rs_parc(rsfile,fname);
end

save(outname,'-struct','rvalues')