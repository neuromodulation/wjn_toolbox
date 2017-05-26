

% clear_ao;
clear_timer;
clear all
global name;
name=input('name: ','s');
save(name,'name');
addcogent;

% config_ao;
% global ao;

[closedmode,circlesize,circledistance,scalingfactor,fixationcrosssize,cursorsize,homingsize,pretrialtime,sc,blocksize,number,screen_resolution]=get_parameters
[xcos,ysin] = config_coordinates(closedmode);


order=input('Order I/II: ');





%% pre assign growing variables
mv=zeros(200,3,number); % mv = movement recording;
rt=nan(1,number);
pt=nan(1,number);
nrounds=ones(number,2);
angle=nan(1,length(nrounds));
% create variables that will be needed in loops
lastkey=0;
t2=0;
target=0;
farbe={'GRÜN','ROT'};
% sc = circledistance*scalingfactor/5;

%% Create random series of habitual and odd cues
mix=[ones(1,number/6),ones(1,number/6)*2];
mixer=randperm(number/3);
if order == 1;
    iside=[1 2];
elseif order == 2;
    iside=[2 1];
else
    warning('wrong order, choose 1 or 2!');
end


side=[ones(1,number/6)*iside(1), ones(1,number/6)*iside(2),mix(mixer),ones(1,number/6)*iside(1), ones(1,number/6)*iside(2)]; %% main CUE variable

%% start COGENT
key=0;
cgopen(screen_resolution,16,0,1);
cgpencol(0.95,0.95,0.95);
cgfont('Arial',fixationcrosssize);
cgtext('+',0,0);
cgflip(0,0,0);

pause(0.5);
start_output(screen_resolution);
[x,y]=cgmouse;joy1=[y,x];
tintro=tic;
cgpenwid(cursorsize);
cgalign('c','c')
clear key keyn lastkey

%% BEGIN REAL RUN

    cgpencol(0.95,0.95,0.95);
    cgtext([farbe{iside(1)} ' beginnt!'],0,200);
    cgflip(0,0,0);
    pause
    cgflip(0,0,0);
    cgtext('+',0,0);
    cgflip(0,0,0);
%     start(tim)
    pause(0.5);
    for a = 1:length(nrounds);    
        t1=0;
        run=0;
        ann =[];
        target=0;
%         cgmouse(0,0);
%% Screen information between blocks
        if a == number/6+1 || a == number/6*2+1 || a == number/6*4+1 || a == number/6*5+1;
              cgflip(0,0,0)
              cgpencol(0.95,0.95,0.95);
            if a == number/6+1
                cgtext(['Es folgt ' farbe{iside(2)} '!'],0,200);
            elseif a == number/6*2+1
                cgtext('Es folgt der gemischte Block!',0,200);
            elseif a == number/6*4+1
                cgtext(['Es folgt ' farbe{iside(1)} '!'],0,200);
            elseif a == number/6*5+1
                cgtext(['Es folgt ' farbe{iside(2)} '!'],0,200);
            end
            
            cgflip(0,0,0);
            pause
            

            cgflip(0,0,0);
            cgtext('+',0,0);
            t0=cgflip(0,0,0);
            pause(1);
        end
        
        %% Define position of target circle
        angle(a)=round(1+(length(xcos)-1).*rand(1,1)); 
        nrounds(a,1:2)=[xcos(angle(a))*circledistance,ysin(angle(a))*circledistance]; % 
           
           cgpencol(0.4,0.4,0.4)
           cgellipse(0,0,homingsize,homingsize)
           cgpencol(0.95,0.95,0.95);

           cgtext('+',0,0);
%            putsample(ao,[side(a) side(a)]);
        t0=cgflip(0,0,0);
        starter=0;
%         pause(pretrialtime);
        tpre = 0;
        homer = 0;
        thome = 0;
        
        while tpre <= pretrialtime || homer == 0;
            [x,y]=cgmouse;joy1=[y,x];
            if sqrt(joy1(2)^2+joy1(1)^2) <= homingsize;
                cgalign('c','c')
%                 cgpencol(0.9,0.9,0.2)
%                 cgellipse(0,0,homingsize+5,homingsize+5)
                cgpencol(0.4,0.4,0.4)
                cgellipse(0,0,homingsize,homingsize)
                homer = 1;
                if thome == 0;
                thome = tic;
                end
            else
                homer = 0;
                thome = tic;
                cgpencol(0.6,0.6,0.6)
                cgellipse(0,0,homingsize,homingsize)
            end
%             cgpencol(0.6,0.6,0.6)
%             cgellipse(0,0,homingsize,homingsize)
           
            cgpencol(0.95,0.95,0.95);
            cgtext('+',0,0);
            cgdraw(joy1(2),joy1(1),joy1(2),joy1(1));
            cgflip(0,0,0);
%             tpause = time;
            tpre = toc(thome);
            
                
        end
%% START actual trial
ttarget = [];
tnow=0;
%             while ~isempty(ttarget) && (time - ttarget) < 200 %
            while target== 0 || toc(ttarget) < 1.5;
                
%% DRAW fixation cross
                cgpencol(0.6,0.6,0.6)
                cgellipse(0,0,homingsize,homingsize)
                cgpencol(0.95,0.95,0.95);
                cgtext('+',0,0);
