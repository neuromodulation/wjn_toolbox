function wjn_nr_cnn_segment(imagefiles,segnet)

inv1=wjn_read_nii(imagefiles{1});
inv2=wjn_read_nii(imagefiles{2});
uni = wjn_read_nii(imagefiles{3});

dummy = inv1;
dummy.fname = 'dummy.nii';
in = ~logical(inv1.img(:)<100&inv2.img(:)<100&uni.img(:)>1000);
dummy.img(:) = in(:);
[cnc]=bwconncomp(uint8(dummy.img>0),18);
csize=cellfun('length',cnc.PixelIdxList);
dummy.img(cell2mat(cnc.PixelIdxList(csize<max(csize))'))=0;
in = dummy.img(:);
dummy.fname = 'headmask.nii';
ea_write_nii(dummy);
x = wjn_normalize([wjn_zscore(inv1.img(:)) wjn_zscore(inv2.img(:)) wjn_zscore(uni.img(:)) in])';

ts = [5 4 3 2 1];
for a = 1:5
    md = mahal([inv1.img(:) inv2.img(:) uni.img(:)],segnet.minput{a})';

    if a>1
        nx = [x;wjn_zscore(md);out.ny];
    else
        nx = [x ;wjn_zscore(md)];
    end
    net=segnet.nets{a};
    out.ny(a,:) = net(nx);
end

[~,isynth]=max(out.ny);
% isynth(sum(out.ny)<.5)=0;


[~,isynth]=max(out.ny);
iseg=inv1;
iseg.fname = 'synthetic_segmentation.nii';
iseg.img(:) = isynth;
ea_write_nii(iseg);

segs={'hd','bn','csf','wm','gm'};
for a = 1:length(segs)
    sseg = inv1;
    sseg.fname = ['synthetic_' segs{a} '.nii'];
    sseg.img(:) = (isynth==a);%-(sum(out.ny(4:5,:))>.5);
    ea_write_nii(sseg);
    [cnc1]=bwconncomp(~uint8(sseg.img),18);
    c1size=cellfun('length',cnc1.PixelIdxList);
    sseg.img(cell2mat(cnc1.PixelIdxList(c1size<nanmean(segnet.bc1size(:,a)))'))=1;
    [cnc0]=bwconncomp(uint8(sseg.img),18);
    c0size=cellfun('length',cnc0.PixelIdxList);
    sseg.img(cell2mat(cnc0.PixelIdxList(c0size<nanmean(segnet.bc0size(:,a)))'))=0;
    sseg.fname = ['cleaned_synthetic_' segs{a} '.nii'];
    ea_write_nii(sseg);
end


