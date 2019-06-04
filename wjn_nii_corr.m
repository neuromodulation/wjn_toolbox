function [nii,irn,ipn]=wjn_nii_corr(files,v,outname,w,m,perm,type)
warning('off','all')

nii = wjn_read_nii(files{1});

if ~exist('type','var')
    type = 'spearman';
end
if ~exist('w','var')
    w = 1;
elseif ~w
    outname = 'temp.nii';
end

if ~exist('m','var')
    m=1;
end

if ~exist('perm','var')
    perm = 0;
end

if ischar(outname)
    outname = {outname};
end

if length(files) == length(v)
  
    for a = 1:numel(files)
        temp = wjn_read_nii(files{a});
        if m
            temp.img = temp.img+2;
            temp.fname = 'temp.nii';
            ea_write_nii(temp);
            if m==1
                temp=wjn_mask_nii(temp.fname,fullfile(leadp,'gm.nii'));
            elseif ischar(m)
                temp=wjn_mask_nii(temp.fname,m,10);
            end
            i=temp.img(:);
            i(round(i)==0)=nan;
            i=i-2;
        else
            i=temp.img(:);
            i(i==0)=nan;
        end

        rm(a,:) = i(:);
    end
elseif length(files) == 2
    rm=files{2};
end

% keyboard
inn=zeros(1,size(rm,2));
for a = 1:size(rm,2),inn(a)=any(isnan(rm(:,a)));end

inan=~inn;

rm = rm(:,inan);
r=nan(size(inan));


for b = 1:size(v,2)
    nii.img(:) = nan;
%     [r,p]=corr(rm,v(:,b),'rows','pairwise');
    if perm
        [rtemp,p]=wjn_pc(rm,v(:,b));
        p=p./2;
    else
        [rtemp,p]=corr(rm,v(:,b),'rows','pairwise','type',type);
    end
    rn=r;
    rn(inan)=rtemp';
    nii.img(:)=rn;

    irn = nii.img;
    nii.dtype = 16;
    nii.fname = ['r_' outname{b} '.nii'];
    if w
        ea_write_nii(nii)
    end
    pn=r;
    pn(inan)=p';
    nii.img(:)=pn;
    ipn=nii.img;
    nii.fname = ['p_' outname{b} '.nii'];
    if w
        ea_write_nii(nii)
        spm_imcalc({['r_' outname{b} '.nii'],['p_' outname{b} '.nii']},['rp_' outname{b} '.nii'],'i1.*(i2<=0.05)');

    end

    irp = irn;
    irp(ipn>0.05)=0;
    nii.img = irp;
    nii.fname = ['rrp_' outname{b} '.nii'];
    if w
        ea_write_nii(nii)
    end
end



