function wjn_nii_write_connectome(fname,fibers)

map=ea_load_nii(fullfile(ea_getearoot,'connectomes','spacedefinitions','222.nii'));


mapsz=size(map.img);
map.img(:)=0;

allfibcs=fibers(:,1:3);
allfibcs=round(map.mat\[allfibcs,ones(size(allfibcs,1),1)]');
topaint=sub2ind(mapsz,allfibcs(1,:),allfibcs(2,:),allfibcs(3,:));
utopaint=unique(topaint);
c=countmember(utopaint,topaint);
map.img(utopaint)=c;

map.fname=fname;
map.dt=[16,0];
spm_write_vol(map,map.img);
