name = 'PD_STN_LFP01HR01-1-10-02-2014'
root = fullfile(mdf,'visuomotor_tracking',name);
cd(fullfile(root,'output'));


% [filename,pathname,filterindex]=uigetfile({'*.mat','SPIKE MATLAB'});
% [infoname,path] = uigetfile({'*.mat','results from paradigm'});

load(fullfile(root,'task_data',[name '_LFP_ON.mat']),'age','closedmode','circlesize','circledistance','scalingfactor','fixationcrosssize','cursorsize','pretrialtime','posttrialtime','sex','handedness','updrs','medic','onoff','order');


pretrialtime = pretrialtime * 1000;
rpeakrange=200;
windowlength = 0.5; %in rpeakreange times 1/2
if isempty(cursorsize);
    cursorsize = 15;
end
% circlesize = 75;
% circledistance = 150;
% scalingfactor = 1.5;
sc = circledistance*scalingfactor/5;
distanceradius = circledistance/sc;
targetradius = circlesize/sc/2;
cursorradius = cursorsize/sc/2;
trialdef{51,1}='all good';
trialdef{54,1}='did not go back to zero';
trialdef{52,1}='turned around';
trialstyler = {'habitual','odd'};

matname = filename(1:length(filename)-4);
load(fullfile(root,'raw_data',[name '_200.mat']));
t = AO0.times;
dummy = zeros(size(t));
data.AO0 = AO0.values;
data.AO1 = AO1.values;
data.Xtarget = round(AO0.values*10)/10;
data.Ytarget = round(AO1.values*10)/10;
data.dXtarget = dummy;
data.dXtarget(2:end,1) =diff(data.Xtarget);
data.dYtarget = dummy;
data.dYtarget(2:end,1) = diff(data.Ytarget);
data.adYtarget = abs(data.dYtarget);
data.adXtarget = abs(data.dXtarget);

sumdiff = sum([data.adYtarget,data.adXtarget],2)
locs = find(sumdiff>=0.8);
% [~,Ylocs] = findpeaks(data.adYtarget,'MinPeakHeight',0.5);
% [~,Xlocs] = findpeaks(data.adXtarget,'MinPeakHeight',0.5);
% [~,Yinter] = findpeaks(data.dXtarget,'minpeakheight',0.6,'minpeakdistance',4000);
% [~,Xinter] = findpeaks(data.dYtarget,'minpeakheight',0.6,'minpeakdistance',4000);
% Yloca = Ylocs +10;
% Xloca = Xlocs +10;
%%
n=0;
xmin = 0;
figure
figtwo(14);
for a = 1:length(locs);
    plot(sumdiff,'color','k');
    hold on;
    plot(data.Xtarget);
    plot(data.Ytarget);
    xlim([xmin xmin+3000]);
    ylim([-5 5]);
    [x,~,b]= ginput;
    if b(end) == 49;
        n=n+1;
        istart(n) = x(end,1);
    end
    xmin = xmin + 1000;
end
%%
    

green_intertrial = Xlocs(find(data.Xtarget(Xloca) == 1))';
red_intertrial = Xlocs(find(data.Xtarget(Xloca) == 2))';

for a = 1:length(green_intertrial);
    [~,green_trialstart(a,1)] = findpeaks(data.adXtarget(green_intertrial(a):end),'npeaks',1);
    green_trialstart(a,1) = green_trialstart(a,1)+green_intertrial(a);
    [~,red_trialstart(a,1)] = findpeaks(data.adXtarget(red_intertrial(a):end),'npeaks',1);
    red_trialstart(a,1) = red_trialstart(a,1)+red_intertrial(a);
end

% green_trialstart = green_intertrial+pretrialtime;
% red_trialstart = red_intertrial+pretrialtime;

green_trial_Xtarget = data.Xtarget(green_trialstart + 100);
green_trial_Ytarget = data.Ytarget(green_trialstart + 100);
red_trial_Xtarget = data.Xtarget(red_trialstart + 100);
red_trial_Ytarget = data.Ytarget(red_trialstart + 100);

clear AO0 Xtarget AO1 Ytarget Keyboard
% subplot(2,1,1);
% plot(t,data.AO0,t,data.Xtarget,t,data.dXtarget,t(Xlocs),data.dXtarget(Xlocs),'r+');
% subplot(2,1,2);
% plot(t,data.AO1,t,data.Ytarget,t,data.dYtarget,t(Ylocs),data.dYtarget(Ylocs),'r+');

