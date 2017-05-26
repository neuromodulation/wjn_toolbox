function [tf,t,f]=wjn_disp_nii(filename,timewindow,freqwindow,plotthis)

nii = wjn_read_nii(filename);
tf = nii.img;

if ~exist('freqwindow','var')

    for a =1:nii.dim(1)
        x = [a 1 1 1]*nii.mat;
        f(a) = x(1);
    end
else 
    f = linspace(freqwindow(1),freqwindow(2),nii.dim(1));
end

if ~exist('timewindow','var')
    offset = [1 1 1 1]*nii.mat;
    offset = offset(4);
    for a =1:nii.dim(2)
        x = [1 a 1 1]*nii.mat;
        t(a) = x(2)+offset;
    end
else
     t = linspace(timewindow(1),timewindow(2),nii.dim(2));
end

tf = squeeze(nii.img);

if plotthis
    figure
    imagesc(t,f,interp2(interp2(tf)));
    axis xy
    TFaxes
end






