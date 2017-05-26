
clear all
close all
addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
cd(root)



cmap = [colorlover(5,0); colorlover(6,0)];
pcolor = cmap([1 3 6 5 4 2 7 8 9 10],:);

sfiles = ffind('s*.mat')
plotit = 0;
indiexcel=0;
for nfile =1:length(sfiles)
    keep nfile sfiles pcolor plotit indiexcel
% MS: Movement start ? Beginn einer zielgerichteten Bewegung 
% ER:  Markiert im Tief-/Höhepunkt; wenn mehrere Fehler nacheinander, dann Höhepunkt des letztens; kein Fehler, wenn nicht durch die 0-Linie 
% B1G: 1. Trial Block 1 Grün
% B1R: 1. Trial Block 1 Rot
% B2: 1. Trial des 2. Blocks
% B3G: 1. Trial Block 3 Grün
% B3R:  1. Trial Block 3 Rot
% D0: automatic condition
% D1: controlled condition 
% AO1: y-Achse 
% AO0: x-Achse

% loc = [-1.8 -0.86 0 0.86 1.8]
sr = [640 480;800 600;1024 768];
d = load(sfiles{nfile});



dt = load(['t' sfiles{nfile}(2:end)]);
loc = sort(unique(dt.nrounds));
d = load(sfiles{nfile});
fs =1/d.AO0.interval;
sk=round(.2*fs);
t=d.AO0.times;



ib1g = find(d.B1G.values);

ib1r = find(d.B1R.values);
ib2 = find(d.B2.values);
ib3g = find(d.B3G.values);
if ~isfield(d,'B3R') && nfile == 41
ib3r = ib3g;
ib3g = 1105694;
else
ib3r = find(d.B3R.values);
end

if nfile == 11
    ib3g=ib1g(2);
    ib1g=ib1g(1);
end
conds = zeros(size(t));
if ib1g > ib1r;
    order = 2;
    conds(ib1r:ib1g)=2;
    conds(ib1g:ib2)=1;
    conds(ib3r:ib3g)=2;
    conds(ib3g:end)=1;
    conds(ib2:ib3r)=3;
else
    order = 1;
    conds(ib1g:ib1r)=1;
    conds(ib3g:ib3r)=1;
    conds(ib1r:ib2)=2;
    conds(ib3r:end)=2;
    conds(ib2:ib3g)=3;
end


ry = (d.AO1.values*.5*sr(dt.screen_resolution,2))./5;
rx = (d.AO0.values*.5*sr(dt.screen_resolution,1))./5;
ty = d.AO1.values*dt.sc;
tx = d.AO0.values*dt.sc;

y = smooth(ry,sk);
x = smooth(rx,sk);
rdx=mydiff(rx);
rdy=mydiff(ry);
% dx = smooth(rdx,sk);
% dy = smooth(rdy,sk);
ims = find(d.MS.values);


if nfile == 15
    ims(181)=[];
end

if nfile == 8
    ims(154) = [];
end

if ~isfield(d,'D0')
    d.D0 = d.Autom_;
    d.D1 = d.Contr_;
end
iac = find(d.D0.values);
icc = find(d.D1.values);

% figure,
% subplot(2,1,1)
% plot(t,rx)
% hold on
% plot(t(iac),rx(iac),'r+')
% xlim([0 50]),ylim([-10 10])
% 
% subplot(2,1,2)
% plot(t,ry)
% hold on
% plot(t(iac),ry(iac),'r+')
% xlim([0 50]),ylim([-10 10])

