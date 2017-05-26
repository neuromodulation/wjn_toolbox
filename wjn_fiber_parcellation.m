function nfibers=wjn_fiber_parcellation(ftrfile,outname,cont,label)


if ~exist('cont','var')
    cont =1;
end

[lf,lt]=leadf;
addpath(genpath(lf));

load(ftrfile,'fibers','idx');
if ~exist('label','var')
  labels={'sensorimotor','holomotor','motor','sensory','premotor','limbic','associative','M1','SMA','GPe','GPi','STN','Cerebellum',...
      'rh_sensorimotor','lh_sensorimotor','rh_holomotor','lh_holomotor','rh_motor','lh_motor','rh_sensory','lh_sensory','rh_Cerebellum','lh_Cerebellum',...
      'rh_premotor','lh_premotor','rh_limbic','lh_limbic','rh_associative','lh_associative','rh_M1','lh_M1','rh_SMA','lh_SMA',...
      'rh_GPe','lh_GPe','rh_GPi','lh_GPi','rh_STN','lh_STN'};
%     labels={'sensorimotor','holomotor','motor','sensory','premotor','limbic','associative','M1','SMA','GPe','GPi',...};
    
    
    if ~exist('outname','var')
        outname = 'parc';
    end
    
else
    labels = label;
    if ischar(label)
        outname = label;
        labels={label};
    elseif ~exist('outname','var')
        outname = 'parc';
    end
end
for a = 1:length(labels)
    tic
    try
        mni = [];
        load(fullfile(leadp,labels{a}),'mni')
        disp('MNI file found')

    catch
        disp('No MNI file found');
        mni = [];
        nii = ea_load_nii(fullfile(leadp,[labels{a} '.nii']));
        i=find(nii.img>0);
        mni = nan(length(i),3);
        for b = 1:length(i)
            [x,y,z] = ind2sub(nii.dim,i(b));
            nmni = nii.mat*[x y z 1]';
            mni(b,:) = nmni(1:3);
        end
        mni=unique(mni,'rows');
        disp('MNI voxels found')
        save(fullfile(leadp,[labels{a} '.mat']),'mni');
    end
     if ~cont
        ix = fibers(:,4);
        if size(idx,2)>size(idx,1)
            idx = idx';
        end
        istart = find(mydiff(ix));
        istop = istart+idx-1;
        iss = [istart;istop];
    else
        iss = 1:size(fibers,1);
    end


    n=0;
    nf = [];
    
    i= rangesearch(fibers(iss,1:3),mni,1,'Distance','Chebychev');
    
    for b=1:length(i)
        if ~isempty(i{b})
            n=n+1;
            nf =[nf;unique(fibers(i{b},4))];
        end
    end
    
    nf = unique(nf);
    disp(labels{a})
    disp(numel(nf));
    toc
    nfibers.(labels{a}).n=numel(nf);
    nfibers.(labels{a}).id=nf;
    
end
% keyboard
save([outname '_' ftrfile],'-struct','nfibers')
