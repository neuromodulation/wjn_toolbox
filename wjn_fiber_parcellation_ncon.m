function nfibers=wjn_fiber_parcellation_ncon(ftrfile,label,outname,cont)
if ~exist('cont','var')
    cont = 0;
end
[lf,lt]=leadf;
addpath(genpath(lf));

load(ftrfile,'fibers','idx');
if ~exist('label','var')
   labels={'sensorimotor','holomotor','motor','sensory','premotor','limbic','associative','M1','SMA','GPe','GPi',...
      'rh_sensorimotor','lh_sensorimotor','rh_holomotor','lh_holomotor','rh_motor','lh_motor','rh_sensory','lh_sensory',...
      'rh_premotor','lh_premotor','rh_limbic','lh_limbic','rh_associative','lh_associative','rh_M1','lh_M1','rh_SMA','lh_SMA',...
      'rh_GPe','lh_GPe','rh_GPi','lh_GPi'};
    if ~exist('outname','var')
        outname = 'ncon_parc';
    end
    
else
    labels = label;
    if ischar(label)
        outname = label;
        labels={label};
    elseif ~exist('outname','var')
        outname = 'ncon_parc';
    end
end
for a = 1:length(labels)
    mni = [];
    disp(labels{a})
    nii = ea_load_nii(fullfile(lt,'parcellations',[labels{a} '.nii']));
    i=find(nii.img>0);
    for b = 1:length(i)
        [x,y,z] = ind2sub(nii.dim,i(b));
        nmni = nii.mat*[x y z 1]';
        mni(b,:) = nmni(1:3);
    end
    mni=unique(mni,'rows');
    n=0;
    nf = [];
    if ~cont
        ix = fibers(:,4);
        istart = find(mydiff(ix));
        istop = istart+idx(1,:)'-1;
        iss = [istart;istop];
    else
        iss = 1:size(fibers,1);
    end
    
    i= rangesearch(fibers(iss,1:3),mni,1,'Distance','Chebychev');
    
    for b=1:length(i)
        if ~isempty(i{b})
            n=n+1;
            nf =[nf;unique(fibers(iss(i{b}),4))];
        end
    end
    
    nf = unique(nf);
    disp(numel(nf));
    nfibers.(labels{a}).n=numel(nf);
    nfibers.(labels{a}).id=nf;
    
end
% keyboard
save([outname '_' ftrfile],'-struct','nfibers')
