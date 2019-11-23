%% rerun 3116 V06 - broken images
%% rerun 3118 V06 - failed normalization
%% rerun 3105 V08 - just one image in rest

clear all
close all
root = fullfile('E:','ppmi','data');
cd(root)
delete *.nii
files = ffind('*.mat');
load(fullfile('E:\ppmi\preprocessed','mask.mat'))
for a = 1:length(files)
    tic
    load(files{a})
    if size(data.mat,2)>1
        
%     nii=data.t1;
%     nii.dt = [16 0];
    ma(a) = nanmean(nanmean(data.mat(i,:)));
    mv(a,:) = nanmean(data.mat(i,:),2);
    rmv(a,:) = nanmean(data.mat(i,:),2)./ma(a); 
    u(a) = data.tUPDRS;
   

    else
        s(a) =nan;
        u(a) = nan;
    end
      toc
end

%%
%  E=[];
%     nE=[];
%     nmat = data.mat-nanmean(data.mat);
%     for  b=1:length(i)
%         E(b)=my_entropy(data.mat(i(b),:)');
%         nE(b)=my_entropy(nmat(i(b),:)'); 
%     end
%     nii=mnii;
%     nii.dt=[16 0];
%     nii.img(i)=wjn_zscore(E);
%     nii.img(isnan(nii.img))=0; 
%     nii.fname = [data.fname '_E.nii'];
%     ea_write_nii(nii);
%         nii.dt=[16 0];
%     nii.img(i)=wjn_zscore(nE);
%     nii.img(isnan(nii.img))=0;
%     nii.fname = [data.fname '_nE.nii'];
%     ea_write_nii(nii);
%     nii.img(i)=wjn_zscore(nansum(data.mat(i,:),2));
%     nii.img(isnan(nii.img))=0;
%     nii.fname = [data.fname '_sum.nii'];
%     ea_write_nii(nii);
%     bdur=[];
%     bn=[];
%     bamp = [];
%     mdur = [];
%     for b = 1:length(i)
%         d=smooth(nmat(i(b),:),5);
%               [bursts,amp,n]=rox_burst_duration(d,prctile(d,75),0.5,4000,'brown');
%         mdur(b) = nanmax(bursts);
%         bdur(b)=nanmean(bursts);
%         bn(b) = n;
%         bamp(b) = nanmax(amp);
%     end
% 
%     nii.img(i) = bdur;
%     nii.img(isnan(nii.img))=0;
%     nii.fname = [data.fname '_bdur.nii'];
%     ea_write_nii(nii);
%         nii.img(i) = bamp;
%     nii.img(isnan(nii.img))=0;
%     nii.fname = [data.fname '_bamp.nii'];
%     ea_write_nii(nii);
%             nii.img(i) = bn;
%     nii.img(isnan(nii.img))=0;
%     nii.fname = [data.fname '_bn.nii'];
%     ea_write_nii(nii);
%         nii.img(i) =mdur;
%     nii.img(isnan(nii.img))=0;
%     nii.fname = [data.fname '_mdur.nii'];
%     ea_write_nii(nii);