if ~isempty(green_trialstart) && isempty(red_trialstart) ;
    display('green block');
    trialstart = green_trialstart;
    trialstyle = ones(size(trialstart));
    trialXtarget = green_trial_Xtarget;
    trialYtarget = green_trial_Ytarget;
elseif ~isempty(red_trialstart) && isempty(green_trialstart);
     display('red block');
    trialstart = green_trialstart;
    trialstyle = ones(size(trialstart))*2;
    trialXtarget = green_trial_Xtarget;
    trialYtarget = green_trial_Ytarget;
elseif ~isempty(red_trialstart) && ~isempty(green_trialstart);
    display('mixed block');
    [trialstart,i] = sort([green_trialstart;red_trialstart]);
    trialstyle = [ones(length(trialstart)/2,1);ones(length(trialstart)/2,1)*2];
    trialstyle = trialstyle(i,1);
    trialXtarget = [green_trial_Xtarget;red_trial_Xtarget];
    trialXtarget = trialXtarget(i,1);
    trialYtarget = [green_trial_Ytarget;red_trial_Ytarget];
    trialYtarget = trialYtarget(i,1);
end

alltarget = [trialYtarget,trialXtarget];
alltarget = alltarget / circledistance * 5;
targetnumber = zeros(size(trialYtarget));
targetnumber(alltarget(:,1) == 0 & alltarget(:,2) > 0.1) = 1;
targetnumber(alltarget(:,1) > 0.05 & alltarget(:,2) > 0.05) = 2;
targetnumber(alltarget(:,1) > 0.1 & alltarget(:,2) == 0) = 3;
targetnumber(alltarget(:,1) > 0.05 & alltarget(:,2) < -0.05) = 4;
targetnumber(alltarget(:,1) == 0 & alltarget(:,2) < -0.1) = 5;
targetnumber(alltarget(:,1) < -0.05 & alltarget(:,2) < -0.05) = 6;
targetnumber(alltarget(:,1) < -0.1 & alltarget(:,2) == 0) = 7;
targetnumber(alltarget(:,1) < -0.05 & alltarget(:,2) > 0.05) = 8;




    
    
    
rlocs = round(trialstart*0.1);


rrrdX=decimate(double(data.AO0),10,'fir');
rrrdY=decimate(double(data.AO1),10,'fir');
tX=decimate(double(data.Xtarget),10,'fir');
tY=decimate(double(data.Ytarget),10,'fir');

drrrdX=zeros(size(rrrdX));
drrrdY=zeros(size(rrrdY));

drrrdX(2:length(rrrdX))=diff(rrrdX);
drrrdY(2:length(rrrdY))=diff(rrrdY);
rdrrrdX=drrrdX/max(drrrdX)*100;
rdrrrdY=drrrdY/max(drrrdY)*100;



%locsplotter=[ccistart,clocvmax',locampmax',clocmaxend',cciend];
%locsplotterp=locsplotter;
% locsplotterp(locsplotter == 0,1:5) = [];
%locsplotter(locsplotter == 0) = nan;
%rlocsplotterp=round(locsplotterp.*0.1);
%srdlocsplotterp=sort(reshape(rlocsplotterp,numel(rlocsplotterp),1));
%srdlocsplotterp(srdlocsplotterp==0)=[];
rt=1:length(rrrdX);
a=0;
n=0;

% def=figure;
while a <= length(trialstart)-1;
    a=a+1;
    close;
    distance = sqrt((rrrdX-trialXtarget(a)).^2+(rrrdY-trialYtarget(a)).^2);
    real_distance = sqrt((data.AO0-trialXtarget(a)).^2+(data.AO1-trialYtarget(a)).^2);
%     tdistance = distance - targetradius;%./(abs(trialXtarget(a))+abs(trialYtarget(a))))*100;
    %lowthresh = (abs(trialXtarget(a)-targetradius)-trialXtarget(a))+(abs(trialYtarget(a)-targetradius) - trialYtarget(a));
    %thresh = (abs(trialXtarget(a)-targetradius))+(abs(trialYtarget(a)-targetradius));%/(abs(trialXtarget(a))+abs(trialYtarget(a))))*100;
    
    targetdistance = sqrt(trialXtarget(a)^2+trialYtarget(a)^2);
    ttargetdistance = (targetradius/targetdistance-1)*-100;
    rdistance = (distance/targetdistance-1)*-100;
%     rdistance = distance - targetradius;
    %rdistance = (distance/ttargetdistance-1)*-100;
    %rtdistance = (tdistance/ttargetdistance-1)*-100;
    drtdistance = zeros(size(rdistance));
    drtdistance(2:end,1) = diff(rdistance)*10;
     ddistance = zeros(size(distance));
    ddistance(2:end,1) = diff(distance)*10;
    %rthresh = 100;
    
