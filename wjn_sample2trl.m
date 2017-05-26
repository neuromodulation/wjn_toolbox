function [trl]=wjn_sample2trl(i,timewindow,fs)
% function [trl]=wjn_sample2trl(i,[start end])
if size(i,1)<size(i,2)
    i=i';
end
trl = [i(:)+timewindow(1)*fs i(:)+timewindow(2)*fs ones(size(i))+timewindow(1)*fs];