for a = 1:length(ims);
    cond(a) = conds(ims(a));
    if cond(a) ==1
        block(a) = 1;
        iiac=sc(iac(iac<ims(a)),ims(a));
        cue(a) = iac(iiac);
        trial(a,:) =  [a block(a) cue(a) ims(a) iac(iiac+1) iac(iiac+2)]; 
        rt(a)=abs(diff([cue(a),ims(a)]));
      
 
        color(a) = 1;
    
        
    elseif cond(a) ==2
        block(a) = 1;
        iicc=sc(icc(icc<ims(a)),ims(a));
        cue(a) = icc(iicc);
        rt(a)=abs(diff([cue(a),ims(a)]));
        trial(a,:) =  [a block(a) cue(a) ims(a) icc(iicc+1) icc(iicc+2)]; 
        color(a) = 2;
    elseif cond(a) ==3
        block(a) = 2;
            [rt(a),i] = min([abs(diff([iac(sc(iac(iac<ims(a)),ims(a))),ims(a)])) abs(diff([icc(sc(icc(icc<ims(a)),ims(a))),ims(a)]))]) ;
            cond(a) = i;
        if i==1;
            cue(a) = iac(sc(iac(iac<ims(a)),ims(a)));
            trial(a,:) =  [a block(a) cue(a) ims(a) iac(sc(iac(iac<ims(a)),ims(a))+1) iac(sc(iac(iac<ims(a)),ims(a))+2)]; 
            color(a) = 3;
        else
            cue(a) = icc(sc(icc(icc<ims(a)),ims(a)));
            trial(a,:) =  [a block(a) cue(a) ims(a) icc(sc(icc(icc<ims(a)),ims(a))+1) icc(sc(icc(icc<ims(a)),ims(a))+2)]; 
            color(a) =4;
        end
    end
end
   %
ntrials = length(ims);

for a = 1:ntrials;
    di=[];te=[]; 
    e = trial(a,5)+10:trial(a,6)-10;
    te=trial(a,4):trial(a,5);
    [m,iy]=max(abs(ty(e)));
   [m,ix]=max(abs(tx(e)));
   if abs(tx(e(ix)))<100
       nx(a) = 0;
   else
    nx(a) = loc(sc(loc,tx(e(ix))));
   end
   
   if abs(ty(e(iy)))<100 || (a==60 && strcmp(dt.patcode,'PD_STN_DBS25GM65-2-05-05-2015') && strcmp(dt.cond,'s0m1'))
       ny(a) = 0;
   else
    ny(a) = loc(sc(loc,ty(e(iy))));
   end
   
    clear di dx dy
    xb = linspace(x(1),nx(a),numel(te));
    yb = linspace(y(1),ny(a),numel(te));
    for b = 1:length(te);
    di(b) = sqrt((rx(te(b))-nx(a))^2+(ry(te(b))-ny(a))^2);
    dis(b) = sqrt((x(te(b))-nx(a))^2+(y(te(b))-ny(a))^2);
    dx(b) = rx(te(b))-nx(a);
    dy(b)=ry(te(b))-ny(a);
    end    
    

    scf = 115/150;
    [acc(a) i] = min(di);
    acc(a) = 100-(acc(a)/dt.circledistance)*100;
    ib = find(di<37,1,'first');
    mv(a) = te(ib)-te(1)/fs*1000;
    trial(a,7) = te(i);
    tv = te(1):te(i);
    tb = te(1):te(ib);
    bv=[linspace(x(tv(1)),nx(a)*scf,numel(tb))' linspace(y(tv(1)),ny(a)*scf,numel(tb))'];
    vec=[x(tb) y(tb)];
    bi=[];sdi=[];
    for b=1:numel(tb);
        bi(b) = sqrt((bv(b,1)-vec(b,1))^2+(bv(b,2)-vec(b,2))^2);
        sdi(b) = sqrt((x(tb(b))-nx(a))^2+(y(tb(b))-ny(a))^2);
    end
    
    sbi(a) = std(bi)/mean(bi);
    v(a) = max(abs(mydiff(sdi)));
    if length(sdi)>500
        ml = 500;
    else
        ml = length(sdi);
    end
    [~,iv] = max(abs(mydiff(sdi(1:ml))));
    v1 = bv([1 iv],:);
    v2 = vec([1 iv],:);
    
    ang(a) = myangle(v1,v2);
    err(a) = ang(a)>90;
    pt(a) = rt(a)+mv(a);

    mbi{a,2}=bi;
    mbi{a,1}=tb-tb(1);
    mbi{a,3}=dis(1:length(tb));
    mbi{a,4}=x(tb);
    mbi{a,5}=y(tb);
    cumerror(a) = sum(bi);
    merror(a)=nanmean(bi);
    serror(a) = sem(bi);