%                 joy1=getsample(joy);
                [x,y]=cgmouse;joy1=[y,x];
                if side(a)==2;
                    joy1(1:2)=-joy1(1:2);%*sc;
                    cgpencol(1,0,0.3);
%                     puttarget=nrounds(a,:)/sc*-1;
                    puttarget=nrounds(a,:)/100*-1;
                else 
%                     joy1=joy1%*sc;
                    cgpencol(0,1,0.3);
%                     puttarget=nrounds(a,:)/sc;
                    puttarget=nrounds(a,:)/100;
                end
                if target == 1;
                    cgpencol(0.25,0.25,0.25);
                end
                    if isequal(closedmode,1);
                        joy1(nrounds(a,:)~=0)=0;
                    end
                    distance = sqrt((joy1(2)-nrounds(a,1)).^2+(joy1(1)-nrounds(a,2)).^2);
                run=run+1;
%                 if mod(run,2) == 0;
%% DRAW target circle to buffer                   
                  cgellipse(nrounds(a,1),nrounds(a,2),circlesize,circlesize,'f');
                  cgpencol(0.95,0.95,0.95);
%% DRAW cursor circle to buffer
%                   cgellipse(joy1(2),joy1(1),cursorsize,cursorsize,'f');
                  cgdraw(joy1(2),joy1(1),joy1(2),joy1(1));
%% RENDER buffer              
                if t1==0;
%                     putsample(ao,puttarget);
                    t1=cgflip(0,0,0); % t1 = start time of trial
                    tnow=t1;
                else
                    tnow=cgflip(0,0,0);
                end
%                 end
                
%% GET MOVEMENT ONSET FOR RT calculation               
                if sqrt(joy1(2)^2+joy1(1)^2) >= homingsize && starter == 0;                  
                    rt(a)=tnow-t1;
                    starter=1;
                end
             
                mv(run,1:3,a)=[joy1(1:2),tnow-t1];  
                
%% GET THRESHOLD CROSSING
            if distance < circlesize/2 && target == 0;
%                     putsample(ao,[0 0]);
                    target=1;                    
                    pt(a)=tnow-t1;
                    ttarget=tic;
%                     keyboard

            end
               
            end
%         save_timer(a);
%                 pause(posttrialtime);
    cs(a) = circlesize;
    circlesize = circlesize*(0.5+rand(1));
%     
    if  a > 1 && pt(a) < mean(pt(1:a));
        circlesize = circlesize - 5 ;
    elseif a > 1 && pt(a) > mean(pt(1:a));
        circlesize = circlesize + 5 ;
    end
            
    end
    
%     clear_timer;

%% ALL TRIALS ARE DONE, CLEAR SOME VARIABLES
    cgshut;

    clear joy;
    clear chan;
    save name;
    close all;
    x=1:number;
    uncrt=rt;
    %rt(rt<0.090)=nan;
    
%% PLOT OVERALL RESULTS
        
    all=[rt',pt',pt'-rt'];
    habit=all(side==1,:);
    odd=all(side==2,:);
    boxes=[habit(:,1),odd(:,1),habit(:,2),odd(:,2),habit(:,3),odd(:,3)];
    
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
    
    %% PLOT FIRST BLOCK

    BLOCK1all=[rt(1:number/3)',pt(1:number/3)',pt(1:number/3)'-rt(1:number/3)'];
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
    
    BLOCK2all=[rt(number/3+1:number/3*2)',pt(number/3+1:number/3*2)',pt(number/3+1:number/3*2)'-rt(number/3+1:number/3*2)'];
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
 
    BLOCK3all=[rt(number/3*2+1:number)',pt(number/3*2+1:number)',pt(number/3*2+1:number)'-rt(number/3*2+1:number)'];
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
    figure;
    for a=1:number;plot(mv(:,2,a),-mv(:,1,a),'LineSmoothing','on','color','k');hold on;plot(cos(1:360)*circlesize+nrounds(a,1),sin(1:360)*circlesize+nrounds(a,2),'Color','r');hold(gca,'on');end
    hold(gca,'off');
    figure;h=bar(x,(side(1,:)-1));set(h,'barwidth',1,'LineStyle','none','Facecolor',[0.6 0.6 0.6]);hold on;
    pl=plot(x,pt,x,rt,x,pt-rt,'LineWidth',2,'color','k');set(pl(1),'LineStyle','-','color','k');set(pl(2),'LineStyle','-.','color','g');set(pl(3),'LineStyle','--','color','r')
    xlim([0 number]);legend('Axis','Performance Time','Reaction Time','Movement Duration');
    
    %% PLOT ALL 3D FUNCTIONS
    
%     for a=1:10
%         figure;
%         mv(mv==0)=nan;
%         plot3(mv(:,3,a),mv(:,2,a),-mv(:,1,a),'LineWidth',3,'color','k','LineSmoothing','on');grid on;hold on;plot3(mv(:,3,a),ones(size(mv,1),1)*cos(1:360)*circlesize+nrounds(a,1),ones(size(mv,1),1)*sin(1:360)*circlesize+nrounds(a,2),'LineWidth',2,'color',[0.5 0.5 0.5],'LineSmoothing','on');hold on;
%         plot3(mv(1:end-1,3,a),diff(mv(:,2,a)),diff(-mv(:,1,a)),'LineWidth',3,'color','r','LineSmoothing','on');
%     
%     end

nanmean(pt)
    
    save(['behavPD/' name]);
%     keyboard
    