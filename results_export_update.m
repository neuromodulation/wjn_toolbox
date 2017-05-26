
clear 
close 
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
cd(root)
load ../clinical2
load ../healthy
fid = 'r*.mat';
files = ffind(fid);
print = 0;
for nfile = 1:length(files)
%     results = [];ot =  [];
        load(files{nfile},'r','order','dt','results','names','rt','mv','pt','v')
    if strcmp(fid(1:2),'ot');
    str=stringsplit(files{nfile}(2:end),'_');
    else
        str=stringsplit(files{nfile},'_');
    end
    disease = str{1}(2:end);
    if strcmp(disease,'PD')
        id = str2double(str{3}(4:5));
        id = clinical(find(clinical(:,2)==id),1);
        stim= str2double(str{4}(2));
        updrs = clinical(id,7-stim);
    else
        id = str2double(str{2}(8:9));
        id = healthy(find(healthy(:,2)==id),1);
        stim = 0;
        updrs = nan;
    end
    
    val = fieldnames(r);
    data=[];
    
    ot = find(pt>(mean(pt)+2*std(pt)))%10000;%
%       ot = find_outliers_Thompson(mv,0.001,'median',0);
%     nresults = results;
    results(ot,:) = [];
    val{ci('merror',val)} = 'MERR';
    if ~isempty(id) ;
    for a=1:length(val);
        if ~strcmp(val{a},'conds')
            i = ci(val{a},names);
            if strcmp(val{a},'v')
                i = 9;
            elseif strcmp(val{a},'sbi')
                i = 13;
            end
            b1a = find(results(:,2)==1 & results(:,3)==1);
            b1c = find(results(:,2)==1 & results(:,3)==2);
            b2a = find(results(:,2)==2 & results(:,3)==1);
            b2c = find(results(:,2)==2 & results(:,3)==2);
            b2s = find(results(:,4)==2);
            b2n = find(results(:,4)==1);
            b2sa = find(results(:,4)==2 & results(:,3)==1);
            b2sc = find(results(:,4)==2 & results(:,3)==2);
            b2na = find(results(:,4)==1 & results(:,3)==1);        
            b2nc = find(results(:,4)==1 & results(:,3)==2); 
            blist = {'b1a','b1c','b2a','b2c','b2s','b2n','b2sa','b2sc','b2na','b2nc'};
            dlist = {'b1ac','b2ac','b2sn','b2sasc','b2nanc','b2sana','b2scnc'};
            for b = 1:length(blist);
                nd = eval(['results(' blist{b} ',i)']);
%                 ot = find_outliers_Thompson(nd,0.05,'median',0);
%                 nd(ot) = [];
                nd = nanmean(nd);
                data(b) = nanmean(nd);
            end
            ddata=[diff(data(1:2)) diff(data(3:4)) diff(data(5:6)) diff(data(7:8)) diff(data(9:10)) diff(data([7 9])) diff(data([8 10]))];
        res.(disease).(val{a})(id,:,stim+1)=data;
        res.(disease).(['d' val{a}])(id,:,stim+1) = ddata;
        res.(disease).order(id,stim+1) = order;
        res.(disease).updrs(id,stim+1)=updrs;
        end
    end
    end
end
% res.conds  = r.conds;
res.dlist = dlist;
res.blist = blist;
res.val = val;
val = res.val;
%
close all
val = val(1:end-1);
% val = fieldnames(results.PD);
for a = 1:length(val);
    dval{a,1} = ['d' val{a}];
end

% all = [val;dval];

% yl = {'Reaction time [ms]','Movement time [ms]','Angular error [°]','Velocity'...
%     '\Delta reaction time [ms]','\Delta movement time [ms]','\Delta angular error [°]','\Delta Velocity'};
% xl = {'AUT','CON', 'SWITCH','NO SWITCH','CON-AUT','CON-AUT'};
% 

cmap = colorlover(5);
cc = {cmap(ones(1,10),:),cmap(ones(1,10)*3,:),cmap(ones(1,10)*5,:)};
yl = val;

% val = all;



%% all values
for a = 1:length(val);
        
    figure,

for b = 1:2;
    subplot(2,1,b)
if b==2;
xll  = dlist;
cval = ['d' val{a}];
    else
xll = blist;
cval = val{a};
end

    offdata = squeeze(res.PD.(cval)(:,:,1));
    ondata = squeeze(res.PD.(cval)(:,:,2));
    hcdata = squeeze(res.healthy.(cval)(:,:));

    

    
    clear poffon poffhc ponhc np
    for b=1:size(offdata,2)
        poffon(b) = wjn_pt(offdata(:,b)-ondata(:,b));
        poffhc(b) = wjn_pt(offdata(:,b)',hcdata(:,b)');
        ponhc(b) = wjn_pt(ondata(:,b)',hcdata(:,b)');
    end

    [~,cpoffon] = fdr_bh(poffon,0.05);
    [~,cpoffhc] = fdr_bh(poffhc,0.05);
    [~,cponhc] = fdr_bh(ponhc,0.05);

