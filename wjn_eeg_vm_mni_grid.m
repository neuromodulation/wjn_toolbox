function [mni,names] = wjn_eeg_vm_mni_grid

% mni = [];
% 


mni = [37 -25 64;-37 -25 62; -2 -10 59; 2 30 48;  42 26 14; -42 26 14; ...
    50 -25 45;30 -25 65; 0 -25 65;-30 -25 65;-50 -25 45;...
    50 5 35;30 5 55; 0 5 55;-30 5 55;-50 5 35;...
    43 35 25;30 35 45; 0 35 45;-30 35 45;-43 35 25];
mni(:,3) = mni(:,3)+5;
names = {'M1r','M1l','SMA','preSMA','IFGr','IFGl'};

for n = 1:length(mni)-6
    names{end+1} = num2str(n);
end


%     15 55 15 ; -15 55 15];
% close all
% wjn_plot_lead_scene
% hold on
% for a = 1:size(mni,1);
%     plot3(mni(a,1),mni(a,2),mni(a,3),'Marker','o','MarkerFaceColor','r','LineStyle','none')
% end
% x - x - x - x - x
% x - x - x - x - x
% x - x - SMA - x - x
