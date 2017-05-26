function outputfilename=wjn_visuomotor_tracking_import_pipeline(spikefile,taskfile)


% clear all
% close all
% addpath(fullfile(mdf,'visuomotor_tracking_ANA','scripts'))
% root = fullfile(mdf,'visuomotor_tracking_ANA','MatLab Export');
% cd(root)
% 


cmap = [colorlover(5,0); colorlover(6,0)];
pcolor = cmap([1 3 6 5 4 2 7 8 9 10],:);

plotit = 1;
indiexcel=0;
% 
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
% d = load(sfiles{nfile});



dt = load(taskfile);
loc = sort(unique(dt.nrounds));
d = load(spikefile);
fs =1/d.AO0.interval;
sk=round(.2*fs);
t=d.AO0.times;

ib1g = find(d.B1G.values);
ib1r = find(d.B1R.values);
ib2 = find(d.B2.values);
ib3g = find(d.B3G.values);
ib3r = find(d.B3R.values);

if length(ib1r)~=1
	error('less or more than one event found in EVENT CHANNEL IB1R - recheck spike file')
end
if length(ib1g)~=1
	error('less or more than one event found in EVENT CHANNEL IB1G - recheck spike file')
end
if length(ib2)~=1
	error('less or more than one event found in EVENT CHANNEL IB2 - recheck spike file')
end

if length(ib3r)~=1
	error('less or more than one event found in EVENT CHANNEL IB3R - recheck spike file')
end
if length(ib3g)~=1
	error('less or more than one event found in EVENT CHANNEL IB3G - recheck spike file')
end



conds = zeros(size(t));
if ib1g > ib1r
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

disp([num2str(length(ims)) ' movements found in EVENT CHANNEL MS'])

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

for a = 1:length(ims)
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
        if i==1
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
otib = [];
for a = 1:ntrials
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
   

    ny(a) = loc(sc(loc,ty(e(iy))));

   
    clear di dx dy
    xb = linspace(x(1),nx(a),numel(te));
    yb = linspace(y(1),ny(a),numel(te));
    for b = 1:length(te)
    di(b) = sqrt((rx(te(b))-nx(a))^2+(ry(te(b))-ny(a))^2);
    dis(b) = sqrt((x(te(b))-nx(a))^2+(y(te(b))-ny(a))^2);
    dx(b) = rx(te(b))-nx(a);
    dy(b)=ry(te(b))-ny(a);
    end    
    

    scf = 115/150;
    [acc(a) i] = min(di);
    acc(a) = 100-(acc(a)/dt.circledistance)*100;
    ib = find(di<37,1,'first');
    if isempty(ib)
        ib = length(di);
        otib = [otib a];
    end
    mv(a) = te(ib)-te(1)/fs*1000;
    trial(a,7) = te(i);
    tv = te(1):te(i);
    tb = te(1):te(ib);
    bv=[linspace(x(tv(1)),nx(a)*scf,numel(tb))' linspace(y(tv(1)),ny(a)*scf,numel(tb))'];
    vec=[x(tb) y(tb)];
    bi=[];sdi=[];
    for b=1:numel(tb)
        bi(b) = sqrt((bv(b,1)-vec(b,1))^2+(bv(b,2)-vec(b,2))^2);
        sdi(b) = sqrt((x(tb(b))-nx(a))^2+(y(tb(b))-ny(a))^2);
    end
    
    sbi(a) = std(bi)/mean(bi);
    asddi=abs(smooth(mydiff(sdi),sk));
    v(a) = max(asddi);
    av_v(a) = nanmean(asddi);
    if length(sdi)>.5*fs
         ml=1:round(0.5*fs);
    else
        ml = 1:length(sdi);
    end
    [~,iv(a)] = min(abs(mydiff(asddi(ml))));
    im_v(a) = asddi(iv(a));
    v1 = bv([1 iv(a)],:);
    v2 = vec([1 iv(a)],:);
    
    ang(a) = myangle(v1,v2);
    err(a) = ang(a)>90;
    pt(a) = rt(a)+mv(a);

    mbi{a,2}=bi;
    mbi{a,1}=tb-tb(1);
    mbi{a,3}=dis(1:length(tb));
    mbi{a,4}=x(tb);
    mbi{a,5}=y(tb);
    mbi{a,6}=asddi;
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
% outlier = find_outliers_Thompson(pt,0.01);
outlier = find(pt>(mean(pt)+2*std(pt)));
% outlier = find_outliers_Thompson([mv + rt],0.001); % Vorher rt 0.01
ot = logical(zeros(size(cond)));
ot(outlier) = 1;

