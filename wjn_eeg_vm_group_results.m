function [atf,ctf,dtf,t,f,c,rt,mt,mv,me]=wjn_eeg_vm_group_results(p,res,clims,xlims,ylims)

% keyboard

if ~exist('clims','var')
    clims = [-50 50];
end

if ~exist('xlims','var')
    xlims = [-1 1];
end

if ~exist('ylims','var')
    ylims = [1 99];
end

root = wjn_vm_list('eegroot');
cd(root);
% debug
D=wjn_sl(wjn_vm_list(p{1},'fullfile',res));
conds = D.condlist;
if ~(strcmp(conds{1}(1),'R') && strcmp(conds{2}(1),'P'))

    for a = 1:length(p)
        [dir,fname,ext]=fileparts(wjn_vm_list(p{a},'fullfile',res));
        try
            D=spm_eeg_load(fullfile(dir,[fname ext]));
            D=wjn_tf_smooth(D.fullfile,6,250);
        catch
            keyboard
    end
%             str = stringsplit(fname,'_Brrae');
%             fname = [str{1} '_Brraefff' str{2}];
%             D=wjn_sl(fullfile(dir,[fname ext]));
%         end
            atf(a,:,:,:) = D(:,:,:,ci('move_aut',D.conditions));
        ctf(a,:,:,:) = D(:,:,:,ci('move_con',D.conditions));
        rt(a,:)=D.mrt;
        mt(a,:)=D.mmt;
        mv(a,:)=D.mmax_v;
        me(a,:)=D.mmerr;
    end
    dtf = ctf-atf;


    cmap = colorlover(1);
    cmap = cmap([1;3;5;1;3;5;1;3;5;1;3;5;1;3;5;1;3;5;1;3;5;1;3;5],:);
    figure
    b=mybar([rt mt  mv.*10  me.*10],cmap,[1:3 5:7 9:11 13:15]);
    l = {'AUT','CON','\Delta C-A'};
    set(gca,'XTick',[2 6 10 14],'XTickLabel',{'RT','MT','MV','ME'})
    legend(b(1:3),{'Automatic','Controlled','\Delta CON-AUT'},'location','southeastoutside')
    figone(6,20)


    for  a=1:D.nchannels
        figure
        subplot(1,3,1)
        wjn_contourf(D.time,D.frequencies,atf(:,a,:,:),10)
        TFaxes
        caxis(clims)
        xlim(xlims);
        ylim(ylims);
        ylabel(D.chanlabels{a});
        title('Automatic');
        subplot(1,3,2)
        wjn_contourf(D.time,D.frequencies,ctf(:,a,:,:),10)
        TFaxes;
        caxis(clims)
        xlim(xlims);
        ylim(ylims);
        title('Controlled');
        subplot(1,3,3)
        wjn_contourf(D.time,D.frequencies,dtf(:,a,:,:),10)
        TFaxes;
        title('\Delta Con-Aut')
        caxis(clims)
        xlim(xlims);
        ylim(ylims);
        figone(7,35)
    end
else
    for a = 1:length(p)
        D=wjn_sl(wjn_vm_list(p{a},'fullfile',res));
        tf(a,:,:,:) = D(:,:,:,1);
        ptf(a,:,:,:) = D(:,:,:,2)<=.05;
        str = stringsplit(res,'rp');
        try 
            d{a} = D.(str{1});
        catch
            d{a} = D.(['max_' str{1}]);
        end

    end
    
    figure
    for a=1:length(p)
        plot(sort(d{a}),'linewidth',2);
        hold on
        N{a} = num2str(a);
    end
    figone(7);
    legend(N)
    ylabel(str{1});
    
    for  a=1:D.nchannels
        figure
        subplot(1,2,1)
        wjn_contourf(D.time,D.frequencies,tf(:,a,:,:),10);
        TFaxes
        caxis([-.25 .25])
        xlim(xlims)
        ylim(ylims)
        title([str{1} ' R ' D.chanlabels{a}])
        subplot(1,2,2)
        wjn_contourf(D.time,D.frequencies,ptf(:,a,:,:),10);
        TFaxes
        title('P<.05')
%         caxis([-.5 .5])
        xlim(xlims)
        ylim(ylims)
        figone(7,15)
    end

end

t = D.time;
f = D.frequencies;
c = D.chanlabels;