clear all
close all
root = fullfile(mdf,'visuomotor_tracking');
cd(root);
% patcode  = 'PD_STN_LFP01HR01-1-10-02-2014';
[filename,pathname,filterindex]=uigetfile({'*.mat','SPIKE MATLAB'});
[infoname,infopath] = uigetfile({'*.mat','results from paradigm'});

load(fullfile(infopath,infoname),'homingsize','alltargets','blocksize','name','age','closedmode','circlesize','circledistance','scalingfactor','fixationcrosssize','pretrialtime','posttrialtime','sex','handedness','updrs','medic','onoff','order');

pretrialtime = pretrialtime * 1000 + 2;
rpeakrange=200;
windowlength = 0.5; %in rpeakreange times 1/2
% circlesize = 75;
% circledistance = 150;
% scalingfactor = 1.5;
sc = circledistance*scalingfactor/5;
targetradius = circlesize/sc/2;
trialdef{51,1}='all good';
trialdef{54,1}='did not go back to zero';
trialdef{52,1}='turned around';
trialstyler = {'habitual','odd'};
%%
clear data
matname = filename(1:length(filename)-4);
load(fullfile(pathname,filename));
t = AO0.times;
dummy = zeros(size(t));
data.AO0 = AO0.values;
data.AO1 = AO1.values;
data.Xtarget = round(AO0.values*100)/100;
data.Ytarget = round(AO1.values*100)/100;
data.dXtarget = dummy;
data.dXtarget(2:end,1) =diff(data.Xtarget);
data.dYtarget = dummy;
data.dYtarget(2:end,1) = diff(data.Ytarget);
data.adYtarget = abs(data.dYtarget);
data.adXtarget = abs(data.dXtarget);
data.D0 = D0.values;
data.D1 = D1.values;
startstop = find(data.D0 == 1 & data.D1 == 1);
data.start = startstop(1);
data.stop = startstop(2);
green_trials = find(data.D0(data.start+1:data.stop-100))+data.start+1;
red_trials = find(data.D1(data.start+1:data.stop-100))+data.start+1;
% green_trials = find(data.D0(data.start+1:data.stop))+data.start+1;
% red_trials = find(data.D1(data.start+1:data.stop))+data.start+1;
[all_trials,ai] = sort([green_trials;red_trials])

n=1;ni=0;
for a = 1:length(all_trials);
%     if ismember(all_trials(a),green_trials) || ismember(all_trials(a),red_trials)
    ni = ni+1;
    
    if ni == 1;
    data.iatstart(n) = all_trials(a);
    elseif ni == 2;
    data.iattarget(n) = all_trials(a);
    elseif ni == 3;
    data.iatangle(n) = all_trials(a);
    ni=0;
    n = n+1;
    end
%     end
end
data.ntrials = numel(data.iatstart);
data.igtstart = data.iatstart(ismember(data.iatstart,green_trials));    
data.irtstart = data.iatstart(ismember(data.iatstart,red_trials)) ;   
data.igttarget = data.iattarget(ismember(data.iattarget,green_trials));    
data.irttarget = data.iattarget(ismember(data.iattarget,red_trials))  ;  
data.igtangle = data.iatangle(ismember(data.iatangle,green_trials));    
data.irtangle = data.iatangle(ismember(data.iatangle,red_trials))  ;  

for a = 1:length(data.iattarget);
    [maxxtarget,imtx] = max(abs(data.Xtarget(data.iattarget(a):data.iattarget(a)+30)));
    if maxxtarget<=2.29;
        imtx = 0;
    end    
%     data.iattarget(a)=data.iattarget(a)+imtx;
    if imtx
        data.atarget(a,1) = data.Xtarget(data.iattarget(a)+imtx-1);
        data.niattarget(a,1) = data.iattarget(a)+imtx-1;
    elseif ~imtx
        data.atarget(a,1) = 0;
        data.niattarget(a,1) = data.iattarget(a)+imtx-1
    end
        [maxytarget,imty] = max(abs(data.Ytarget(data.iattarget(a):data.iattarget(a)+30)));
    if maxytarget<=2.29;
        imty = 0;
    end    