ot(otib)=1;
% ot = mv+rt>8000;
color(find(ot)) = 6;

rblock = block;
rblock(find(diff(block)==-1)+1:end)=3;

ig1 = find(rblock==1&cond==1);
ir1 = find(rblock==1&cond==2);
ig2 = find(rblock==2&cond==1);
ir2 = find(rblock==2&cond==2);
ig3 = find(rblock==3&cond==1);
ir3 = find(rblock==3&cond==2);
ig13 = find(block==1&cond==1);
ir13 = find(block==2&cond==2);
ig123 = find(cond==1);
ir123 = find(cond==2);



npt = pt;
npt(ot)=nan;
nrt=rt;
nrt(ot)=nan;
nmv=mv;
nmv(ot)=nan;

ptlg1 = npt(rblock==1&cond==1);
ptlr1 = npt(rblock==1&cond==2);
ptlg3 = npt(rblock==3&cond==1);
ptlr3 = npt(rblock==3&cond==2);
ptlg2 = npt(rblock==2&cond==1);
ptlr2 = npt(rblock==2&cond==2);
ptlg13 = npt(block==1&cond==1);
ptlr13 = npt(block==1&cond==2);
ptlg123 = [ptlg1 ptlg2 ptlg3];
ptlr123 = [ptlr1 ptlr2 ptlr3];


rtlg1 = nrt(rblock==1&cond==1);
rtlr1 = nrt(rblock==1&cond==2);
rtlg3 = nrt(rblock==3&cond==1);
rtlr3 = nrt(rblock==3&cond==2);
rtlg2 = nrt(rblock==2&cond==1);
rtlr2 = nrt(rblock==2&cond==2);
rtlg13 = nrt(block==1&cond==1);
rtlr13 = nrt(block==1&cond==2);
rtlg123 = [rtlg1 rtlg2 rtlg3];
rtlr123 = [rtlr1 rtlr2 rtlr3];

mvlg1 = nmv(rblock==1&cond==1);
mvlr1 = nmv(rblock==1&cond==2);
mvlg3 = nmv(rblock==3&cond==1);
mvlr3 = nmv(rblock==3&cond==2);
mvlg2 = nmv(rblock==2&cond==1);
mvlr2 = nmv(rblock==2&cond==2);
mvlg13 = nmv(block==1&cond==1);
mvlr13 = nmv(block==1&cond==2);
mvlg123 = [mvlg1 mvlg2 mvlg3];
mvlr123 = [mvlr1 mvlr2 mvlr3];



