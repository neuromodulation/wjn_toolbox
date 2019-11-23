function [arp,crp,drp,t,rt,mt,mv,me] = wjn_eeg_vm_erp_results
%%
clear
root = wjn_vm_list('eegroot');
cd(root);
patlist = wjn_vm_list('list');
chans = { 'M1l'    'M1r'    'SMA'    'preSMA'    'IFGr'    'IFGl','Fz','C3','C4','Cz'};
% chans = { 'M1l'    'M1r'    'SMA'    'preSMA'    'IFGr'    'IFGl'};
for a = 1:size(patlist(:,1))
            [dir,fname,ext]=fileparts(wjn_vm_list(patlist{a,1},'fullfile'));
            D=wjn_sl(fullfile(dir,[fname ext]));
            rchans = D.chanlabels;
            rchans(ci(chans,rchans,1)) = [];
            D=wjn_remove_channels(D.fullfile,rchans);
            D=wjn_average(D.fullfile,1);
            rt(a,:) = D.mrt;
            mv(a,:) = D.mmax_v;
            mt(a,:) = D.mmt;
            me(a,:) = D.mmerr;
            arp(a,:,:) = wjn_smoothn(D(ci(chans,D.chanlabels),:,ci('move_aut',D.conditions)),80);
            crp(a,:,:) = wjn_smoothn(D(ci(chans,D.chanlabels),:,ci('move_con',D.conditions)),80);
            drp(a,:,:) = crp(a,:,:)-arp(a,:,:);
            t = D.time;
end
c = D.chanlabels(ci(chans,D.chanlabels));
for a = 1:6
    figure
    mypower(t,squeeze(arp(:,a,:)),'b')
    hold on
    mypower(t,squeeze(crp(:,a,:)),'r')
    dt = squeeze(drp(:,a,:));
    for b = 1:length(dt)
        pt(b) = wjn_ppt(dt(:,b));
    end
    sigbar(t,pt<=0.05)
    xlim([-.5 .5])
    title(chans{a})
end
    