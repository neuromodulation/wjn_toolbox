function D=wjn_beta_invaders_import(filename)
d=load(filename);
t = d.P_SIDE.times;
fsample = 1/d.P_SIDE.interval;
side = round(d.P_SIDE.values.*100);
speed = round(d.P_SPEED.values.*100);
dummy = zeros(size(t));
spacer = 0.001*fsample;
dside = dummy;
dspeed = dummy;
btnL = dummy;
btnR = dummy;
btnL = d.BTN_L.values;
btnR = d.BTN_R.values;
bpL = mythresh(btnL,4);
bpR = mythresh(btnR,4);
dside(1:end-1) = diff(side);
dspeed(1:end-1) = diff(speed);

figure
subplot(2,1,1)
plot(t,side,t,dside)
subplot(2,1,2)
plot(t,speed,t,dspeed)
legend('original','diff')
hold on

fb = find(dside>=500); %% find start marker
ifb = fb(1)+fsample/5:fb(2)-fsample/5; % mark 
fside = side(ifb); 
fspeed = speed(ifb);
fdside = dside(ifb);
fdspeed = dspeed(ifb);
tf = linspace(0,numel(ifb)/fsample,numel(ifb));
trlstart=mythresh(speed,-50);
sstart = mythresh(side,99);
sstop = mythresh(-side,-99);
n=0;trl = nan(1,6);
for a = 1:numel(sstart);
    i = find(sstop>sstart(a),1);
    if diff([sstart(a) sstop(i)])>.3*fsample && std(side(sstart(a)+fsample/100:sstop(i)-fsample/100))<1
        n=n+1;
        trl(n,1:2) = [sstart(a) sstop(i)];
        trl(n,3) = round(side(sstart(a)+spacer)/100);
    end
end
% 
figure
plot(t,side,t,speed)
hold on
scatter(t(trl(:,1)),side(trl(:,1)))
scatter(t(trl(:,2)),side(trl(:,2)))
xlim([t(trl(1,1)) t(trl(end,2))])


for a = 1:length(trl)
    
    
    if speed(trl(a,2)-spacer)<0;
        trl(a,4) = 0;
    else
        trl(a,4) = ceil(((422-speed(trl(a,2)-spacer))/422)*1000);
    end
        trl(a,5) = max(-speed(trl(a,1)-spacer:trl(a,1)+spacer))*10;
    
    ibpL = find(bpL >trl(a,1) & bpL<trl(a,2));     
    ibpR = find(bpR >trl(a,1) & bpR<trl(a,2));
    if trl(a,4)>0 && sum([isempty(ibpL) ;isempty(ibpR)])==1 && ~isempty(ibpL) && trl(a,3)>=2;
        trl(a,6) = bpL(ibpL(1));
        trl(a,7) = (bpL(ibpL(1))-trl(a,1))/fsample;
        trl(a,8) = 1;
    elseif trl(a,4)>0 && sum([isempty(ibpL) ;isempty(ibpR)])==1 && ~isempty(ibpR) && trl(a,3)<=2;
        trl(a,6) = bpR(ibpR(1));
        trl(a,7) = (bpR(ibpR(1))-trl(a,1))/fsample;
        trl(a,8) = 2;
    else
        trl(a,6) = nan;
        trl(a,7) = nan;
        trl(a,8) = nan;
    end
    
end
trl(:,9)=1:length(trl);

istf=mythresh(-abs(mydiff(trl(:,5))),-50);
istf=istf(end);

islow = []; imedium = []; ifast = [];
for a = 1:istf;
    if round(trl(a,5)/100)==18;
        trl(a,10) = 1;
        islow = [islow  a];
    elseif round(trl(a,5)/100)==13;
        trl(a,10) = 2;
        imedium = [imedium  a];
    elseif round(trl(a,5)/100)==8;
        trl(a,10) = 3;
        ifast = [ifast  a];
    end
end

trl(~trl(:,4),2) = trl(~trl(:,4),2)-fsample;
trl(~isnan(trl(:,6)),11) = 1;
trl(~trl(:,4),12) = 1;
trl(istf:size(trl,1),13) = 1;

trl(find(sum([trl(:,11) trl(:,12)],2)==0),:)=[];

ifb = find(~isnan(trl(istf:end,6))&trl(istf:end,5)>=500)+istf-1;
staircorr = trl(ifb,[4,5,7,9]);

dummychannel = d.BTN_L;
dummychannel.values=dummy;
dummychannel = rmfield(dummychannel,'scale');
% 
d.bp = dummychannel;
d.bp.values(trl(find(trl(:,11)),6))=1;
d.bp.title = 'btn';
d.bp.times = d.BTN_L.times;

istf=mythresh(-abs(mydiff(trl(:,5))),-50);
istf=istf(end);
ifb = find(~isnan(trl(istf:end,6))&trl(istf:end,5)>=500)+istf-1;
staircorr = trl(ifb,[4,5,7,9]);

% d.st = dummychannel;
% d.st.values(trl(ifb,6))=1;
% d.st.title = 'stair';
% d.st.times = d.BTN_L.times;




% 
% d.ts = dummychannel;
% d.ts.values(trl(:,1))=1;
% d.ts.title = 'allstart';
% d.ts.times = d.BTN_L.times;

d.cs = dummychannel;
d.cs.values(trl(find(trl(:,12)),2))=1;
d.cs.title = 'crash';
d.cs.times = d.BTN_L.times;
% 
% d.sls = dummychannel;
% d.sls.values(trl(round(trl(1:istf,5)/100)==18&trl(1:istf,4),1))=1;
% d.sls.title = 'slowstart';
% d.sls.times = d.BTN_L.times;

% islb = trl(round(trl(1:istf,5)/100)==18&trl(1:istf,4)>=500,6);
% islb(isnan(islb))=[];
% d.slb = dummychannel;
% d.slb.values(islb)=1;
% d.slb.title = 'slowbp';
% d.slb.times = d.BTN_L.times;
% 
% d.mes = dummychannel;
% d.mes.values(trl(trl(:,5)==1300&trl(:,4),1))=1;
% d.mes.title = 'mediumstart';
% d.mes.times = d.BTN_L.times;
% imeb = trl(round(trl(1:istf,5)/100)==13&trl(1:istf,4)>=500,6);
% imeb(isnan(imeb))=[];
% d.meb = dummychannel;
% d.meb.values(imeb)=1;
% d.meb.title = 'mediumbp';
% d.meb.times = d.BTN_L.times;
% 
% d.fas = dummychannel;
% d.fas.values(trl(trl(:,5)==800&trl(:,4),1))=1;
% d.fas.title = 'faststart';
% d.fas.times = d.BTN_L.times;
% ifab = trl(round(trl(1:istf,5)/100)==8&trl(1:istf,4)>=500,6);
% ifab(isnan(ifab))=[];
% d.fab = dummychannel;
% d.fab.values(ifab)=1;
% d.fab.title = 'fastbp';
% d.fab.times = d.BTN_L.times;

save(['itrl' filename],'-struct','d')
ibtn = find(~isnan(trl(:,6)));
D=wjn_spikeconvert(['itrl' filename],[-2 2],4);
D.trl = trl;
D.istf = istf;
D.trlnames = {'istart','iend','side','reward','speed','ibtn','rt','btnside','n','size','btntrial','crashtrial','stairtrial'};
save(D);
% D=wjn_tf(D.fullfile);