%     figure;
%     plot3(rt(rlocs(a):rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)),rrrdX(rlocs(a):rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)),rrrdY(rlocs(a):rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)));
%     hold on; plot3(rt(rlocs(a):rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)),ones(length(rlocs(a):rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)),1)*cos(1:360)*targetradius+trialXtarget(a),ones(length(rlocs(a):rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)),1)*sin(1:360)*targetradius+trialYtarget(a));
%     xlim([rlocs(a) rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)]);
    
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 1 scrsz(3) scrsz(4)])
    set(gcf,'Selected','on')

    

    subplot(2,1,1);
    %plot(rt,rdrrrdX,'r',rt,rdrrrdY,'b');
    %hold on; 
    %plot(rt,rrrdX.*20,'r',rt,rrrdY*20,'b','LineWidth',1.5);
%     plot(rt,rdistance,'b',rt,drtdistance,'r--','LineWidth',1);
    plot(rt,rdistance,'b',rt,drtdistance,'r','LineWidth',1);
    %hold on;
   % plot(rt(srdlocsplotterp),rrrd(srdlocsplotterp),'r+');
    hold on;
%     plot(rt,ones(size(rt)).*ttargetdistance,'r--')
    plot(rt,ones(size(rt)).*ttargetdistance,'r')
    %plot(rt,tX.*20,'r',rt,tY.*20,'b','LineWidth',1);
    hold on;
    plot(rt,zeros(size(rt)),'k');
    hold on;
   
    xlim([rlocs(a) rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)]);
    title(['Peak nr. ' num2str(a) ' of ' num2str(length(rlocs)) ' 1 = onset; 2 = target; 3 = all good; 4 = turnaround; 5 = exclude;']);
    subplot(2,1,2);
    plot(rt,ones(size(rt)).*(trialXtarget(a)+targetradius),'r',rt,ones(size(rt)).*(trialXtarget(a)-targetradius),'r');
    hold on;
    plot(rt,ones(size(rt)).*(trialYtarget(a)+targetradius),'b',rt,ones(size(rt)).*(trialYtarget(a)-targetradius),'b');
    hold on;
    plot(rt,rrrdX,'r',rt,rrrdY,'b','LineWidth',0.5);
    hold on;
    plot(rt,drrrdX*2,'r',rt,drrrdY*2,'b','LineWidth',0.5);
    hold on;
    plot(rt,tX,'r',rt,tY,'b','LineWidth',1)
%     plot(rt(srdlocsplotterp),rdrrrd(srdlocsplotterp),'k+');
    xlim([rlocs(a) rlocs(a)+rpeakrange*windowlength*trialstyle(a,1)]);
    [xdata,trash,button]=ginput;
    
    if isequal(button(length(button)),54);
        a= a-1;
        windowlength = windowlength + 0.25;
    elseif isequal(button(length(button)),55) && windowlength > 0.25;
        a= a-1;
        windowlength = windowlength - 0.25;
    elseif (~isempty(button) && ~isempty(find(button==8, 1))) || length(find(button)) < 3;
        a=a-1;
    
    elseif (~isempty(button) && ~isempty(find(button==27, 1,'last')))
      
        
    elseif ~isempty(find(button == 49,1)) && ~isempty(find(button == 50,1)) && isempty(find(button==27, 1,'last'));
        n=n+1;
       % event(n,:) = locsplotter(a,:);
        xdata=round(xdata.*10);
     
            event(n,1) = xdata(find(button == 49,1,'last'));        
            event(n,2) = xdata(find(button == 50,1,'last'));
            event(n,3) = button(length(button));
            event(n,4) = trialstyle(a,1);
            event(n,5) = targetnumber(a,1);
            
        if event(n,3) == 52;
          
                event(n,6) = xdata(find(button == 52,1,'last'));
                event(n,7) = event(n,6) - event(n,1);
                event(n,8) = real_distance(event(n,6))/targetdistance*100;
               
        else
                event(n,6:8) = nan;
                
           
        end
            
        
        reactiontime(n,1) = event(n,1)-trialstart(a);
        performancetime(n,1) = event(n,2)-trialstart(a);
        movementtime(n,1) = event(n,2)-event(n,1);
        trialkind{n,1} = trialdef{event(n,3),1}; % Error, good or excluded
        trialhabodd{n,1} = trialstyler{trialstyle(a,1)};
        T_corr(n,1) = event(n,7); % Time from movement start to change of direction
        A_corr(n,1) = event(n,8); % Distance relative to start distance in [%]
        
        
        
        
        
        
        
        
        clear xdata button
    else
        a = a-1;
    end
            

