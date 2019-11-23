function wjn_eeg_vm_plot_tf_sensor(filename)
D=wjn_sl(filename)
fname = D.fname;


chs = {'F3','Fz','F4','C3','Cz','C4','P3','Pz','P4'};
conds = {'move_aut','move_con'};
freqranges = [3 7;7 13;13 20;20 30;30 45; 45 80];
for b = 1:length(conds)

    cond = conds{b};
    figure
    for a  =1:length(chs)
        subplot(3,3,a)
        wjn_plot_tf(D,chs{a},cond)
        if strcmp(fname(1:3),'mtf')
            caxis([0 7])
        else
            caxis([-50 75])
        end
        title(chs{a})
    end

figone(17,18)
fname = D.fname;
myprint(['sensor_' cond '_' fname(1:end-4)])
% % 
% freq = D.fttimelock;
% freq.powspctrm = freq.powspctrm(ci(cond,D.conditions),:,:,:);
% cfg = [];
% cfg.xlim = [-0.4:.2:.4];
% for c = 1:size(freqranges,1)
%     cfg.ylim = freqranges(c,:);
%     cfg.elec = D.sensors('eeg');
%     ft_topoplotTFR(cfg,freq)
%     drawnow
%     myprint(['topoTFR_' cond '_' fname(1:end-4)])
% end

end