[rptlg1,pptlg1]=wjn_pc(ptlg1');
[rptlg2,pptlg2]=wjn_pc(ptlg2');
[rptlg3,pptlg3]=wjn_pc(ptlg3');
[rptlr1,pptlr1]=wjn_pc(ptlr1');
[rptlr2,pptlr2]=wjn_pc(ptlr2');
[rptlr3,pptlr3]=wjn_pc(ptlr3');
[rptlg13,pptlg13]=wjn_pc(ptlg13');
[rptlr13,pptlr13]=wjn_pc(ptlr13');
[rptlg123,pptlg123]=wjn_pc(ptlg123');
[rptlr123,pptlr123]=wjn_pc(ptlr123');



[rrtlg1,prtlg1]=wjn_pc(rtlg1');
[rrtlg2,prtlg2]=wjn_pc(rtlg2');
[rrtlg3,prtlg3]=wjn_pc(rtlg3');
[rrtlr1,prtlr1]=wjn_pc(rtlr1');
[rrtlr2,prtlr2]=wjn_pc(rtlr2');
[rrtlr3,prtlr3]=wjn_pc(rtlr3');
[rrtlg13,prtlg13]=wjn_pc(rtlg13');
[rrtlr13,prtlr13]=wjn_pc(rtlr13');
[rrtlg123,prtlg123]=wjn_pc(rtlg123');
[rrtlr123,prtlr123]=wjn_pc(rtlr123');





[rmvlg1,pmvlg1]=wjn_pc(mvlg1');
[rmvlg2,pmvlg2]=wjn_pc(mvlg2');
[rmvlg3,pmvlg3]=wjn_pc(mvlg3');
[rmvlr1,pmvlr1]=wjn_pc(mvlr1');
[rmvlr2,pmvlr2]=wjn_pc(mvlr2');
[rmvlr3,pmvlr3]=wjn_pc(mvlr3');
[rmvlg13,pmvlg13]=wjn_pc(mvlg13');
[rmvlr13,pmvlr13]=wjn_pc(mvlr13');
[rmvlg123,pmvlg123]=wjn_pc(mvlg123');
[rmvlr123,pmvlr123]=wjn_pc(mvlr123');


% keyboard
if plotit
%     keyboard
close all
figure
subplot(4,4,1)
for a = 1:ntrials
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

subplot(4,4,2)


for a =1:ntrials
%     if ~ot(a)
    plot(mbi{a,1},mbi{a,2},'color',pcolor(color(a),:))
    hold on
%     end
end
xlabel('Movement time [ms]')
ylabel('Motor error [px]')

subplot(4,4,3)
for a =1:ntrials
%     if ~ot(a)
    plot(mbi{a,1},mbi{a,3},'color',pcolor(color(a),:))
    hold on
%     end
end
xlabel('Movement time [ms]')
ylabel('Target distance [px]')

subplot(4,4,4)
for a =1:ntrials
%     if ~ot(a)
    plot(mbi{a,1},mbi{a,6},'color',pcolor(color(a),:))
    hold on
%     end
end
xlabel('Movement time [ms]')
ylabel('Movement speed [au]')


subplot(4,4,5)
mybar({rt(~ot&cond==1&block==1)' rt(~ot&cond==2&block==1)' rt(~ot&cond==1&block==2)' rt(~ot&cond==2&block==2)' rt(~ot&swt==2 & cond == 1)' rt(~ot&swt==1 & cond==1)' rt(~ot&swt==2 & cond == 2)' rt(~ot&swt==1 & cond==2)'})
ylabel('Reaction time [ms]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,4,6)
mybar({mv(~ot&cond==1&block==1)' mv(~ot&cond==2&block==1)' mv(~ot&cond==1&block==2)' mv(~ot&cond==2&block==2)' mv(~ot&swt==2 & cond == 1)' mv(~ot&swt==1 & cond==1)' mv(~ot&swt==2 & cond == 2)' mv(~ot&swt==1 & cond==2)'})
ylabel('Movement time [ms]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,4,7)
mybar({v(~ot&cond==1&block==1)' v(~ot&cond==2&block==1)' v(~ot&cond==1&block==2)' v(~ot&cond==2&block==2)' v(~ot&swt==2 & cond == 1)' v(~ot&swt==1 & cond==1)' v(~ot&swt==2 & cond == 2)' v(~ot&swt==1 & cond==2)'})
ylabel('Maximum velocity [au]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,4,8)
mybar({av_v(~ot&cond==1&block==1)' av_v(~ot&cond==2&block==1)' av_v(~ot&cond==1&block==2)' av_v(~ot&cond==2&block==2)' av_v(~ot&swt==2 & cond == 1)' av_v(~ot&swt==1 & cond==1)' av_v(~ot&swt==2 & cond == 2)' av_v(~ot&swt==1 & cond==2)'})
ylabel('Average velocity [au]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,4,9)
mybar({im_v(~ot&cond==1&block==1)' im_v(~ot&cond==2&block==1)' im_v(~ot&cond==1&block==2)' im_v(~ot&cond==2&block==2)' im_v(~ot&swt==2 & cond == 1)' im_v(~ot&swt==1 & cond==1)' im_v(~ot&swt==2 & cond == 2)' im_v(~ot&swt==1 & cond==2)'})
ylabel('Impulse velocity [au]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,4,10)
mybar({merror(~ot&cond==1&block==1)' merror(~ot&cond==2&block==1)' merror(~ot&cond==1&block==2)' merror(~ot&cond==2&block==2)' merror(~ot&swt==2 & cond == 1)' merror(~ot&swt==1 & cond==1)' merror(~ot&swt==2 & cond == 2)' merror(~ot&swt==1 & cond==2)'})
ylabel('Movement error [px]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})


subplot(4,4,11)
mybar({ang(~ot&cond==1&block==1)' ang(~ot&cond==2&block==1)' ang(~ot&cond==1&block==2)' ang(~ot&cond==2&block==2)' ang(~ot&swt==2 & cond == 1)' ang(~ot&swt==1 & cond==1)' ang(~ot&swt==2 & cond == 2)' ang(~ot&swt==1 & cond==2)'})
ylabel('Angular error [°]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

subplot(4,4,12)
mybar({acc(~ot&cond==1&block==1)' acc(~ot&cond==2&block==1)' acc(~ot&cond==1&block==2)' acc(~ot&cond==2&block==2)' acc(~ot&swt==2 & cond == 1)' acc(~ot&swt==1 & cond==1)' acc(~ot&swt==2 & cond == 2)' acc(~ot&swt==1 & cond==2)'})
ylabel('Accuracy [%]')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})
ylim([77 100])

subplot(4,4,13)
mybar({sbi(~ot&cond==1&block==1)' sbi(~ot&cond==2&block==1)' sbi(~ot&cond==1&block==2)' sbi(~ot&cond==2&block==2)' sbi(~ot&swt==2 & cond == 1)' sbi(~ot&swt==1 & cond==1)' sbi(~ot&swt==2 & cond == 2)' sbi(~ot&swt==1 & cond==2)'})
ylabel('Variance')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})

% subplot(4,4,14)
% mybar({serror(~ot&cond==1&block==1)' serror(~ot&cond==2&block==1)' serror(~ot&cond==1&block==2)' serror(~ot&cond==2&block==2)'})
% ylabel('Movement error [std]')
% set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2'})
% 

subplot(4,4,14)
mybar({sum(err(~ot&cond==1&block==1))' sum(err(~ot&cond==2&block==1))' sum(err(~ot&cond==1&block==2))' sum(err(~ot&cond==2&block==2))' sum(err(~ot&swt==2 & cond==1))' sum(err(~ot&swt==1 & cond==1))' sum(err(~ot&swt==2 & cond==2))' sum(err(~ot&swt==1 & cond==2))' })
ylabel('N Erorrs')
set(gca,'XTick',[1:8],'XTickLabel',{'A B1','C B1','A B2','C B2','A S','A NS','C S','C NS'})
figone(30,45)
annotation('textbox',[.69 .17 .1 .1],'string',{strrep(dt.patcode,'_',' '),['condition: ' dt.cond],['Trials: ' num2str(ntrials)],['Errors: ' num2str(sum(err))],['Outliers: ' num2str(sum(ot))]})
% 
myprint(fullfile(cd,'result_images',[dt.patcode '_' dt.cond]))


figure
subplot(1,3,1)
[r1,p1,s1]=wjn_corr_plot(ptlg1');
set(s1,'MarkerFaceColor',[0    0.6275    0.6902])
[r2,p2,s2]=wjn_corr_plot(ptlr1');
set(s2,'MarkerFaceColor',[0.8000    0.2000    0.2471])
title('Block 1')
ylim([0 max(ptlr1)])
xlim([1 30])
xlabel('N trial')
ylabel('Performance Time [ms]')
legend([s1 s2],{['Rho  = ' num2str(r1) ' P = ' num2str(p1)],['Rho  = ' num2str(r2) ' P = ' num2str(p2)]})
subplot(1,3,2)
[r1,p1,s1]=wjn_corr_plot(ptlg2');
set(s1,'MarkerFaceColor',[0    0.6275    0.6902])
[r2,p2,s2]=wjn_corr_plot(ptlr2');
set(s2,'MarkerFaceColor',[0.8000    0.2000    0.2471])
title('Block 2')
ylim([0 max(ptlr2)])
xlim([1 30])
xlabel('N trial')
ylabel('Performance Time [ms]')
legend([s1 s2],{['Rho  = ' num2str(r1) ' P = ' num2str(p1)],['Rho  = ' num2str(r2) ' P = ' num2str(p2)]})
subplot(1,3,3)
[r1,p1,s1]=wjn_corr_plot(ptlg3');
set(s1,'MarkerFaceColor',[0    0.6275    0.6902])
[r2,p2,s2]=wjn_corr_plot(ptlr3');
set(s2,'MarkerFaceColor',[0.8000    0.2000    0.2471])
title('Block 3')
ylim([0 max(ptlr3)])
xlim([1 30])
xlabel('N trial')
ylabel('Performance Time [ms]')
legend([s1 s2],{['Rho  = ' num2str(r1) ' P = ' num2str(p1)],['Rho  = ' num2str(r2) ' P = ' num2str(p2)]})
figone(12,30)
myprint(fullfile(cd,'result_images',['Learning_' dt.patcode '_' dt.cond]))

end

names ={'Ntrial','Block','Block13as1','Condition','SwitchTrials','Outlier','ReactionTime','MovementTime','PerformanceTime','MaximumVelocity','MeanVelocity','ImpulseVelocity','TrajectoryError','AngularError','Accuracy','MovementVariance','ErrorTrial'};
vars = {'a','rblock','block','cond','swt','ot','rt','mv','pt','v','av_v','im_v','merror','ang','acc','sbi','err'};

rblock=block;
rblock(find(diff(block))+1:end)=3;
% keyboard

for a = 1:ntrials
    results(a,1) = a;
    for b = 2:length(vars)%+1
        results(a,b) = eval([vars{b} '(a)']);
    end
end

% if indiexcel
%     mkdir('excelfile')
%     xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),{dt.name},2,'A1')
%     xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),{dt.name,'no outliers'},3,'A1')
%     xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),names,2,'A2')
%     xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),results,2,'A3')
%     xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),names,3,'A2')
%     xlswrite(fullfile(cd,'excelfiles',[dt.name '.xls']),results(~ot,:),3,'A3')
% end   



vars = {'a','rblock','cond','swt','ot','rt','mv','pt','av_v','im_v','v','merror','ang','acc','sbi','err'};
mconds={'(~ot&cond==1&block==1)','(~ot&cond==2&block==1)','(~ot&cond==1&block==2)','(~ot&cond==2&block==2)','(~ot&swt==2&block==2)','(~ot&swt==1&block==2)',...
        '(~ot&swt==2 & cond == 1)','(~ot&swt==1 & cond == 1)','(~ot&swt==2 & cond == 2)','(~ot&swt==1 & cond == 2)'};
mode = {'nanmean(','sum('};
for a = 6:length(vars)
    if strcmp(vars{a},'err')
        cmode = mode{2};
    else
        cmode=mode{1};
    end
    for b=1:length(mconds)
    r.(vars{a})(b) = eval([cmode vars{a} mconds{b} ')'])';
    end
  
end



fnames = fieldnames(r);

for a = 1:length(fnames);
    nr.(fnames{a}) = r.(fnames{a})';
end
r.conds = {'A B1','C B1','A B2','C B2','S B2','NS B2','A S','A NS','C S','C NS'};

average_table = struct2table(nr,'RowNames',{'Automatic_B13','Controlled_B13','Automatic_B2','Controlled_B2','Switch_B2','NoSwitch_B2','Switch_Automatic_B2','NoSwitch_Automatic_B2','Switch_Controlled_B2','NoSwitch_Controlled_B2'});
trial_table = array2table(results,'VariableNames',names);


r.conds = {'A B1','C B1','S B2','NS B2','A S','A NS','C S','C NS'};
outputfilename=['r' dt.patcode '_' dt.cond];


lvars = {'rt','pt','mv'};
lblocks = {'1','2','3','13','123'};
lconds = {'lg','lr'};
lprefs = {'','r','p'};

nl = 0;
% keyboard
for a = 1
    for b = 1:length(lvars)
        for c = 1:length(lconds)
            for d = 1:length(lblocks)
                nl=nl+1;
                cvar=[lprefs{a} lvars{b} lconds{c} lblocks{d}];
                l.([lprefs{a} 'l']).(cvar) = eval(cvar);
            end
        end
    end
end

for a = 2:length(lprefs)
    for b = 1:length(lvars)
        for c = 1:length(lconds)
            cvar = ['['];
            for d = 1:length(lblocks)
                nl=nl+1;
                cvar=[cvar ' ' lprefs{a} lvars{b} lconds{c} lblocks{d}];
                
            end
                l.([lprefs{a}]).(lconds{c}) = eval([cvar ']']);
        end
    end
end

% for a = 1:

save(outputfilename)
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

