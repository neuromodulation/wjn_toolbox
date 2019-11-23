clc
clear all
close all
load mbursts

figure
for a = 1:length(unique(lobeid))
    subplot(1,length(unique(lobeid)),a)
    wjn_contourf(t,f,mbursts(lobeid==a,2,:,:),2000);
    title(MT.Lobe{find(a==MT.lobeid,1)})
    caxis([0 1.5])
    TFaxes
end

%%



clc
clear all
close all
load mbursts
cc(1,:)=[2,157,175]./255;
cc(2,:)=[229,213,153]./255;
cc(3,:) = [227,37,81]./255;
MT.lobeid(MT.lobeid==9)=5;
franges = {'full_delta','full_theta','full_alpha','low_beta','high_beta','full_gamma'};
freqnames = {'\Delta','\Theta','\alpha','low \beta','high \beta','\gamma'};

measures = {'Burst amplitude [%]','Burst probability [N/s]','Burst duration [s]','Average power [%]'};
% ii = i1(1):size(MT,2);
[~,i]=sort(MT.Region);
mt = MT(i,:);
figure
n=0;
for c = 1:length(franges)
    for a =1:length(measures)
        
        n=n+1;
        ii = ci(strcat(franges{c},{'_meanamp','_burstfreq','_timewidth','_mean_power'}),MT.Properties.VariableNames);
        subplot(length(franges),length(measures),n)
        cname = stringsplit(mt.Properties.VariableNames{ii(a)},'_');
        y = table2array(mt(:,ii(a)));
        y(isnan(y))=0;
        % figure
        % wjn_boxplot(mt.Lobe,y)
        rn = unique(mt.lobeid);
        clear T S rname
        pp = ones(1,length(rn));
        pn = ones(1,length(rn));
        for b = 1:length(rn)
            T{b}= y(mt.lobeid==rn(b));
            S = y(mt.lobeid~=rn(b));
            if nanmean(T{b})>nanmean(S)
                pp(b) = wjn_pt(S',T{b}');
            else
                pn(b) = wjn_pt(S',T{b}');
            end
            rname{b} = mt.Lobe{find(mt.lobeid==rn(b),1)};
        end
        
        ipp = find(pp<=0.05);
        
        ipn = find(pn<=0.05);
        hold on
        b=mybar(T,cc(2,:),rn,.6);
        set(b(ipn),'FaceColor',cc(1,:))
        set(b(ipp),'FaceColor',cc(3,:))
        set(gca,'XTick',rn,'XTickLabel',rname,'XTickLabelRotation',45,'FontSize',7);
        title(freqnames{c});
        xlim([min(rn)-1 max(rn)+1])
        ylim(gca,'auto')
        %     ylim([0 prctile(T{b},99)])
        figone(12,15)
        ylabel(measures{a});
        % hold on
        % h=gscatter((mt.Region-min(mt.Region))+1,y,mt.Patient);,legend off
        % set(h(:),'MarkerSize',3);
        % drawnow
    end
end
figone(22,18)
myprint('Lobe_differentiation')
%%
clc
clear all
close all
load mbursts
franges = {'full_delta','full_theta','full_alpha','low_beta','high_beta','full_gamma'};
freqnames = {'\Delta','\Theta','\alpha','low \beta','high \beta','\gamma'};
fnames = {'delta','theta','alpha','low_beta','high_beta','gamma'};
measures = {'Amplitude [%]','Probability [N/s]','Duration [s]','Power [%]'};
cc(1,:)=[2,157,175]./255;
cc(2,:)=[229,213,153]./255;
cc(3,:) = [227,37,81]./255;
[~,i]=sort(MT.Region);
mt = MT(i,:);
for c = 1:length(franges)
    figure
%     n=1;
    for a =1:length(measures)
