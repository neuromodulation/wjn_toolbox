

clear all
close all
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
cd(root)
load ../clinical2
load ../healthy
files = ffind('r*.mat');

for nfile = 1:length(files)
    load(files{nfile},'r','order','dt')
    
    str=stringsplit(files{nfile},'_');
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
    if ~isempty(id);
    for a=1:length(val);
        if ~strcmp(val{a},'conds')
        results.(disease).(val{a})(id,:,stim+1)=r.(val{a});
        results.(disease).(['d' val{a}])(id,:,stim+1) = [diff(r.(val{a})(1:2)) diff(r.(val{a})(3:4)) diff(r.(val{a})([5 7])) diff(r.(val{a})([6 8]))];
        results.(disease).order(id,stim+1) = order;
        results.(disease).updrs(id,stim+1)=updrs;
        end
    end
    end
end
    
save final_results results

%%
close all
val = fieldnames(results.PD);
val = {'rt','mv','ang','drt','dmv','dang'};
yl = {'Reaction time [ms]','Movement time [ms]','Angular error [°]',...
    '\DELTA reaction time [ms]','\DELTA movement time [ms]','\DELTA angular error [°]'};
for a = 1:length(val);
    figure,
    if length(size(squeeze(results.PD.(val{a}))))==3
    offdata = squeeze(results.PD.(val{a})(:,1:4,1));
    ondata = squeeze(results.PD.(val{a})(:,1:4,2));
    hcdata = squeeze(results.healthy.(val{a})(:,1:4));
    else
    offdata = squeeze(results.PD.(val{a})(:,1));
    ondata = squeeze(results.PD.(val{a})(:,2));
    hcdata = squeeze(results.healthy.(val{a})(:,1));
    end
    

    
    p=[]
%     if a~=3
    for b=1:4
        p(b) = permTest(1000,offdata(:,b)-ondata(:,b),zeros(size(ondata(:,b))));
    end
%     end
    
    boff=mybar(offdata,[],0.75:1:size(offdata,2)-.25)
    hold on
    bon=mybar(ondata,[],1:1:size(ondata,2))
    bhc=mybar(hcdata,[],1.25:1:size(ondata,2)+.25)
    yl = get(gca,'ylim')
    for b=1:length(p);
        if p(b)<=fdr(p,.05)
            sigbracket(num2str(p(b),2),[b-.25 b],yl(2),8)
        end
    end
    xlim([0 size(ondata,2)+1])
    set(boff,'barwidth',.3)
    set(bon,'barwidth',.3)
    set(bhc,'barwidth',.3)
    title(val{a})
end

%% results for henning
close all
% val = fieldnames(results.PD);
val = {'rt','mv','ang','drt','dmv','dang'};
yl = {'Reaction time [ms]','Movement time [ms]','Angular error [°]','Velocity [px/ms]',...
    '\Delta reaction time [ms]','\Delta movement time [ms]','\Delta angular error [°]','\Delta velocity [px/ms]'};
xl = {'AUT','CON', 'AUT','CON','CON-AUT','CON-AUT'};

tt = {{'Reaction Time','cue -> movement'},{'Movement Time','movement -> target'},{'Angular error [°]','vs. optimal line'},{'Velocity [px/ms]','Maximum'},...
    {'\Delta Reaction Time','Controlled - Automatic'},{'\Delta Movement Time','Controlled - Automatic'},{'\Delta Angular Error','Controlled - Automatic'},{'\Delta Velocity','Controlled - Automatic'}};
cmap = colorlover(5,1);
cc = {cmap([1 1 1 1],:),cmap([3 3 3 3],:),cmap([5 5 5 5],:)};


    figure,
for a = 1:length(val);
subplot(2,4,a)
    if strcmp(val{a}(1),'d');
        e = 2;
        xll=xl(5:6);
    else
        e=4;
        xll=xl(1:4);
    end
    offdata = squeeze(results.PD.(val{a})(:,1:e,1));
    ondata = squeeze(results.PD.(val{a})(:,1:e,2));
    hcdata = squeeze(results.healthy.(val{a})(:,1:e));

    

    
    clear poffon poffhc ponhc
%     if a~=3
    for b=1:e
        poffon(b) = permTest(1000,offdata(:,b)-ondata(:,b),zeros(size(ondata(:,b))));
        poffhc(b) = permTest(1000,offdata(:,b),hcdata(:,b));
        ponhc(b) = permTest(1000,ondata(:,b),hcdata(:,b));
    end
    
    [~,np] = fdr_bh([poffon poffhc ponhc],0.05);
    poffon = np(1:e);
    poffhc = np(e+1:2*e);
    ponhc = np(e*2+1:e*3);
    
%     end
    
    boff=mybar(offdata,cc{1},0.75:1:size(offdata,2)-.25)
    hold on
    bon=mybar(ondata,cc{2},1:1:size(ondata,2))
    bhc=mybar(hcdata,cc{3},1.25:1:size(ondata,2)+.25)
    yli = get(gca,'ylim')
    for b=1:length(poffon);
        if poffon(b)<=.05
            sigbracket(num2str(poffon(b),2),[b-.25 b],yli(2),8)
        end
        if poffhc(b)<=.05
            sigbracket(num2str(poffhc(b),2),[b-.25 b+.25],yli(2)*1.5,8)
        end
        if ponhc(b)<=.05
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
    title(tt{a})
    ylabel(yl{a})
    set(gca,'Xtick',1:e,'XTickLabel',xll,'XTickLabelRotation',45)
    xlabel('BLOCK1             BLOCK2')
    ylim([yli(1) yli(2)*1.7])
       
end
figone(18,37)
myprint('results4henning')
