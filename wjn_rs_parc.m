function r = wjn_rs_parc(nii,mask,v)

if ~exist('v','var')
    spm_imcalc({nii,mask},'temp.nii','i1.*(i2>0.001)');
else
    spm_imcalc({nii,mask},'temp.nii',['i1.*(i2>=' num2str(v(1)) '&i2<=' num2str(v(2)) ')']);
end

nii=wjn_read_nii('temp.nii');
r=nanmean(nii.img(nii.img~=0));
delete('temp.nii')
pause(2)