%     data.iattarget(a)=data.iattarget(a)+imty;
    if imty
        data.atarget(a,2) = data.Ytarget(data.iattarget(a)+imty-1);
        data.niattarget(a,2) = data.iattarget(a)+imty-1;
    elseif ~imty
        data.atarget(a,2) = 0;
        data.niattarget(a,2) = data.iattarget(a)+imty-1;
    end
end
% figure;
% plot(t,data.Xtarget,t,data.Ytarget);hold on; 
% scatter(t(data.niattarget(:,1)),data.atarget(:,1))
% scatter(t(data.niattarget(:,2)),data.atarget(:,2))  
figure
% close all
for a=1:data.ntrials;
    data.xtrials{a} = data.AO0(data.iatstart(a):data.iattarget(a))';
    data.ytrials{a} = data.AO1(data.iatstart(a):data.iattarget(a))';
    data.ttrials{a} = t(data.iatstart(a):data.iattarget(a));

    data.sxtrials{a} = smooth(data.xtrials{a},50);
    data.sytrials{a} = smooth(data.ytrials{a},50);
    data.art(a) = find(abs(data.sxtrials{a})+abs(data.sytrials{a})>= (homingsize/2)/sc,1,'first')
    data.iart(a) = find(ismember(t,data.ttrials{a}(data.art(a))))
    
    plot3(data.ttrials{a},data.sxtrials{a},data.sytrials{a});hold on;
    plot3(data.ttrials{a}(data.art(a)),data.sxtrials{a}(data.art(a)),data.sytrials{a}(data.art(a)),'ro')
    xlabel('Time [s]');ylabel('X Axis');zlabel('Y Axis')
      hold off
    shg
end
%%
for a = 1:data.ntrials;
    figure
    next=0;chpop=1;   
    data.xtrials{a} = data.AO0(data.iatstart(a):data.iattarget(a))';
    data.ytrials{a} = data.AO1(data.iatstart(a):data.iattarget(a))';
    data.ttrials{a} = t(data.iatstart(a):data.iattarget(a));
    data.sxtrials{a} = smooth(data.xtrials{a},50);
    data.sytrials{a} = smooth(data.ytrials{a},50);
    data.art(a) = find(abs(data.sxtrials{a})+abs(data.sytrials{a})>= (homingsize)/sc,1,'first');
    data.iart(a) = find(ismember(t,data.ttrials{a}(data.art(a))))
    sx=data.ttrials{a}(data.art(a));
    subplot(3,1,1)
    plot(data.ttrials{a},data.sxtrials{a});hold on;
    ylim([-5 5]);
    xlim([data.ttrials{a}(1) data.ttrials{a}(end)])
    p1=plot([sx,sx],[-5 5],'color','r');
    plot([data.ttrials{a}(1) data.ttrials{a}(end)],[data.atarget(a,1)-targetradius data.atarget(a,1)-targetradius],'color','g')
    plot([data.ttrials{a}(1) data.ttrials{a}(end)],[data.atarget(a,1)+targetradius data.atarget(a,1)+targetradius],'color','g')
    
    subplot(3,1,2)
    plot(data.ttrials{a},data.sytrials{a});hold on;
    ylim([-5 5]);
    xlim([data.ttrials{a}(1) data.ttrials{a}(end)])
    p2=plot([sx,sx],[-5 5],'color','r')
    plot([data.ttrials{a}(1) data.ttrials{a}(end)],[data.atarget(a,2)+targetradius data.atarget(a,2)+targetradius],'color','g')
    plot([data.ttrials{a}(1) data.ttrials{a}(end)],[data.atarget(a,2)-targetradius data.atarget(a,2)-targetradius],'color','g')
    xlabel('Time [s]');ylabel('X Axis');zlabel('Y Axis')
    figone(20,30)
    hslide = uicontrol('Style', 'slider',...
        'Min',data.ttrials{a}(1),'Max',data.ttrials{a}(end),'Value',data.ttrials{a}(data.art(a)),...
        'Position', [20 20 400 40],'sliderstep',[min(diff(data.ttrials{a})) min(diff(data.ttrials{a}))],'Callback',...
        'set(p1,''XData'',[get(hslide,''Value'') get(hslide,''Value'')]),set(p2,''XData'',[get(hslide,''Value'') get(hslide,''Value'')])'); 
    sx=get(hslide,'Value')
    data.rt(a)=sx-data.ttrials{a}(1);
    data.mt(a)=data.ttrials{a}(end)-sx;
    data.pt(a) = data.ttrials{a}(end)-data.ttrials{a}(1);

