function [segnet,out] = wjn_nr_cnn_segment_train(imagefiles,segnet,segmentationfiles)

tr = exist('segmentationfiles','var');
ndata = 5000;

if ~tr
    segmentationfiles={};
end
wjn_coregister(fullfile(spm('dir'),'\canonical\avg152T1.nii'),imagefiles{1},[imagefiles(2:end),segmentationfiles]')

inv1=wjn_read_nii(['r' imagefiles{1}]);
inv2=wjn_read_nii(['r' imagefiles{2}]);
uni = wjn_read_nii(['r' imagefiles{3}]);

se = exist('segnet','var')&&~isempty(segnet);

if se
shorten = segnet.shorten;
else
shorten = 1;
end


dummy = inv1;
dummy.fname = 'dummy.nii';
spm_reslice({inv1.fname,fullfile(spm('dir'),'\tpm\mask_icv.nii')},flags);
in=ea_load_nii(fullfile(spm('dir'),'\tpm\rmask_icv.nii'));
in = in.img(:);

% in = ~logical(inv1.img(:)<100&inv2.img(:)<100&uni.img(:)>1000);

% dummy.img(:) = in(:);
% [cnc]=bwconncomp(uint8(dummy.img>0),18);
% csize=cellfun('length',cnc.PixelIdxList);
% dummy.img(cell2mat(cnc.PixelIdxList(csize<max(csize))'))=0;
% in = dummy.img(:);
% dummy.fname = 'headmask.nii';
% ea_write_nii(dummy);

x = wjn_normalize([wjn_zscore(inv1.img(:)) wjn_zscore(inv2.img(:)) wjn_zscore(uni.img(:)) in])';
ts = [5 4 3 2 1];
for a = 1:5

if tr
if a<6
    seg = ['r' segmentationfiles{ts(a)}];
    segnii=wjn_read_nii(seg);
    y = segnii.img(:)'>.5;
else
    y = sum(out.y)==0;
end

if se
    minput = [segnet.minput{a};inv1.img(y)' inv2.img(y)' uni.img(y)'];
else
    segnet.bc0size=[];
    segnet.bc1size = [];
% segnet.minput = [];
    minput = [inv1.img(y)' inv2.img(y)' uni.img(y)'];
end

md = mahal([inv1.img(:) inv2.img(:) uni.img(:)],minput)';


else
    if a>1
        nx = [x ;wjn_zscore(segnet.minput{a});out.ny];
    else
        nx = [x ;wjn_zscore(segnet.minput{a})];
    end

end


if shorten
ycsf = find(y==1);
yncsf = find(y==0&in');
ii=randperm(length(yncsf));
try
    i = [ycsf,yncsf(ii(1:length(ycsf)))];
catch
    i = [yncsf,ycsf(ii(1:length(yncsf)))];
end

nh = length(i)./2;
ni = randperm(nh);

if nh<ndata
    nndata = nh;
else
nndata = ndata;
end
i = [i(ni(1:nndata)) i(ni(1:nndata)+nh)];
else
    i = 1:length(y);
    ndata = length(y);
end

if se
    yy = [segnet.yy{a} y(i)];
    xx=  [segnet.xx{a} nx(:,i)];
    net = segnet.nets{a};
else
    yy = y(i);
    xx=nx(:,i);
    net=patternnet([8 8+a 8],'trainbr');
end
disp(['Training with ' num2str(numel(yy)) ' samples!'])
net = train(net,xx,yy);
ny=net(nx).*in';
% keyboard
% [tpr,fpr,thrs]=roc(logical(yy),net(xx));
% [m,i]=max((1-fpr)+tpr);
% thr =thrs(i);           

segnet.minput{a}=minput;
segnet.nets{a}=net;
segnet.xx{a} = xx;
segnet.yy{a} = yy;

out.ny(a,:) = ny;
out.y(a,:) = y;
end
% out.ny(6,:) = sum(out.ny(4:5,:));
dummy.img(:) = zeros(size(y));
% [~,iseg]=max(out.y);
% iseg(sum(out.y)<.5)=0;
% oseg = inv1;
% oseg.fname = 'original_segmentation.nii';
% oseg.img(:) = iseg;
% ea_write_nii(oseg);
% 
% [~,isynth]=max(out.ny);
% iseg=inv1;
% iseg.fname = 'synthetic_segmentation.nii';
% iseg.img(:) = isynth;
% ea_write_nii(iseg);
% segs={'hd','bn','csf','wm','gm'};
% for a = 1:length(segs)
% sseg = inv1;
% sseg.fname = ['synthetic_' segs{a} '.nii'];
% sseg.img(:) = (isynth==a);%-(sum(out.ny(4:5,:))>.5);
% % ea_write_nii(sseg);
% [cnc1]=bwconncomp(~uint8(sseg.img),18);
% % keyboard
% c1size=cellfun('length',cnc1.PixelIdxList);
% nimg = sseg.img;
% c1sizes = unique(sort(c1size));
% m1se = wjn_mse(nimg(:)',out.y(a,:));
% for b = 1:length(c1sizes)
%     nimg(cell2mat(cnc1.PixelIdxList(c1size<c1sizes(b))'))=1;
%     cm1se = wjn_mse(nimg(:)',out.y(a,:));
%     if cm1se>m1se
%         break
%     else
%         m1se = cm1se;
%     end
% end
% if b>1
% bc1size=c1sizes(b-1);
% else
% bc1size = 0;
% end
% 
% segnet.bc1size(size(segnet.bc1size,1)+1,a)=bc1size;
% sseg.img(cell2mat(cnc1.PixelIdxList(c1size<nanmean(segnet.bc1size(:,a)))'))=1;
% 
% 
% [cnc0]=bwconncomp(uint8(sseg.img),18);
% c0size=cellfun('length',cnc0.PixelIdxList);
% nimg = sseg.img;
% c0sizes = unique(sort(c0size));
% m0se = wjn_mse(nimg(:)',out.y(a,:));
% for b = 1:length(c0sizes)
%     nimg(cell2mat(cnc0.PixelIdxList(c0size<c0sizes(b))'))=0;
%     cm0se = wjn_mse(nimg(:)',out.y(a,:));
%     if cm0se>m0se
%         break
%     else
%         m0se = cm0se;
%     end
% end
% if b>1
%     bc0size=c0sizes(b-1);
% else
%     bc0size = 0;
% end
% segnet.bc0size(size(segnet.bc0size,1)+1,a)=bc0size;
% sseg.img(cell2mat(cnc0.PixelIdxList(c0size<nanmean(segnet.bc0size(:,a)))'))=0;
% sseg.fname = ['cleaned_synthetic_' segs{a} '.nii'];
% ea_write_nii(sseg);
% 
% end
segnet.shorten = shorten;
segnet.ndata = ndata;

out.ny(ts,:) = out.ny;
out.ny(6,:) = ~in;

for a = 1:6
    dummy.img(:) = out.ny(a,:);
    dummy.fname = ['c' num2str(a) '.nii'];
    ea_write_nii(dummy);
    spm_smooth(dummy.fname,['s' dummy.fname],[4 4 4]);
    sfiles{a} = ['s' dummy.fname];
end

clear matlabbatch
matlabbatch{1}.spm.util.cat.vols = sfiles;
matlabbatch{1}.spm.util.cat.name = 'stpm.nii';
matlabbatch{1}.spm.util.cat.dtype = 4;
spm_jobman('run',matlabbatch);

clear matlabbatch
matlabbatch{1}.spm.tools.cat.estwrite.data = {'INV1.nii,1'};
matlabbatch{1}.spm.tools.cat.estwrite.nproc = 2;
matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {'stpm.nii,1'};
matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.estwrite.opts.samp = 3;
matlabbatch{1}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.NCstr = .5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.gcutstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.cleanupstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.WMHCstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.WMHC = 1;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.segmentation.restypes.best = [0.5 0.3];
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.darteltpm = {fullfile(spm('dir'),'\toolbox\cat12\templates_1.50mm\Template_1_IXI555_MNI152.nii')};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shootingtpm = {fullfile(spm('dir'),'\toolbox\cat12\templates_1.50mm\Template_0_IXI555_MNI152_GS.nii')};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.regstr = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.surface.pbtres = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.surface.scale_cortex = 0.7;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.surface.add_parahipp = 0.1;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.surface.close_parahipp = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.admin.ignoreErrors = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.admin.verb = 2;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.admin.print = 2;
matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.hammers = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.cobra = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.ibsr = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.aal = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.mori = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.anatomy = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.mod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.mod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.label.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.label.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.label.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.las.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.las.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.las.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.jacobian.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [0 0];
spm_jobman('run',matlabbatch);