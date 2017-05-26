function [pvalues,L,ocluster,n]=wjn_nii_corr_cluster_correction(sfiles,v,vname,ni,permv,type)

if ~exist('permv','var')
    permv = 'v';
end

if ~exist('ni','var')
    ni = 5000;
end

if ~exist('type','var')
    type = 'spearman';
end

m=fullfile(leadp,'sensorimotor.nii');

for a = 1:numel(sfiles)
    temp = wjn_read_nii(sfiles{a});
    if m
        temp.img = temp.img+2;
        temp.fname = 'temp.nii';
        ea_write_nii(temp);
        if m==1
            temp=wjn_mask_nii(temp.fname,fullfile(leadp,'gm.nii'));
        elseif ischar(m)
            temp=wjn_mask_nii(temp.fname,m,.001);
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

[p,irn,ipn]=wjn_nii_corr({sfiles{1},rm},v,vname,1,0,0,type);
% keyboard



[ocluster,L,n,num]=wjn_max_cluster((irn>0).*(ipn<=.05));
p.img(:) = nan;
p.img(L>0)=irn(L>0);
p.fname = ['c_' p.fname];
ea_write_nii(p)
p.img(:) = nan;
p.img(L==n)=irn(L==n);
p.fname = ['max_' p.fname];
ea_write_nii(p)

ow = sum(irn(L==n));
for a = 1:num
    aw(a) = sum(irn(L==a));
end

inn=zeros(1,size(rm,2));
for c = 1:size(rm,2),inn(c)=any(isnan(rm(:,c)));end
inan=~inn;
idx = find(inan);
rrm = nan(size(rm));

clear w
for a = 1:ni
    if strcmp(permv,'v')
        v = v(randperm(length(v)));
        rrm = rm;
    elseif strcmp(permv,'s')
        for b = 1:length(v)
            rrm(b,idx) = rm(b,idx(randperm(length(idx))));
        end
    end
    [~,pirn,pipn]=wjn_nii_corr({sfiles{1},rrm},v,[],0,0,0,type);
    [x,pL,pn] = wjn_max_cluster((pirn>0).*(pipn<=.05));
    if pn
        w(a) = sum(pirn(pL==pn))
    else
        w(a)=0
    end
    disp([num2str(a) '/' num2str(ni) ' permutations']);
end


srn=sort([aw w]);

for a = 1:length(aw)
    pvalues(a) = 1-(find(srn==aw(a),1,'last')./length(srn));
end

i=find(pvalues<=0.05);
rL=L(:);
iL = zeros(size(rL));
for a = 1:length(i)
    iL(rL==i(a))=1;
end
nii = wjn_read_nii(['r_' vname '.nii']);
nii.img(:) = nii.img(:).*iL;
nii.fname = ['cluster_corrected_' nii.fname];
ea_write_nii(nii)

save(vname)
