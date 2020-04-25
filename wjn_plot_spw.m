function [mm,ti,p]=wjn_plot_spw(time,data,chanlabels,thresh)

if ~exist('plotit','var')
    plotit=1;
end

if ~exist('thresh','var')
    thresh=0;
end

data(data==0)=nan;
if size(time)==  [1,1]
    time = linspace(0,length(data)/time,length(data));
end

if ~exist('chanlabels','var')
    for a = 1:size(data,1)
        chanlabels{a} = ['chan' num2str(a)];
    end
end

for a = 1:size(data,1)
    zdata = wjn_zscore(data(a,:));
    [mp,ip]=findpeaks(zdata);
    [mn,in]=findpeaks(-zdata);
    irmp = mp<thresh;
    mp(irmp)=[];ip(irmp)=[];
    irmn = mn<thresh;
    mn(irmn)=[];in(irmn)=[];
    if plotit
        p(a)=plot(time,zdata./10+a);
    end
    i = [in ip];
    m = [-mn mp];
    [~,mi]=max(abs(m));
    mm(a)=m(mi);
    ti(a) = time(i(mi));
    if plotit
        for d = 1:length(i)
            t=text(time(i(d)),zdata(i(d))./10+a,{num2str(round(time(i(d)))); num2str(round(m(d)*10)/10)},'FontSize',6);
            if d==mi
                set(t,'color','r')
            end
        end
        
        text(time(end),a,{[' ' num2str(round(ti(a))) ' ms'];[' ' num2str(round(mm(a)*10)/10) ' Z']},'FontSize',8);
        hold on
    end
end
if plotit
    set(gca,'YTick',[1:size(data,1)],'YTickLabel',strrep(chanlabels,'_',' '),'YTickLabelRotation',45);
    xlim([time(1) time(end)]);
    ylim([0 length(chanlabels)+1]);
    xlabel('Time [ms]')
    hold on
    yl = [(1000./-[4 8 12 20 35])./2 (1000./[4 8 12 20 35])./2];
    yll = {'\theta','\alpha','low \beta','high \beta','\gamma'};
    for a =1:length(yl)
        plot([yl(a) yl(a)],[0 length(chanlabels)+1],'color',[.5 .5 .5],'linestyle','--');
        if a<=5
            text(yl(a),0.5,yll{a},'Fontsize',5)
        end
        
    end
else
    p=[];
end