%             results(n,:) = [n,smfrd(okevent(n,2)),smfrd(okevent(n,3)),smfrd(okevent(n,4)),okevent(n,5)-okevent(n,1)];
            %display(event(n,:));
end
block = ones(n,1);
block(n/3+1:n/3*2) = 2;
block(n/3*2+1:n) = 3;

rawRT = reactiontime;


ntrial(:,1) = 1:n;
%event(:,3) = event(:,3) - 50;
trlkind = event(:,3) - 50;

trlkind(reactiontime > mean(reactiontime)+2*std(reactiontime))=3;
trlkind(reactiontime < mean(reactiontime)-2*std(reactiontime))=3;
% trlkind(movementtime > mean(movementtime)+2*std(movementtime))=3;
% trlkind(movementtime < mean(movementtime)-2*std(movementtime))=3;
N_dropout = numel(find(trlkind == 3));
N_trials = n;
nERR_all = numel(find(trlkind == 2));
nERR_all_green = numel(find(trlkind(trialstyle == 1,1) == 2));
nERR_all_red = numel(find(trlkind(trialstyle == 2,1) == 2));

RT_all = mean(reactiontime(trlkind~=3));
RT_all_green = mean(reactiontime(trlkind ~= 3 & trialstyle == 1));
RT_all_red = mean(reactiontime(trlkind ~= 3 & trialstyle == 2));
adRT_all = abs(RT_all_red - RT_all_green);
rdRT_all = adRT_all / RT_all_red * 100;

RT_1_all = mean(reactiontime(trlkind ~= 3 & block == 1));
RT_1_green = mean(reactiontime(trlkind ~= 3 & block == 1 & trialstyle == 1));
RT_1_red = mean(reactiontime(trlkind ~= 3 & block == 1 & trialstyle == 2));
adRT_1 = abs(RT_1_red - RT_1_green);
rdRT_1 = adRT_1 / RT_1_red * 100;

RT_2_all = mean(reactiontime(trlkind ~= 3 & block == 2));
RT_2_green = mean(reactiontime(trlkind ~= 3 & block == 2 & trialstyle == 1));
RT_2_red = mean(reactiontime(trlkind ~= 3 & block == 2 & trialstyle == 2));
adRT_2 = abs(RT_2_red - RT_2_green);
rdRT_2 = adRT_2 / RT_2_red * 100;

RT_3_all = mean(reactiontime(trlkind ~= 3 & block == 3));
RT_3_green = mean(reactiontime(trlkind ~= 3 & block == 3 & trialstyle == 1));
RT_3_red = mean(reactiontime(trlkind ~= 3 & block == 3 & trialstyle == 2));
adRT_3 = abs(RT_3_red - RT_3_green);
rdRT_3 = adRT_3 / RT_3_red * 100;

nERR_1_all = numel(find(trlkind == 2 & block == 1));
nERR_1_green = numel(find(trlkind(trialstyle == 1 & block == 1,1) == 2));
nERR_1_red = numel(find(trlkind(trialstyle == 2 & block == 1,1) == 2));

nERR_2_all = numel(find(trlkind == 2 & block == 2));
nERR_2_green = numel(find(trlkind(trialstyle == 1 & block == 2,1) == 2));
nERR_2_red = numel(find(trlkind(trialstyle == 2 & block == 2,1) == 2));

nERR_3_all = numel(find(trlkind == 2 & block == 3));
nERR_3_green = numel(find(trlkind(trialstyle == 1 & block == 3,1) == 2));
nERR_3_red = numel(find(trlkind(trialstyle == 2 & block == 3,1) == 2));

afterswitch = zeros(n,1);

side = trialstyle;
for a = n/3+2:n/3*2;
    if side(a) ~= side(a-1);
        afterswitch(a,1) = 1;
    end
end

N_afterswitch = numel(find(afterswitch));
RT_afterswitch = mean(reactiontime(trlkind ~= 3 & afterswitch == 1));
nERR_afterswitch = numel(find(trlkind == 2 & afterswitch == 1));

T_corr_all = nanmean(T_corr);
T_corr_green = nanmean(T_corr(trialstyle == 1));
T_corr_red = nanmean(T_corr(trialstyle == 2 ));

A_corr_all = nanmean(A_corr);
A_corr_green = nanmean(A_corr(trialstyle == 1));
A_corr_red = nanmean(A_corr(trialstyle == 2 ));

