function [h] = new_figure(times);

if ~exist('times','var');
    times = 1;
end
h=figure('Position',[1 1 times*640 times*480],'PaperPosition',[1 1 times*640 times*480]);