if block(a) ==2 && block(a-1) ==2
    if cond(a) ~= cond(a-1)
        swt(a) =2;
    else
        swt(a) = 1;
    end
else
    swt(a) = 0;
end

end
outlier = find_outliers_Thompson(rt,0.01);
% outlier = find_outliers_Thompson([mv + rt],0.001); % Vorher rt 0.01
ot = zeros(size(cond));
ot(outlier) = 1;
% ot = mv+rt>8000;
color(find(ot)) = 6;

if plotit
close all
figure
subplot(4,3,1)
for a = 1:ntrials;
    plot(mbi{a,4},mbi{a,5},'color',pcolor(color(a),:))
    hold on
    plot([0 nx(a)],[0 ny(a)],'color','k') 
    th = 0:pi/1000:2*pi;xunit = dt.circlesize/2 * cos(th) + nx(a);yunit = dt.circlesize/2 * sin(th) + ny(a);
    plot(xunit, yunit,'color','k');
end
xlabel('X Axis');
ylabel('Y Axis')
title('All trials')
xlim([-400 400])
ylim([-300 300])

subplot(4,3,2)


for a =1:ntrials;
%     if ~ot(a)
    plot(mbi{a,1},mbi{a,2},'color',pcolor(color(a),:))
    hold on
%     end
end
xlabel('Movement time [ms]')
ylabel('Motor error [px]')

subplot(4,3,3)
for a =1:ntrials;
%     if ~ot(a)
    plot(mbi{a,1},mbi{a,3},'color',pcolor(color(a),:))
    hold on
%     end
end
xlabel('Movement time [ms]')
ylabel('Target distance [px]')

subplot(4,3,4)
mybar({rt(~ot&cond==1&block==1)' rt(~ot&cond==2&block==1)' rt(~ot&cond==1&block==2)' rt(~ot&cond==2&block==2)' rt(~ot&swt==2 & cond == 1)' rt(~ot&swt==1 & cond==1)' rt(~ot&swt==2 & cond == 2)' rt(~ot&swt==1 & cond==2)'})
ylabel('Reaction time [ms]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,3,5)
mybar({mv(~ot&cond==1&block==1)' mv(~ot&cond==2&block==1)' mv(~ot&cond==1&block==2)' mv(~ot&cond==2&block==2)' mv(~ot&swt==2 & cond == 1)' mv(~ot&swt==1 & cond==1)' mv(~ot&swt==2 & cond == 2)' mv(~ot&swt==1 & cond==2)'})
ylabel('Movement time [ms]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,3,6)
mybar({v(~ot&cond==1&block==1)' v(~ot&cond==2&block==1)' v(~ot&cond==1&block==2)' v(~ot&cond==2&block==2)' v(~ot&swt==2 & cond == 1)' v(~ot&swt==1 & cond==1)' v(~ot&swt==2 & cond == 2)' v(~ot&swt==1 & cond==2)'})
ylabel('Maximum velocity [au]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,3,7)
mybar({merror(~ot&cond==1&block==1)' merror(~ot&cond==2&block==1)' merror(~ot&cond==1&block==2)' merror(~ot&cond==2&block==2)' merror(~ot&swt==2 & cond == 1)' merror(~ot&swt==1 & cond==1)' merror(~ot&swt==2 & cond == 2)' merror(~ot&swt==1 & cond==2)'})
ylabel('Movement error [px]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

% subplot(4,3,8)
% mybar({serror(cond==1&block==1)' serror(cond==2&block==1)' serror(cond==1&block==2)' serror(cond==2&block==2)'})
% ylabel('Movement error [std]')
% set(gca,'XTick',[1:4],'XTickLabel',{'A B1','C B1','A B2','C B2'})

subplot(4,3,8)
mybar({ang(~ot&cond==1&block==1)' ang(~ot&cond==2&block==1)' ang(~ot&cond==1&block==2)' ang(~ot&cond==2&block==2)' ang(~ot&swt==2 & cond == 1)' ang(~ot&swt==1 & cond==1)' ang(~ot&swt==2 & cond == 2)' ang(~ot&swt==1 & cond==2)'})
ylabel('Angular error [°]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,3,9)
mybar({acc(~ot&cond==1&block==1)' acc(~ot&cond==2&block==1)' acc(~ot&cond==1&block==2)' acc(~ot&cond==2&block==2)' acc(~ot&swt==2 & cond == 1)' acc(~ot&swt==1 & cond==1)' acc(~ot&swt==2 & cond == 2)' acc(~ot&swt==1 & cond==2)'})
ylabel('Accuracy [%]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})
ylim([77 100])

subplot(4,3,10)
mybar({sbi(~ot&cond==1&block==1)' sbi(~ot&cond==2&block==1)' sbi(~ot&cond==1&block==2)' sbi(~ot&cond==2&block==2)' sbi(~ot&swt==2 & cond == 1)' sbi(~ot&swt==1 & cond==1)' sbi(~ot&swt==2 & cond == 2)' sbi(~ot&swt==1 & cond==2)'})
ylabel('Variance')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,3,11)
mybar({sum(err(~ot&cond==1&block==1))' sum(err(~ot&cond==2&block==1))' sum(err(~ot&cond==1&block==2))' sum(err(~ot&cond==2&block==2))' sum(err(~ot&swt==2 & cond==1))' sum(err(~ot&swt==1 & cond==1))' sum(err(~ot&swt==2 & cond==2))' sum(err(~ot&swt==1 & cond==2))' })
ylabel('N Erorrs')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})
figone(30,35)
annotation('textbox',[.69 .17 .1 .1],'string',{strrep(dt.patcode,'_',' '),['condition: ' dt.cond],['Trials: ' num2str(ntrials)],['Errors: ' num2str(sum(err))],['Outliers: ' num2str(sum(ot))]})
% 
myprint(fullfile(cd,'result_images2',[dt.patcode '_' dt.cond]))

end

names ={'N','Block','Cond','SWT','OT','RT','MV','PT','v','merror','ANG','ACC','sbi','ERR'};
vars = {'a','block','cond','swt','ot','rt','mv','pt','v','merror','ang','acc','sbi','err'};



for a = 1:ntrials
    results(a,1) = a;
    for b = 2:length(vars)+1;
results(a,b) = eval([vars{b} '(a)']);
    end
end

if indiexcel
xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),{dt.name},2,'A1')
xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),{dt.name,'no outliers'},3,'A1')
xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),names,2,'A2')
xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),results,2,'A3')
xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),names,3,'A2')
xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),results(~ot,:),3,'A3')
end   