pause
end
 
 
%     hpop = uicontrol('Style', 'popup',...
%        'String', 'Reaction Time|Error|Target',...
%        'Position', [20 20 40 50]);
%     chpop = get(hpop,'Value')
   
%     hold off
    
%     end
%     pause
% end

%%

%     %%
% Yloca = Ylocs +10;
% Xloca = Xlocs +10;
% 
% green_intertrial = Xlocs(find(data.Xtarget(Xloca) == 1))';
% red_intertrial = Xlocs(find(data.Xtarget(Xloca) == 2))';
% 
% green_trialstart = green_intertrial+pretrialtime;
% red_trialstart = red_intertrial+pretrialtime;
% 
% green_trial_Xtarget = data.Xtarget(green_trialstart + 100);
% green_trial_Ytarget = data.Ytarget(green_trialstart + 100);
% red_trial_Xtarget = data.Xtarget(red_trialstart + 100);
% red_trial_Ytarget = data.Ytarget(red_trialstart + 100);
% 
% clear AO0 Xtarget AO1 Ytarget
% % subplot(2,1,1);
% % plot(t,data.AO0,t,data.Xtarget,t,data.dXtarget,t(Xlocs),data.dXtarget(Xlocs),'r+');
% % subplot(2,1,2);
% % plot(t,data.AO1,t,data.Ytarget,t,data.dYtarget,t(Ylocs),data.dYtarget(Ylocs),'r+');
% 
% if ~isempty(green_trialstart) && isempty(red_trialstart) ;
%     display('green block');
%     trialstart = green_trialstart;
%     trialstyle = ones(size(trialstart));
%     trialXtarget = green_trial_Xtarget;
%     trialYtarget = green_trial_Ytarget;
% elseif ~isempty(red_trialstart) && isempty(green_trialstart);
%      display('red block');
%     trialstart = green_trialstart;
%     trialstyle = ones(size(trialstart))*2;
%     trialXtarget = green_trial_Xtarget;
%     trialYtarget = green_trial_Ytarget;
% elseif ~isempty(red_trialstart) && ~isempty(green_trialstart);
%     display('mixed block');
%     [trialstart,i] = sort([green_trialstart;red_trialstart]);
%     trialstyle = [ones(length(trialstart)/2,1);ones(length(trialstart)/2,1)*2];
%     trialstyle = trialstyle(i,1);
%     trialXtarget = [green_trial_Xtarget;red_trial_Xtarget];
%     trialXtarget = trialXtarget(i,1);
%     trialYtarget = [green_trial_Ytarget;red_trial_Ytarget];
%     trialYtarget = trialYtarget(i,1);
% end
% 
% alltarget = [trialYtarget,trialXtarget];
% alltarget = alltarget / circledistance * 5;
% targetnumber = zeros(size(trialYtarget));
% targetnumber(alltarget(:,1) == 0 & alltarget(:,2) > 0.1) = 1;
% targetnumber(alltarget(:,1) > 0.05 & alltarget(:,2) > 0.05) = 2;
% targetnumber(alltarget(:,1) > 0.1 & alltarget(:,2) == 0) = 3;
% targetnumber(alltarget(:,1) > 0.05 & alltarget(:,2) < -0.05) = 4;
% targetnumber(alltarget(:,1) == 0 & alltarget(:,2) < -0.1) = 5;
% targetnumber(alltarget(:,1) < -0.05 & alltarget(:,2) < -0.05) = 6;
% targetnumber(alltarget(:,1) < -0.1 & alltarget(:,2) == 0) = 7;
% targetnumber(alltarget(:,1) < -0.05 & alltarget(:,2) > 0.05) = 8;
% 
% 
% 
% 
%     
%     
%     
% rlocs = round(trialstart*0.1);
% 
% 
rrrdX=decimate(double(data.AO0),10,'fir');
rrrdY=decimate(double(data.AO1),10,'fir');
tX=decimate(double(data.Xtarget),10,'fir');
tY=decimate(double(data.Ytarget),10,'fir');
% 
drrrdX=zeros(size(rrrdX));
drrrdY=zeros(size(rrrdY));