PT_all = mean(performancetime(trlkind==1));
PT_all_green = mean(performancetime(trlkind ==1 & trialstyle == 1));
PT_all_red = mean(performancetime(trlkind ==1 & trialstyle == 2));
adPT_all = abs(PT_all_red - PT_all_green);
rdPT_all = adPT_all / PT_all_red * 100;

PT_1_all = mean(performancetime(trlkind ==1 & block == 1));
PT_1_green = mean(performancetime(trlkind ==1 & block == 1 & trialstyle == 1));
PT_1_red = mean(performancetime(trlkind ==1 & block == 1 & trialstyle == 2));
adPT_1 = abs(PT_1_red - PT_1_green);
rdPT_1 = adPT_1 / PT_1_red * 100;

PT_2_all = mean(performancetime(trlkind ==1 & block == 2));
PT_2_green = mean(performancetime(trlkind ==1 & block == 2 & trialstyle == 1));
PT_2_red = mean(performancetime(trlkind ==1 & block == 2 & trialstyle == 2));
adPT_2 = abs(PT_2_red - PT_2_green);
rdPT_2 = adPT_2 / PT_2_red * 100;

PT_3_all = mean(performancetime(trlkind ==1 & block == 3));
PT_3_green = mean(performancetime(trlkind ==1 & block == 3 & trialstyle == 1));
PT_3_red = mean(performancetime(trlkind ==1 & block == 3 & trialstyle == 2));
adPT_3 = abs(PT_3_red - PT_3_green);
rdPT_3 = adPT_3 / PT_3_red * 100;


MT_all = mean(movementtime(trlkind==1));
MT_all_green = mean(movementtime(trlkind ==1 & trialstyle == 1));
MT_all_red = mean(movementtime(trlkind ==1 & trialstyle == 2));
adMT_all = abs(MT_all_red - MT_all_green);
rdMT_all = adMT_all / MT_all_red * 100;

MT_1_all = mean(movementtime(trlkind ==1 & block == 1));
MT_1_green = mean(movementtime(trlkind ==1 & block == 1 & trialstyle == 1));
MT_1_red = mean(movementtime(trlkind ==1 & block == 1 & trialstyle == 2));
adMT_1 = abs(MT_1_red - MT_1_green);
rdMT_1 = adMT_1 / MT_1_red * 100;

MT_2_all = mean(movementtime(trlkind ==1 & block == 2));
MT_2_green = mean(movementtime(trlkind ==1 & block == 2 & trialstyle == 1));
MT_2_red = mean(movementtime(trlkind==1 & block == 2 & trialstyle == 2));
adMT_2 = abs(MT_2_red - MT_2_green);
rdMT_2 = adMT_2 / MT_2_red * 100;

MT_3_all = mean(movementtime(trlkind ==1 & block == 3));
MT_3_green = mean(movementtime(trlkind ==1 & block == 3 & trialstyle == 1));
MT_3_red = mean(movementtime(trlkind ==1 & block == 3 & trialstyle == 2));
adMT_3 = abs(MT_3_red - MT_3_green);
rdMT_3 = adMT_3 / MT_3_red * 100;

SD_dir = mod(targetnumber,2); % 1 = easy / straight
SD_dir(SD_dir==0)=2; % 2 = hard / oblique


results = [ntrial,trialstyle,targetnumber,trlkind,performancetime,reactiontime,movementtime];
BLOCK1results = [ntrial(1:n/3),trialstyle(1:n/3),targetnumber(1:n/3),trlkind(1:n/3),performancetime(1:n/3),reactiontime(1:n/3),movementtime(1:n/3)];
BLOCK2results = [ntrial(n/3+1:n/3*2),trialstyle(n/3+1:n/3*2),targetnumber(n/3+1:n/3*2),trlkind(n/3+1:n/3*2),performancetime(n/3+1:n/3*2),reactiontime(n/3+1:n/3*2),movementtime(n/3+1:n/3*2)];
BLOCK3results = [ntrial(n/3*2+1:n),trialstyle(n/3*2+1:n),targetnumber(n/3*2+1:n),trlkind(n/3*2+1:n),performancetime(n/3*2+1:n),reactiontime(n/3*2+1:n),movementtime(n/3*2+1:n)];

clear rt 
save(['results_' filename]);

%% PLOT OVERALL RESULTS
        