%         n=n+1
     subplot(1,2+length(measures),a+2)

        ii = ci(strcat(franges{c},{'_meanamp','_burstfreq','_timewidth','_mean_power'}),MT.Properties.VariableNames);
        
       
    %     subplot(1,length(ii),a)
    cname = stringsplit(mt.Properties.VariableNames{ii(a)},'_');
    y = table2array(mt(:,ii(a)));
    % y(isnan(y))=0;
    % figure
    % wjn_boxplot(mt.RegionName,y)
    rn = unique(mt.Region);
    clear T S rname
    pp=ones(1,length(rn));
    pn=ones(1,length(rn));
    for b = 1:length(rn)
        T{b}= y(mt.Region==rn(b));
            S = y(mt.Region~=rn(b));
            if nanmean(T{b})>nanmean(S)
                pp(b) = wjn_pt(S',T{b}');
            else
                pn(b) = wjn_pt(S',T{b}');
            end
        rname{b} = mt.RegionName{find(mt.Region==rn(b),1)};
    end
    
    ipp = find(pp<=0.05);
    ipn = find(pn<=0.05);
    hold on
    % keyboard
    b=mybarh(T,cc(2,:),rn,.3);
    set(b(ipp),'FaceColor',cc(3,:))
    set(b(ipn),'FaceColor',cc(1,:))
    if a==1
    set(gca,'YTick',rn,'YTickLabel',rname,'FontSize',7);
    else
        set(gca,'YTick',[],'FontSize',7)
    end
    title(freqnames{c});
    ylim([min(rn)-1 max(rn)+1])
    xlim(gca,'auto')
    figone(12,15)
    xlabel(measures{a});
    % hold on
    % h=gscatter((mt.Region-min(mt.Region))+1,y,mt.Patient);,legend off
    % set(h(:),'MarkerSize',3);
%     drawnow
    end
    myprint(['region_' fnames{c}])
end


%% CORTEX Electrode map
clc
clear all
close all
load mbursts
load(fullfile(leadt,'CortexHiRes.mat'),'Vertices_rh','Faces_rh');
cortex.vert = Vertices_rh;
cortex.tri = Faces_rh;
wjn_plot_freesurfer_electrodes(cortex,[MT.x MT.y MT.z])
set(gcf,'color','k','InvertHardcopy','off')
figone(15,15)
view(90,0)
myprint('electrode_map_lateral')
view(-90,0)
myprint('electrode_map_medial')

%% HEATMAP
clc
clear all
close all
load mbursts
franges = {'full_delta','full_theta','full_alpha','low_beta','high_beta','full_gamma'};
freqnames = {'delta','theta','alpha','low_beta','high_beta','gamma'};
measures = {'amplitude','probability','duration','power'};
for a = 1:length(franges)
        ii = ci(strcat(franges{a},{'_meanamp','_burstfreq','_timewidth','_mean_power'}),MT.Properties.VariableNames);
        for  b = 1:length(ii)
            wjn_heatmap([freqnames{a} '_' measures{b} '.nii'],[MT.x MT.y MT.z],MT.(MT.Properties.VariableNames{ii(b)}))
        end
end


%% Linear Models
clc
clear 
close all
load mbursts
MT.lobeid(MT.lobeid==9)=5;
Y = MT.full_alpha_mean_power;
i = ci({'meanamp','burstfreq','timewidth'},MT.Properties.VariableNames(26:end));

% i = ci({'mean_po<wer'},MT.Properties.VariableNames(26:end));
X = table2array(MT(:,25+i));
clear zX
for a=1:size(X,2)
    zX(:,a) = wjn_zscore(X(:,a));
end
lm=fitlm(zX,Y,'linear','PredictorVars',MT.Properties.VariableNames(i+25))

CLASS = [zX MT.lobeid];
% X=MT(:,25+i);
inan=logical(sum(isnan(zX),2));
zX(inan,:)=[];
X = array2table(zX);
X.Properties.VariableNames=strrep(MT.Properties.VariableNames(25+i),'_','');
T=MT.lobeid==4;
T(inan)=[];
wjn_nn_classifier_2(X,T,0,25,{0},0,0,0,[100])

%% fMRI connectivity
clc
clear all
load mbursts

for a = 1626:length(mbursts)
    xyz=[MT.x(a) MT.y(a) MT.z(a)];
    if ~any(isnan(xyz))
%         try
        nfname = ['ROI_' MT.ChannelName{a} '_' num2str(MT.Patient(a)) '_' strrep(num2str(MT.x(a)),'.','-') '_' strrep(num2str(MT.y(a)),'.','-') '_' strrep(num2str(MT.z(a)),'.','-') '_' MT.ElectrodeType(a) '.nii'];
        nii=wjn_spherical_roi(nfname,xyz,10,fullfile(leadt,'single_subj_T1.nii'));
        wjn_crop_nii(nii);
%         catch
            disp(a)
%         end
    end
end


