close all
clear all
root = 'E:\Dropbox\Motorneuroscience\vm_eeg\';
cd(root)

[files,dirs] = ffind('scrmtf_*tablet*600.mat',1,1);

for a =1:length(files)
    D=wjn_sl(fullfile(dirs{a},files{a}));
    D=wjn_tf_smooth(D.fullfile,8,250);
%     tfc = wjn_tf_get_data(D,'IFGr','go_con');
%     tfa = wjn_tf_get_data(D,'IFGr','go_aut');
%     d(a,:,:) = tfc-tfa;
    atf(a,:,:) = wjn_tf_get_data(D,[],'move_aut');
    ctf(a,:,:) = wjn_tf_get_data(D,[],'move_con');
end

figure
subplot(1,3,1)
wjn_contourf(D.time,D.frequencies,atf,10)
xlim([-3 3])
ylim([2 90])
caxis([-25 25])
TFaxes
subplot(1,3,2)
wjn_contourf(D.time,D.frequencies,ctf,10)
xlim([-3 3])
ylim([2 90])
caxis([-25 25])
TFaxes
subplot(1,3,3)
wjn_contourf(D.time,D.frequencies,ctf-atf,10)
xlim([-3 3])
ylim([2 90])
% caxis([-50 50])
TFaxes


%%
figure
wjn_contourf(D.time,D.frequencies,d,10)
xlim([-2 2])
ylim([2 90])
TFaxes
% caxis([-200 200])
% 