vars = {'a','block','cond','swt','ot','rt','mv','pt','v','merror','ang','acc','sbi','err'};
mconds={'(~ot&cond==1&block==1)','(~ot&cond==2&block==1)','(~ot&swt==2&block==2)','(~ot&swt==1&block==2)',...
        '(~ot&swt==2 & cond == 1)','(~ot&swt==1 & cond == 1)','(~ot&swt==2 & cond == 2)','(~ot&swt==1 & cond == 2)'};
mode = {'nanmean(','sum('};
for a = 6:length(vars);
    if strcmp(vars{a},'err')
        cmode = mode{2};
    else
        cmode=mode{1};
    end
    for b=1:length(mconds);
    r.(vars{a})(b) = eval([cmode vars{a} mconds{b} ')']);
    end
  
end

r.conds = {'A B1','C B1','S B2','NS B2','A S','A NS','C S','C NS'};

save(['r' dt.patcode '_' dt.cond])
% clear r
% mconds={'(cond==1&block==1)','(cond==2&block==1)','(swt==2&block==2)','(swt==1&block==2)',...
%         '(swt==2 & cond == 1)','(swt==1 & cond == 1)','(swt==2 & cond == 2)','(swt==1 & cond == 2)'};
% mode = {'nanmean(','sum('};
% for a = 6:length(vars);
%     if strcmp(vars{a},'err')
%         cmode = mode{2};
%     else
%         cmode=mode{1};
%     end
%     for b=1:length(mconds);
%     r.(vars{a})(b) = eval([cmode vars{a} mconds{b} ')']);
%     end
%   
% end
% 
% r.conds = {'A B1','C B1','S B2','NS B2','A S','A NS','C S','C NS'};
% 
% save(['ot' dt.patcode '_' dt.cond])

end