%     all=[rt',pt',pt'-rt'];
    side = trialstyle;
    pt = performancetime;
    rt = reactiontime;
    uncrt = rt;
    x = 1:n;
    rt(trlkind==3) = nan;
    pt(trlkind~=1) = nan;
    
    all = [rt,pt,pt-rt];
    habit=all(side==1,:);
    odd=all(side==2,:);
    boxes=[habit(:,1),odd(:,1),habit(:,2),odd(:,2),habit(:,3),odd(:,3)];
    number = n;
    [h,p]=ttest(habit,odd);
    prt=p(1);
    ppt=p(2);
    pprt=p(3);
    prt=sprintf('%f',prt);
    ppt=sprintf('%f',ppt);
    pprt=sprintf('%f',pprt);
    figure;
    boxplot(boxes);
    ylabel('Performance Time');title([' OVERALL - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
%      load carsmall
    box = findobj(gca,'Tag','Box');
    set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
    for j=1:length(box);
        patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
    end
    
    saveas(gcf,['allboxes_' matname],'fig');
    
    %% PLOT FIRST BLOCK

    BLOCK1all=[rt(1:number/3),pt(1:number/3),pt(1:number/3)-rt(1:number/3)];
    BLOCK1habit=BLOCK1all(side(1:number/3)==1,:);
    BLOCK1odd=BLOCK1all(side(1:number/3)==2,:);
    BLOCK1boxes=[BLOCK1habit(:,1),BLOCK1odd(:,1),BLOCK1habit(:,2),BLOCK1odd(:,2),BLOCK1habit(:,3),BLOCK1odd(:,3)];
    
    [h,p]=ttest2(BLOCK1habit,BLOCK1odd);
    prt=p(1);
    ppt=p(2);
    pprt=p(3);
    prt=sprintf('%f',prt);
    ppt=sprintf('%f',ppt);
    pprt=sprintf('%f',pprt);
    figure;
    subplot(1,3,1);
    boxplot(BLOCK1boxes);
    ylabel('Performance Time');title([' BLOCK 1 - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
%      load carsmall
    box = findobj(gca,'Tag','Box');
    set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
    for j=1:length(box);
        patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
    end
    
   
    
    %% PLOT SECOND BLOCK
    
    BLOCK2all=[rt(number/3+1:number/3*2),pt(number/3+1:number/3*2),pt(number/3+1:number/3*2)-rt(number/3+1:number/3*2)];
    BLOCK2habit=BLOCK2all(side(number/3+1:number/3*2)==1,:);
    BLOCK2odd=BLOCK2all(side(number/3+1:number/3*2)==2,:);
    BLOCK2boxes=[BLOCK2habit(:,1),BLOCK2odd(:,1),BLOCK2habit(:,2),BLOCK2odd(:,2),BLOCK2habit(:,3),BLOCK2odd(:,3)];
    
    [h,p]=ttest2(BLOCK2habit,BLOCK2odd);
    prt=p(1);
    ppt=p(2);
    pprt=p(3);
    prt=sprintf('%f',prt);
    ppt=sprintf('%f',ppt);
    pprt=sprintf('%f',pprt);
    subplot(1,3,2)
    boxplot(BLOCK2boxes);
    ylabel('Performance Time');title([' BLOCK 2 - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
%      load carsmall
    box = findobj(gca,'Tag','Box');
    set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
    for j=1:length(box);
        patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
    end

    
        %% PLOT THIRD BLOCK
 
    BLOCK3all=[rt(number/3*2+1:number),pt(number/3*2+1:number),pt(number/3*2+1:number)-rt(number/3*2+1:number)];
    BLOCK3habit=BLOCK3all(side(number/3*2+1:number)==1,:);
    BLOCK3odd=BLOCK3all(side(number/3*2+1:number)==2,:);
    BLOCK3boxes=[BLOCK3habit(:,1),BLOCK3odd(:,1),BLOCK3habit(:,2),BLOCK3odd(:,2),BLOCK3habit(:,3),BLOCK3odd(:,3)];
    
    [h,p]=ttest2(BLOCK3habit,BLOCK3odd);
    prt=p(1);
    ppt=p(2);
    pprt=p(3);
    prt=sprintf('%f',prt);
    ppt=sprintf('%f',ppt);
    pprt=sprintf('%f',pprt);
    subplot(1,3,3)
    boxplot(BLOCK3boxes);
    ylabel('Performance Time');title([' BLOCK 3 - RT: p = ' num2str(prt,2) ' PT: p = ' num2str(ppt,2) ' PT-RT: p = ' num2str(pprt,2)]);
%      load carsmall
    box = findobj(gca,'Tag','Box');
    set(gca,'XTickLabel',{'RT hab','RT odd','PT hab','PT odd','PT-RT hab','PT-RT odd'},'XTick',[1 2 3 4 5 6]);
    for j=1:length(box);
        patch(get(box(j),'XData'),get(box(j),'YData'),'k','FaceAlpha',.5);
    end
    
    saveas(gcf,['blockboxes_' matname],'fig')
    
    %% PLOT RT SCATTERS
    keephabit=habit(~isnan(habit(:,1)),:);
    keepodd=odd(~isnan(odd(:,1)),:);
    figure;
    subplot(2,1,1);
    fith=polyfit(keephabit(:,1),keephabit(:,3),1);
    fitx=linspace(0.2,max(rt),30);
    scatter(habit(:,1),habit(:,3),'k');title('Overall Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fith,fitx));
    subplot(2,1,2)
    fito=polyfit(keepodd(:,1),keepodd(:,3),1);
    scatter(odd(:,1),odd(:,3),'r');title('Overall Odd');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fito,fitx));
    
    
    figure;
    keepBLOCK1habit=BLOCK1habit(~isnan(BLOCK1habit(:,1)),:);
    keepBLOCK1odd=BLOCK1odd(~isnan(BLOCK1odd(:,1)),:);
    subplot(2,1,1);
    fithblock1=polyfit(keepBLOCK1habit(:,1),keepBLOCK1habit(:,3),1);
    hblock1=linspace(0.2,1,30);
    scatter(BLOCK1habit(:,1),BLOCK1habit(:,3),'k');title('BLOCK1 Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fithblock1,fitx));
    subplot(2,1,2)
    fitoblock1=polyfit(keepBLOCK1odd(:,1),keepBLOCK1odd(:,3),1);
    oblock1=linspace(0.2,1,30);
    scatter(BLOCK1odd(:,1),BLOCK1odd(:,3),'r');title('BLOCK1 Odd');ylabel('PT-RT');hold on;plot(fitx,polyval(fitoblock1,fitx));
    
    figure;
    keepBLOCK2habit=BLOCK2habit(~isnan(BLOCK2habit(:,1)),:);
    keepBLOCK2odd=BLOCK2odd(~isnan(BLOCK2odd(:,1)),:);
    subplot(2,1,1);
    fithblock2=polyfit(keepBLOCK2habit(:,1),keepBLOCK2habit(:,3),1);
    hblock2=linspace(0.2,1,30);
    scatter(BLOCK2habit(:,1),BLOCK2habit(:,3),'k');title('BLOCK2 Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fithblock2,fitx));
    subplot(2,1,2)
    fitoblock2=polyfit(keepBLOCK2odd(:,1),keepBLOCK2odd(:,3),1);
    oblock2=linspace(0.2,1,30);
    scatter(BLOCK2odd(:,1),BLOCK2odd(:,3),'r');title('BLOCK2 Odd');ylabel('PT-RT');hold on;plot(fitx,polyval(fitoblock2,fitx));
    
    figure;
    keepBLOCK3habit=BLOCK3habit(~isnan(BLOCK3habit(:,1)),:);
    keepBLOCK3odd=BLOCK3odd(~isnan(BLOCK3odd(:,1)),:);
    subplot(2,1,1);
    fithblock3=polyfit(keepBLOCK3habit(:,1),keepBLOCK3habit(:,3),1);
    hblock3=linspace(0.2,1,30);
    scatter(BLOCK3habit(:,1),BLOCK3habit(:,3),'k');title('BLOCK3 Habitual');xlabel('RT');ylabel('PT-RT');hold on;plot(fitx,polyval(fithblock3,fitx));
    subplot(2,1,2)
    fitoblock3=polyfit(keepBLOCK3odd(:,1),keepBLOCK3odd(:,3),1);
    oblock3=linspace(0.2,1,30);
    scatter(BLOCK3odd(:,1),BLOCK3odd(:,3),'r');title('BLOCK3 Odd');ylabel('PT-RT');hold on;plot(fitx,polyval(fitoblock3,fitx));
    
    %% PLOT OVERVIEW FIGURES
    
    figure;h=bar(x,(side(:,1)-1)*max(performancetime));set(h,'barwidth',1,'LineStyle','none','Facecolor',[0.7 0.7 0.7]);hold on;
    pl=plot(x,performancetime,x,uncrt,x,performancetime-uncrt,'LineWidth',2,'color','k');set(pl(1),'LineStyle','-','color','k');set(pl(2),'LineStyle','-.','color','b');set(pl(3),'LineStyle','--','color','r')
    xlim([0 number]);legend('Axis','Performance Time','Reaction Time','Movement Duration');
    
    saveas(gcf,['overview_' matname],'fig');

    
    
    %%% Generate master results
    
    load X:\habitodd_behav_julian\mastertext.mat
    for a=20:length(mastertext);
        masterresults{a} = eval(mastertext{a});
    end
    
    overviewtext = {'filename','name','on/off','medikamente','sex','age'};
    overview = {filename,name,onoff,medic,sex,age};
    
    taskinfotext = {'ntrials','order (1=green starts)','pretrialtime','posttrialtime','circlesize','circledistance','scalingfactor'};
    taskinfo = {number,order,pretrialtime,posttrialtime,circlesize,circledistance,scalingfactor};
    
    performanceinfotext={'n good trials','n trials with start not from 0','n trials with turnaround'};
    performanceinfo=[numel(find(trlkind==1)),numel(find(trlkind==2)),numel(find(trlkind==3))];
    
    overallmeantext = {'OVERALL','mean rt','mean pt','mean mt','these are only for good trials'};
    overallmean = nanmean(all);
    
    sidemeantext = {'OVERALL','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
    sidemean = [nanmean(habit(:,1)),nanmean(odd(:,1)),nanmean(habit(:,2)),nanmean(odd(:,2)),nanmean(habit(:,3)),nanmean(odd(:,3))];
    
    BLOCK1meantext = {'BLOCK1','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
    BLOCK1mean = [nanmean(BLOCK1habit(:,1)),nanmean(BLOCK1odd(:,1)),nanmean(BLOCK1habit(:,2)),nanmean(BLOCK1odd(:,2)),nanmean(BLOCK1habit(:,3)),nanmean(BLOCK1odd(:,3))];
    
    BLOCK2meantext = {'BLOCK2','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
    BLOCK2mean = [nanmean(BLOCK2habit(:,1)),nanmean(BLOCK2odd(:,1)),nanmean(BLOCK2habit(:,2)),nanmean(BLOCK2odd(:,2)),nanmean(BLOCK2habit(:,3)),nanmean(BLOCK2odd(:,3))];
    
    BLOCK3meantext = {'BLOCK3','mean rt hab','mean rt odd','mean pt hab','mean pt odd','mean mt hab','mean mt odd'};
    BLOCK3mean = [nanmean(BLOCK3habit(:,1)),nanmean(BLOCK3odd(:,1)),nanmean(BLOCK3habit(:,2)),nanmean(BLOCK3odd(:,2)),nanmean(BLOCK3habit(:,3)),nanmean(BLOCK3odd(:,3))];
    
    
resultstext = {'','habit/odd','position','good/bad/turnaround','performance time','reaction time','movement time'};
save(['results_' filename]);
excelname = [name '_' onoff '.xls'];
xlswrite(excelname,overviewtext,'overview','C2');
xlswrite(excelname,overview,'overview','C3');

xlswrite(excelname,taskinfotext,'overview','C5');
xlswrite(excelname,taskinfo,'overview','C6');

xlswrite(excelname,performanceinfotext,'overview','C8');
xlswrite(excelname,performanceinfo,'overview','C9');

xlswrite(excelname,overallmeantext,'overview','B11');
xlswrite(excelname,overallmean,'overview','C12');

xlswrite(excelname,sidemeantext,'overview','B13');
xlswrite(excelname,sidemean,'overview','C14');

xlswrite(excelname,BLOCK1meantext,'overview','B16');
xlswrite(excelname,BLOCK1mean,'overview','C17');

xlswrite(excelname,BLOCK2meantext,'overview','B19');
xlswrite(excelname,BLOCK2mean,'overview','C20');

xlswrite(excelname,BLOCK3meantext,'overview','B22');
xlswrite(excelname,BLOCK3mean,'overview','C23');

xlswrite(excelname,{'Position ist von 12 Uhr ausgehend im Uhrzeigersinn';'Seite 2 bedeutet odd'},'overview','C25');


xlswrite(excelname,resultstext,'overall','C2')
xlswrite(excelname,results,'overall','C3')
xlswrite(excelname,BLOCK1results,'block1','C3')
xlswrite(excelname,resultstext,'block1','C2')
xlswrite(excelname,BLOCK2results,'block2','C3')
xlswrite(excelname,resultstext,'block2','C2')
xlswrite(excelname,BLOCK3results,'block3','C3')
xlswrite(excelname,resultstext,'block3','C2')

save(['master_results_' filename],'masterresults','mastertext');
xlswrite(['master_' excelname],mastertext,1,'A1');
xlswrite(['master_' excelname],masterresults,1,'A2');

% save([filename '_eventfile'])
