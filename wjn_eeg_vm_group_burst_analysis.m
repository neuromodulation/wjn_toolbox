% function wjn_eeg_vm_group_burst_analysis(p)
% spm12
clear
l = wjn_vm_list('list');

fhz = [13 20];
n=1;
for a = 1:size(l,1)
%     try 
%         n=n+1;
        cd(wjn_vm_list(l{a,1},'eegroot'))
        filename=wjn_vm_list(l{a,1},'fullfile');
        D=wjn_sl(filename);
        rt = D.rt;
        [rt,i]=sort(rt);
        m=wjn_eeg_burst_analysis(filename,fhz,[-5 5],'Cz','move','brown',0);
        mcon{a}=wjn_eeg_burst_analysis(filename,fhz,[-5 5],{'Cz','Fz'},'move_con','brown',0);
        maut{a}=wjn_eeg_burst_analysis(filename,fhz,[-5 5],{'Cz','Fz'},'move_aut','brown',0);
%         i = ci('SMA',mcon.channels,1);
       n=n+1;
%     end
end


for a = 1:length(mcon)
        con(a,:,:) = mcon{a}.ratehist;
        aut(a,:,:) = maut{a}.ratehist;
        dcon(a,:,:) = mcon{a}.durhist;
        daut(a,:,:) = maut{a}.durhist;
        acon(a,:,:) = mcon{a}.amphist;
        aaut(a,:,:) = maut{a}.amphist;
end
%     figure
%     plot(mcon.timebins,mcon.ratehist(i,:))
%     hold on
%     plot(mcon.timebins,maut.ratehist(i,:))
cc= colorlover(6);
figure
for a =1:size(con,2)
    
    subplot(1,size(con,2),a)
    mypower(mcon{1}.timebins,squeeze(nanmean(con(:,a,:),2)),cc(4,:))
    hold on
    mypower(mcon{1}.timebins,squeeze(nanmean(aut(:,a,:),2)),cc(5,:))
    title(mcon{1}.channels{a})
    xlim([-3 .5])
    
    for b = 1:length(mcon{1}.timebins)
        p(a,b) = wjn_ppt(squeeze(nanmean(con(:,a,b),2)),squeeze(nanmean(aut(:,a,b),2)));
    end
    sigbar(mcon{1}.timebins,p(a,:)<=0.05)
end

figone(7,30)