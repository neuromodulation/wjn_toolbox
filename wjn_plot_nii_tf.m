function [tf,t,f]=wjn_plot_nii_tf(filename,plotthis)

nii = wjn_read_nii(filename);
tf = nii.img;


for a =1:nii.dim(1)
    x = [a 1 1 1]*nii.mat;
    f(a) = x(1);
end


offset = [1 1 1 1]*nii.mat;
offset = offset(4);
for a =1:nii.dim(2)
    x = [1 a 1 1]*nii.mat;
    t(a) = x(2)+offset;
end


tf = squeeze(nii.img);

if plotthis
    figure
    imagesc(t,f,interp2(interp2(tf)));
    axis xy
    TFaxes
end