%     end
    
    boff=mybar(offdata,cc{1},0.75:1:size(offdata,2)-.25);
    hold on
    bon=mybar(ondata,cc{2},1:1:size(ondata,2));
    bhc=mybar(hcdata,cc{3},1.25:1:size(ondata,2)+.25);
    yli = get(gca,'ylim');
    for b=1:length(poffon);
        if poffon(b)<=.1
            sigbracket(num2str(poffon(b),2),[b-.25 b],yli(2),8)
        end
        if poffhc(b)<=.1
            sigbracket(num2str(poffhc(b),2),[b-.25 b+.25],yli(2)*1.5,8)
        end
        if ponhc(b)<=.1
            sigbracket(num2str(ponhc(b),2),[b b+.25],yli(2)*1.25,8)
        end
    end
    if a==1
        legend([boff(1),bon(1),bhc(1)],{'PD OFF','PD ON','HC'})
    end
    xlim([0 size(ondata,2)+1])
    set(boff,'barwidth',.3)
    set(bon,'barwidth',.3)
    set(bhc,'barwidth',.3)
    title(yl{a})
    ylabel(yl{a})
    set(gca,'Xtick',1:length(blist),'XTickLabel',xll,'XTickLabelRotation',45)
%     xlabel('BLOCK1             BLOCK2')
    ylim([yli(1) yli(2)*1.7])

end
    figone(20,30)   
    myprint(['2va_results_prelim_' val{a}])
end
% figone(18,42)


% save final_results
%% print only whole block results

vl = {'Reaction time [ms]','Movement time [ms]','Performance Time [ms]','Movement velocity [au]','Vector error [au]'};



for a = 1:5%length(val);
        
    figure,

for b = 1:2;
    subplot(2,1,b)
if b==2;
xll  = dlist;
cval = ['d' val{a}];
ii = 1:2;
else
        ii=1:4;
xll = blist;
cval = val{a};
end

    offdata = squeeze(res.PD.(cval)(:,ii,1));
    ondata = squeeze(res.PD.(cval)(:,ii,2));
    hcdata = squeeze(res.healthy.(cval)(:,ii));

    

    
    clear poffon poffhc ponhc np
    for b=1:size(offdata,2)
        poffon(b) = wjn_pt(offdata(:,b)-ondata(:,b));
        poffhc(b) = wjn_pt(offdata(:,b)',hcdata(:,b)');
        ponhc(b) = wjn_pt(ondata(:,b)',hcdata(:,b)');
    end

    [~,cpoffon] = fdr_bh(poffon,0.05);
    [~,cpoffhc] = fdr_bh(poffhc,0.05);
    [~,cponhc] = fdr_bh(ponhc,0.05);

%     end
    
    boff=mybar(offdata,cc{1},0.75:1:size(offdata,2)-.25);
    hold on
    bon=mybar(ondata,cc{2},1:1:size(ondata,2));
    bhc=mybar(hcdata,cc{3},1.25:1:size(ondata,2)+.25);
    yli = get(gca,'ylim');
    for b=1:length(poffon);
        if poffon(b)<=.1
            sigbracket(num2str(poffon(b),2),[b-.25 b],yli(2),8)
        end
        if poffhc(b)<=.1
            sigbracket(num2str(poffhc(b),2),[b-.25 b+.25],yli(2)*1.5,8)
        end
        if ponhc(b)<=.1
            sigbracket(num2str(ponhc(b),2),[b b+.25],yli(2)*1.25,8)
        end
    end
    if b==2
        legend([boff(1),bon(1),bhc(1)],{'PD OFF','PD ON','HC'},'location','SouthOutside')
    end
    xlim([0 size(ondata,2)+1])
    set(boff,'barwidth',.3)
    set(bon,'barwidth',.3)
    set(bhc,'barwidth',.3)
%     title(yl{a})
    ylabel(vl{a})
    set(gca,'Xtick',ii,'XTickLabel',xll(ii),'XTickLabelRotation',45)
%     xlabel('BLOCK1             BLOCK2')
    ylim([yli(1) yli(2)*1.9])

end
    figone(14,10)   
    myprint(['2va_results_prelim_' val{a} '_legend'])
end
% figone(18,42)


% save final_results
%%
close all
uoff = res.PD.updrs(:,1);
uon = res.PD.updrs(:,2);
du = uoff-uon;
ru = pctchange(uoff,uon);




