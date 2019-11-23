function wjn_eeg_vm_compare_tf(filename)

D=wjn_sl(filename)

filename = D.fname;

for a=1:D.nchannels
    figure
    subplot(3,3,1)
    [~,tfa]=wjn_plot_tf(D,a,'go_aut');
    ca = get(gca,'clim');
    ylabel(D.chanlabels{a})
    title('GO Automatic')
    xlim([-3 3])
    subplot(3,3,2)
    [~,tfc]=wjn_plot_tf(D,a,'go_con');
    set(gca,'clim',ca)
    title('GO Controlled')
    xlim([-3 3])
    subplot(3,3,3)
    wjn_contourf(D.time,D.frequencies,tfc-tfa)
    title('\Delta GO Controlled - Automatic')
    xlim([-3 3])
%     figone(7,30)
    chan = D.chanlabels{a};
    
    subplot(3,3,4)
    [~,tfa]=wjn_plot_tf(D,a,'move_aut');
    ca = get(gca,'clim');
    ylabel(D.chanlabels{a})
    title('MOVE Automatic')
    xlim([-3 3])
    subplot(3,3,5)
    [~,tfc]=wjn_plot_tf(D,a,'move_con');
    set(gca,'clim',ca)
    title('MOVE Controlled')
    xlim([-3 3])
    subplot(3,3,6)
    wjn_contourf(D.time,D.frequencies,tfc-tfa)
    title('\Delta MOVE Controlled - Automatic')
    xlim([-3 3])
%     figone(7,30)
    chan = D.chanlabels{a};
    
    subplot(3,3,7)
    [~,tfa]=wjn_plot_tf(D,a,'stop_aut');
    ca = get(gca,'clim');
    ylabel(D.chanlabels{a})
    title('STOP Automatic')
    xlim([-3 3])
    subplot(3,3,8)
    [~,tfc]=wjn_plot_tf(D,a,'stop_con');
    set(gca,'clim',ca)
    title('STOP Controlled')
    xlim([-3 3])
    subplot(3,3,9)
    wjn_contourf(D.time,D.frequencies,tfc-tfa)
    title('\Delta STOP Controlled - Automatic')
    xlim([-3 3])
    figone(20,30)
    chan = D.chanlabels{a};
    
myprint([chan '_TF_' filename(1:end-4)])
end