drrrdX(2:length(rrrdX))=diff(rrrdX);
drrrdY(2:length(rrrdY))=diff(rrrdY);
rdrrrdX=drrrdX/max(drrrdX)*100;
rdrrrdY=drrrdY/max(drrrdY)*100;
% 
% 
% 
% %locsplotter=[ccistart,clocvmax',locampmax',clocmaxend',cciend];
% %locsplotterp=locsplotter;
% % locsplotterp(locsplotter == 0,1:5) = [];
% %locsplotter(locsplotter == 0) = nan;
% %rlocsplotterp=round(locsplotterp.*0.1);
% %srdlocsplotterp=sort(reshape(rlocsplotterp,numel(rlocsplotterp),1));
% %srdlocsplotterp(srdlocsplotterp==0)=[];
% rt=1:length(rrrdX);
% a=0;
% n=0;
% 
% % def=figure;
% while a <= length(trialstart)-1;
%     a=a+1;
%     close;
%     scrsz = get(0,'ScreenSize');
%     figure('Position',[1 1 scrsz(3) scrsz(4)])
%     set(gcf,'Selected','on')
%     
%     plot(rt,rdrrrdX,'r',rt,rdrrrdY,'b');
%     hold on; 
%     plot(rt,rrrdX.*20,'r',rt,rrrdY*20,'b','LineWidth',1.5);
%     %hold on;
%    % plot(rt(srdlocsplotterp),rrrd(srdlocsplotterp),'r+');
%     hold on;
%     
%     plot(rt,tX.*20,'r',rt,tY.*20,'b','LineWidth',1);
%     hold on;
%     plot(rt,zeros(size(rt)),'k');
%     hold on;
%     plot(rt,ones(size(rt)).*(trialXtarget(a)+targetradius)*20,'r--',rt,ones(size(rt)).*(trialXtarget(a)-targetradius)*20,'r--');
%     hold on;
%     plot(rt,ones(size(rt)).*(trialYtarget(a)+targetradius)*20,'b-.',rt,ones(size(rt)).*(trialYtarget(a)-targetradius)*20,'b-.');
%    % hold on;
%    % plot(rt(srdlocsplotterp),rdrrrd(srdlocsplotterp),'k+');
%     xlim([rlocs(a) rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)]);
%     title(['Peak nr. ' num2str(a) ' of ' num2str(length(rlocs)) ' 1 = onset; 2 = target; 3 = all good; 4 = turnaround; 5 = exclude;']);
%     [xdata,trash,button]=ginput;
%     
%     if isequal(button(length(button)),54);
%         a= a-1;
%         windowlength = windowlength + 0.5;
%     elseif isequal(button(length(button)),55) && windowlength > 0;
%         a= a-1;
%         windowlength = windowlength - 0.5;
%     elseif (~isempty(button) && ~isempty(find(button==8, 1))) || length(find(button)) < 3;
%         a=a-1;
%     
%     elseif (~isempty(button) && ~isempty(find(button==27, 1,'last')))
%       
%         
%     elseif ~isempty(find(button == 49,1)) && ~isempty(find(button == 50,1)) && isempty(find(button==27, 1,'last'));
%         n=n+1;
%        % event(n,:) = locsplotter(a,:);
%         xdata=round(xdata.*10);
%      
%             event(n,1) = xdata(find(button == 49,1,'last'));        
%             event(n,2) = xdata(find(button == 50,1,'last'));
%             event(n,3) = button(length(button));
%             event(n,4) = trialstyle(a,1);
%             event(n,5) = targetnumber(a,1);
%             
%         if event(n,3) == 52;
%           
%                 event(n,6) = xdata(find(button == 52,1,'last'));
%                 event(n,7) = event(n,6) - event(n,1);
%                 event(n,8) = (sqrt((data.AO0(event(n,6))-trialXtarget(a))^2 + (data.AO1(event(n,6))-trialYtarget(a))^2)/sqrt(trialXtarget(a)^2 + trialYtarget(a)^2))*100;
%                
%         else
%                 event(n,6:8) = nan;
%                 
%            
%         end
%             
%         
%         reactiontime(n,1) = event(n,1)-trialstart(a);
%         performancetime(n,1) = event(n,2)-trialstart(a);
%         movementtime(n,1) = event(n,2)-event(n,1);
%         trialkind{n,1} = trialdef{event(n,3),1};
%         trialhabodd{n,1} = trialstyler{trialstyle(a,1)};
%         T_corr(n,1) = event(n,7);
%         A_corr(n,1) = event(n,8);
%         
%         
%         
%         
%         
%         
%         
%         
%         clear xdata button
%     else
%         a = a-1;
%     end
%             
% 
% %             results(n,:) = [n,smfrd(okevent(n,2)),smfrd(okevent(n,3)),smfrd(okevent(n,4)),okevent(n,5)-okevent(n,1)];
%             %display(event(n,:));
% end
% 
% ntrial(:,1) = 1:n;
% event(:,3) = event(:,3) - 50;
% trlkind = event(:,3);
% results = [ntrial,trialstyle,targetnumber,trlkind,performancetime,reactiontime,movementtime];
% BLOCK1results = [ntrial(1:n/3),trialstyle(1:n/3),targetnumber(1:n/3),trlkind(1:n/3),performancetime(1:n/3),reactiontime(1:n/3),movementtime(1:n/3)];
% BLOCK2results = [ntrial(n/3+1:n/3*2),trialstyle(n/3+1:n/3*2),targetnumber(n/3+1:n/3*2),trlkind(n/3+1:n/3*2),performancetime(n/3+1:n/3*2),reactiontime(n/3+1:n/3*2),movementtime(n/3+1:n/3*2)];
% BLOCK3results = [ntrial(n/3*2+1:n),trialstyle(n/3*2+1:n),targetnumber(n/3*2+1:n),trlkind(n/3*2+1:n),performancetime(n/3*2+1:n),reactiontime(n/3*2+1:n),movementtime(n/3*2+1:n)];
% 
% clear rt 
% save(['results_' filename]);
% 
% %% PLOT OVERALL RESULTS
%         
% %     all=[rt',pt',pt'-rt'];
%     side = trialstyle;
%     pt = performancetime;
%     rt = reactiontime;
%     uncrt = rt;
%     x = 1:n;
%     rt(trlkind~=1) = nan;
%     pt(trlkind~=1) = nan;
%     
%     all = [rt,pt,pt-rt];
%     habit=all(side==1,:);
%     odd=all(side==2,:);
%     boxes=[habit(:,1),odd(:,1),habit(:,2),odd(:,2),habit(:,3),odd(:,3)];
%     number = n;
%     [h,p]=ttest(habit,odd);
%     prt=p(1);
%     ppt=p(2);
%     pprt=p(3);
%     prt=sprintf('%f',prt);
%     ppt=sprintf('%f',ppt);
%     pprt=sprintf('%f',pprt);
%     figure;
%     boxplot(boxes);
%     ylabel('Performance Time');title([' OVERALL - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
% %      load carsmall
%     box = findobj(gca,'Tag','Box');
%     set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
%     for j=1:length(box);
%         patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
%     end
%     
%     saveas(gcf,['allboxes_' matname],'fig');
%     
%     %% PLOT FIRST BLOCK
% 
%     BLOCK1all=[rt(1:number/3),pt(1:number/3),pt(1:number/3)-rt(1:number/3)];
%     BLOCK1habit=BLOCK1all(side(1:number/3)==1,:);
%     BLOCK1odd=BLOCK1all(side(1:number/3)==2,:);
%     BLOCK1boxes=[BLOCK1habit(:,1),BLOCK1odd(:,1),BLOCK1habit(:,2),BLOCK1odd(:,2),BLOCK1habit(:,3),BLOCK1odd(:,3)];
%     
%     [h,p]=ttest2(BLOCK1habit,BLOCK1odd);
%     prt=p(1);
%     ppt=p(2);
%     pprt=p(3);
%     prt=sprintf('%f',prt);
%     ppt=sprintf('%f',ppt);
%     pprt=sprintf('%f',pprt);
%     figure;
%     subplot(1,3,1);
%     boxplot(BLOCK1boxes);
%     ylabel('Performance Time');title([' BLOCK 1 - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
% %      load carsmall
%     box = findobj(gca,'Tag','Box');
%     set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
%     for j=1:length(box);
%         patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
%     end
%     
%    
%     
%     %% PLOT SECOND BLOCK
%     
%     BLOCK2all=[rt(number/3+1:number/3*2),pt(number/3+1:number/3*2),pt(number/3+1:number/3*2)-rt(number/3+1:number/3*2)];
%     BLOCK2habit=BLOCK2all(side(number/3+1:number/3*2)==1,:);
%     BLOCK2odd=BLOCK2all(side(number/3+1:number/3*2)==2,:);
%     BLOCK2boxes=[BLOCK2habit(:,1),BLOCK2odd(:,1),BLOCK2habit(:,2),BLOCK2odd(:,2),BLOCK2habit(:,3),BLOCK2odd(:,3)];
%     
%     [h,p]=ttest2(BLOCK2habit,BLOCK2odd);
%     prt=p(1);
%     ppt=p(2);
%     pprt=p(3);
%     prt=sprintf('%f',prt);
%     ppt=sprintf('%f',ppt);
%     pprt=sprintf('%f',pprt);
%     subplot(1,3,2)
%     boxplot(BLOCK2boxes);
%     ylabel('Performance Time');title([' BLOCK 2 - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
% %      load carsmall
%     box = findobj(gca,'Tag','Box');
%     set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
%     for j=1:length(box);
%         patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
%     end
% 
%     
%         %% PLOT THIRD BLOCK
%  
%     BLOCK3all=[rt(number/3*2+1:number),pt(number/3*2+1:number),pt(number/3*2+1:number)-rt(number/3*2+1:number)];
%     BLOCK3habit=BLOCK3all(side(number/3*2+1:number)==1,:);
%     BLOCK3odd=BLOCK3all(side(number/3*2+1:number)==2,:);
%     BLOCK3boxes=[BLOCK3habit(:,1),BLOCK3odd(:,1),BLOCK3habit(:,2),BLOCK3odd(:,2),BLOCK3habit(:,3),BLOCK3odd(:,3)];
%     
%     [h,p]=ttest2(BLOCK3habit,BLOCK3odd);
%     prt=p(1);
%     ppt=p(2);
%     pprt=p(3);
%     prt=sprintf('%f',prt);
%     ppt=sprintf('%f',ppt);
%     pprt=sprintf('%f',pprt);
%     subplot(1,3,3)
%     boxplot(BLOCK3boxes);
%     ylabel('Performance Time');title([' BLOCK 3 - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
% %      load carsmall
%     box = findobj(gca,'Tag','Box');
%     set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
%     for j=1:length(box);
%         patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
%     end
%     
%     saveas(gcf,['blockboxes_' matname],'fig')
%     
%     %% PLOT RT SCATTERS
%     keephabit=habit(~isnan(habit(:,1)),:);
%     keepodd=odd(~isnan(odd(:,1)),:);
%     figure;
%     subplot(2,1,1);
%     fith=polyfit(keephabit(:,1),keephabit(:,3),1);
%     fitx=linspace(0.2,max(rt),30);
%     scatter(habit(:,1),habit(:,3),'k');title('Overall Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fith,fitx));
%     subplot(2,1,2)
%     fito=polyfit(keepodd(:,1),keepodd(:,3),1);
%     scatter(odd(:,1),odd(:,3),'r');title('Overall Odd');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fito,fitx));
%     
%     
%     figure;
%     keepBLOCK1habit=BLOCK1habit(~isnan(BLOCK1habit(:,1)),:);
%     keepBLOCK1odd=BLOCK1odd(~isnan(BLOCK1odd(:,1)),:);
%     subplot(2,1,1);
%     fithblock1=polyfit(keepBLOCK1habit(:,1),keepBLOCK1habit(:,3),1);
%     hblock1=linspace(0.2,1,30);
%     scatter(BLOCK1habit(:,1),BLOCK1habit(:,3),'k');title('BLOCK1 Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fithblock1,fitx));
%     subplot(2,1,2)
%     fitoblock1=polyfit(keepBLOCK1odd(:,1),keepBLOCK1odd(:,3),1);
%     oblock1=linspace(0.2,1,30);
%     scatter(BLOCK1odd(:,1),BLOCK1odd(:,3),'r');title('BLOCK1 Odd');ylabel('PT-RT');hold on;plot(fitx,polyval(fitoblock1,fitx));
%     
%     figure;
%     keepBLOCK2habit=BLOCK2habit(~isnan(BLOCK2habit(:,1)),:);
%     keepBLOCK2odd=BLOCK2odd(~isnan(BLOCK2odd(:,1)),:);
%     subplot(2,1,1);
%     fithblock2=polyfit(keepBLOCK2habit(:,1),keepBLOCK2habit(:,3),1);
%     hblock2=linspace(0.2,1,30);
%     scatter(BLOCK2habit(:,1),BLOCK2habit(:,3),'k');title('BLOCK2 Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fithblock2,fitx));
%     subplot(2,1,2)
%     fitoblock2=polyfit(keepBLOCK2odd(:,1),keepBLOCK2odd(:,3),1);
%     oblock2=linspace(0.2,1,30);
%     scatter(BLOCK2odd(:,1),BLOCK2odd(:,3),'r');title('BLOCK2 Odd');ylabel('PT-RT');hold on;plot(fitx,polyval(fitoblock2,fitx));
%     
%     figure;
%     keepBLOCK3habit=BLOCK3habit(~isnan(BLOCK3habit(:,1)),:);
%     keepBLOCK3odd=BLOCK3odd(~isnan(BLOCK3odd(:,1)),:);
%     subplot(2,1,1);
%     fithblock3=polyfit(keepBLOCK3habit(:,1),keepBLOCK3habit(:,3),1);
%     hblock3=linspace(0.2,1,30);
%     scatter(BLOCK3habit(:,1),BLOCK3habit(:,3),'k');title('BLOCK3 Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fithblock3,fitx));
%     subplot(2,1,2)
%     fitoblock3=polyfit(keepBLOCK3odd(:,1),keepBLOCK3odd(:,3),1);
%     oblock3=linspace(0.2,1,30);
%     scatter(BLOCK3odd(:,1),BLOCK3odd(:,3),'r');title('BLOCK3 Odd');ylabel('PT-RT');hold on;plot(fitx,polyval(fitoblock3,fitx));
%     
%     %% PLOT OVERVIEW FIGURES
%     
%     figure;h=bar(x,(side(:,1)-1)*max(performancetime));set(h,'barwidth',1,'LineStyle','none','Facecolor',[0.7 0.7 0.7]);hold on;
%     pl=plot(x,performancetime,x,uncrt,x,performancetime-uncrt,'LineWidth',2,'color','k');set(pl(1),'LineStyle','-','color','k');set(pl(2),'LineStyle','-.','color','b');set(pl(3),'LineStyle','--','color','r')
%     xlim([0 number]);legend('Axis','Performance Time','Reaction Time','Movement Duration');
%     
%     saveas(gcf,['overview_' matname],'fig');
% 
%     overviewtext = {'filename','name','on/off','medikamente','sex','age'};
%     overview = {filename,name,onoff,medic,sex,age};
%     
%     taskinfotext = {'ntrials','order (1=green starts)','pretrialtime','posttrialtime','circlesize','circledistance','scalingfactor'};
%     taskinfo = {number,order,pretrialtime,posttrialtime,circlesize,circledistance,scalingfactor};
%     
%     performanceinfotext={'n good trials','n trials with start not from 0','n trials with turnaround'};
%     performanceinfo=[numel(find(trlkind==1)),numel(find(trlkind==2)),numel(find(trlkind==3))];
%     
%     overallmeantext = {'OVERALL','mean rt','mean pt','mean mt','these are only for good trials'};
%     overallmean = nanmean(all);
%     
%     sidemeantext = {'OVERALL','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
%     sidemean = [nanmean(habit(:,1)),nanmean(odd(:,1)),nanmean(habit(:,2)),nanmean(odd(:,2)),nanmean(habit(:,3)),nanmean(odd(:,3))];
%     
%     BLOCK1meantext = {'BLOCK1','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
%     BLOCK1mean = [nanmean(BLOCK1habit(:,1)),nanmean(BLOCK1odd(:,1)),nanmean(BLOCK1habit(:,2)),nanmean(BLOCK1odd(:,2)),nanmean(BLOCK1habit(:,3)),nanmean(BLOCK1odd(:,3))];
%     
%     BLOCK2meantext = {'BLOCK2','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
%     BLOCK2mean = [nanmean(BLOCK2habit(:,1)),nanmean(BLOCK2odd(:,1)),nanmean(BLOCK2habit(:,2)),nanmean(BLOCK2odd(:,2)),nanmean(BLOCK2habit(:,3)),nanmean(BLOCK2odd(:,3))];
%     
%     BLOCK3meantext = {'BLOCK3','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
%     BLOCK3mean = [nanmean(BLOCK3habit(:,1)),nanmean(BLOCK3odd(:,1)),nanmean(BLOCK3habit(:,2)),nanmean(BLOCK3odd(:,2)),nanmean(BLOCK3habit(:,3)),nanmean(BLOCK3odd(:,3))];
%     
%     
% resultstext = {'','habit/odd','position','good/bad/turnaround','performance time','reaction time','movement time'};
% save(['results_' filename]);
% excelname = [name '_' onoff '.xls'];
% xlswrite(excelname,overviewtext,'overview','C2');
% xlswrite(excelname,overview,'overview','C3');
% 
% xlswrite(excelname,taskinfotext,'overview','C5');
% xlswrite(excelname,taskinfo,'overview','C6');
% 
% xlswrite(excelname,performanceinfotext,'overview','C8');
% xlswrite(excelname,performanceinfo,'overview','C9');
% 
% xlswrite(excelname,overallmeantext,'overview','B11');
% xlswrite(excelname,overallmean,'overview','C12');
% 
% xlswrite(excelname,sidemeantext,'overview','B13');
% xlswrite(excelname,sidemean,'overview','C14');
% 
% xlswrite(excelname,BLOCK1meantext,'overview','B16');
% xlswrite(excelname,BLOCK1mean,'overview','C17');
% 
% xlswrite(excelname,BLOCK2meantext,'overview','B19');
% xlswrite(excelname,BLOCK2mean,'overview','C20');
% 
% xlswrite(excelname,BLOCK3meantext,'overview','B22');
% xlswrite(excelname,BLOCK3mean,'overview','C23');
% 
% xlswrite(excelname,{'Position ist von 12 Uhr ausgehend im Uhrzeigersinn';'Seite 2 bedeutet odd'},'overview','C25');
% 
% 
% xlswrite(excelname,resultstext,'overall','C2')
% xlswrite(excelname,results,'overall','C3')
% xlswrite(excelname,BLOCK1results,'block1','C3')
% xlswrite(excelname,resultstext,'block1','C2')
% xlswrite(excelname,BLOCK2results,'block2','C3')
% xlswrite(excelname,resultstext,'block2','C2')
% xlswrite(excelname,BLOCK3results,'block3','C3')
% xlswrite(excelname,resultstext,'block3','C2')
% 
% % save([filename '_eventfile'])