val = fieldnames(res.PD);
c = colorlover(5);
cc = c([5,1,3,1,3,5,5,5],:);
coff = c(1,:);
con = c(3,:);
cm = c(5,:);
ttt = {'grand average','A1','C1','A2','C2'};
for a = 1:length(val);
    s = size(res.PD.(val{a}));
    if numel(s) ==3 && ~strcmp(val{a}(1),'d');
        figure
        for b  =1:5,
            if b==1
                i = 1:4;
            else
                i=b-1;
            end
                
            off = squeeze(nanmean(res.PD.(val{a})(:,i,1),2));
            on = squeeze(nanmean(res.PD.(val{a})(:,i,2),2));
            d = off-on;
            r = pctchange(off,on);
            subplot(1,5,b)
            wjn_corr_plot(ru,r,cc(b,:))
            title([val{a} ' ' ttt{b}])
                
        end
        figone(7,45)
        myprint(['NCORR_' val{a}])
    end
end
%%
cc = colorlover(5);
cc = cc([1,3,5],:);
ttt = {'grand average','AC1','AC2'};
for a = 1:length(val);
    s = size(res.PD.(val{a}));
    if numel(s) ==3 && strcmp(val{a}(1),'d');
        figure
        for b  =1:3,
            if b==1
                i = 1:2;
            else
                i=b-1;
            end
                
            off = squeeze(nanmean(res.PD.(val{a})(:,i,1),2));
            on = squeeze(nanmean(res.PD.(val{a})(:,i,2),2));
            d = off-on;
            r = pctchange(off,on);
            subplot(1,3,b)
            wjn_corr_plot(ru,r,cc(b,:))
            title([val{a} ' ' ttt{b}])
%             drawnow
            figone(7,20)
            
        end
        myprint(['DCORR_' val{a}])
    end
end

%% correlate reaction time difference with kinematic parameters

close all
val = fieldnames(res.PD);
c = colorlover(5);
coff = c(1,:);
con = c(3,:);
cm = c(5,:);
ttt = {'grand average','A1','C1','A2','C2'};
for a = 1:length(val);
    s = size(res.PD.(val{a}));
    if numel(s) ==3 && ~strcmp(val{a}(1),'d');

        figure
        for b  =1:5,
            if b==1
                i = 1:4;
            else
                i=b-1;
            end
                        rtoff = squeeze(nanmean(res.PD.drt(:,1,1),2));
        rton = squeeze(nanmean(res.PD.rt(:,1,2),2));
        ru = pctchange(rtoff,rton);
            off = squeeze(nanmean(res.PD.(val{a})(:,i,1),2));
            on = squeeze(nanmean(res.PD.(val{a})(:,i,2),2));
            d = off-on;
            r = pctchange(off,on);
            subplot(1,5,b)
            wjn_corr_plot(ru,r)
            title([val{a} ' ' ttt{b}])
            drawnow
        end
    end
end
%%
ttt = {'grand average','AC1','AC2'};
for a = 1:length(val);
    s = size(res.PD.(val{a}));
    if numel(s) ==3 && strcmp(val{a}(1),'d');
        figure
        for b  =1:3,
            if b==1
                i = 1:2;
            else
                i=b-1;
            end
                
            off = squeeze(nanmean(res.PD.(val{a})(:,i,1),2));
            on = squeeze(nanmean(res.PD.(val{a})(:,i,2),2));
            d = off-on;
            r = pctchange(off,on);
            subplot(1,3,b)
            wjn_corr_plot(ru,r)
            title([val{a} ' ' ttt{b}])
            drawnow
        end
    end
end

%%


for a = 1:length(val);
    s = size(res.PD.(val{a}));
    if numel(s) ==3;
        figure
        for b  =1:s(2),
            off = res.PD.(val{a})(:,b,1);
            on = res.PD.(val{a})(:,b,2);
            d = off-on;
            r = pctchange(off,on);
            subplot(3,s(2),b)
            [roff,poff,xoff]=wjn_corr_plot(uoff,off,coff);
            hold on
            [ron,pon,xon]=wjn_corr_plot(uon,on,con);
            [rm,pm,xm]=wjn_corr_plot(mean([uoff uon],2),mean([off on],2),cm);
            xlim([0 50]);
            if b == 1
                ylabel(val{a})
            end
            if strcmp(val{a}(1),'d')
                title(res.dlist{b})
            else
                title(res.blist{b})
            end
            legend([xoff,xon,xm],{['OFF ' corrtext(roff,poff)],['ON : ' corrtext(ron,pon)],['MEAN : ' corrtext(rm,pm)]},'location','southoutside')
            subplot(3,s(2),b+s(2))
            wjn_corr_plot(du,d);
            subplot(3,s(2),b+2*s(2))
            wjn_corr_plot(ru,r);

        end
%             suptitle(val{a})
            figone(25,80)
            myprint(['CORR_PLOT_' val{a}])
    end
    close 

end
