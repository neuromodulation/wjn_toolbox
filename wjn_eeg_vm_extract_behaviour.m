function D = wjn_eeg_vm_extract_behaviour(filename)

xch = 'X';
ych = 'Y';

D=wjn_sl(filename);
chs=ci({xch,ych},D.chanlabels);
imovecond = ci('move',D.conditions);


d = D(chs,:,imovecond);
dummy = zeros(1,D.nsamples);
dstart = squeeze(D(chs,D.indsample(0),imovecond));
sk=.1;
for a = 1:length(imovecond)
    is = D.indsample(0);
    nd = wjn_distance(squeeze(d(:,:,a))',dstart(:,a)');
    mnd(a,:)=nd;
    if sk>D.mt(a)
        csk = D.mt(a);
    else
        csk = sk;
    end
    ii = is:is+round(D.mt(a)*D.fsample);
    ii(ii>length(nd))=[];
    tnd = fastsmooth(nd(ii),round(D.fsample*csk),1,1);
    rtnd = tnd./max(tnd);
    x = 1:length(rtnd)';
    y = linspace(rtnd(1),rtnd(end),length(rtnd))';
    merr(a) = nanmean(abs(y-rtnd));
    drtnd = mydiff(rtnd);
    mdrtnd{a}=drtnd;
    D.cvelocity(a,:) = dummy;
    D.cvelocity(a,ii) = drtnd;
    D.cerror(a,:) = dummy;
    D.cerror(a,ii) = y-rtnd;
    avg_v(a) = nanmean(drtnd);
    max_v(a) = nanmean(max(drtnd));
end

D.merr = merr';
D.avg_v = avg_v';
D.max_v = max_v';

aut_ord = ci('stop_aut',D.conditions)./3;
con_ord = ci('stop_con',D.conditions)./3;

D.mrt = [nanmean(D.rt(aut_ord)) nanmean(D.rt(con_ord)) nanmean(D.rt(con_ord))-nanmean(D.rt(aut_ord))];
D.mmt = [nanmean(D.mt(aut_ord)) nanmean(D.mt(con_ord)) nanmean(D.mt(con_ord))-nanmean(D.mt(aut_ord))];
D.mpt = [nanmean(D.pt(aut_ord)) nanmean(D.pt(con_ord)) nanmean(D.pt(con_ord))-nanmean(D.pt(aut_ord))];

D.mmerr = [nanmean(D.merr(aut_ord)) nanmean(D.merr(con_ord)) nanmean(D.merr(con_ord))-nanmean(D.merr(aut_ord))];

D.mavg_v = [nanmean(D.avg_v(aut_ord)) nanmean(D.avg_v(con_ord)) nanmean(D.avg_v(con_ord))-nanmean(D.avg_v(aut_ord))];
D.mmax_v = [nanmean(D.max_v(aut_ord)) nanmean(D.max_v(con_ord)) nanmean(D.max_v(con_ord))-nanmean(D.max_v(aut_ord))];
save(D)


t=table;
t.RT = D.mrt';
t.MT = D.mmt';
t.maxV = D.mmax_v';
t.avgV = D.mavg_v';
t.E = D.mmerr';
t.Properties.RowNames = {'Automatic','Controlled','Controlled-Automatic'};


fname = D.fname;

writetable(t,['behavior_' fname(1:end-4) '.xls'])

disp('RT:')
disp(D.mrt)
disp('MT:')
disp(D.mmt)

% 
% figure
% subplot(2,2,1)
% mybar({D.rt(aut_ord) D.rt(con_ord) nanmean(D.rt(con_ord))-nanmean(D.rt(aut_ord))});
% title(['               ' strrep(D.fname,'_','\_')])
% set(gca,'XTickLabel',{'AUT','CON','\Delta CON-AUT'})
% ylabel('Reaction Time [s]')
% subplot(2,2,2)
% mybar({D.mt(aut_ord) D.mt(con_ord) nanmean(D.mt(con_ord))-nanmean(D.mt(aut_ord))});
% set(gca,'XTickLabel',{'AUT','CON','\Delta CON-AUT'})
% ylabel('Movement Time [s]')
% subplot(2,2,3)
% mybar({D.max_v(aut_ord) D.max_v(con_ord) nanmean(D.max_v(con_ord))-nanmean(D.max_v(aut_ord))});
% set(gca,'XTickLabel',{'AUT','CON','\DeltaCON-AUT'})
% ylabel('Movement Velocity [au]')
% subplot(2,2,4)
% mybar({D.merr(aut_ord) D.merr(con_ord) nanmean(D.merr(con_ord))-nanmean(D.merr(aut_ord))});
% set(gca,'XTickLabel',{'AUT','CON','\DeltaCON-AUT'})
% ylabel('Trajectory Error [au]')
% figone(14,20)
% 
% myprint(['behavior_' fname(1:end-4)]) 

% keyboard

if isfield(D,'nblocks')
    n = length(D.nblocks);
    for a = 1:n
    D.nnblocks{a} = D.nblocks{a}(3:3:end)./3;
    ia = aut_ord(ismember(aut_ord,D.nnblocks{a}));
    ic = con_ord(ismember(con_ord,D.nnblocks{a}));
     
    D.(['mb' num2str(a) 'rt']) = [
        nanmean(D.rt(ia)) nanmean(D.rt(ic)) nanmean(D.rt(ic))-nanmean(D.rt(ia))];
    D.(['mb' num2str(a) 'mt']) = [
        nanmean(D.rt(ia)) nanmean(D.mt(ic)) nanmean(D.mt(ic))-nanmean(D.mt(ia))];
    D.(['mb' num2str(a) 'max_v']) = [
        nanmean(D.max_v(ia)) nanmean(D.max_v(ic)) nanmean(D.max_v(ic))-nanmean(D.max_v(ia))];
   D.(['mb' num2str(a) 'avg_v']) = [
        nanmean(D.avg_v(ia)) nanmean(D.avg_v(ic)) nanmean(D.avg_v(ic))-nanmean(D.avg_v(ia))];
    
    D.(['mb' num2str(a) 'merr']) = [
        nanmean(D.merr(ia)) nanmean(D.merr(ic)) nanmean(D.merr(ic))-nanmean(D.merr(ia))];
    
    
      
%     nt = table;
%     nt.RT = D.(['mb' num2str(a) 'rt'])';
%     nt.MT =   D.(['mb' num2str(a) 'mt'])';
%     nt.maxV = D.(['mb' num2str(a) 'max_v'])';
%     nt.avgV = D.(['mb' num2str(a) 'avg_v'])';
%     nt.E =  D.(['mb' num2str(a) 'merr'])';
%     nt.Properties.RowNames = {['Automatic_block_' num2str(a)],['Controlled_block_' num2str(a)],['Controlled-Automatic_block_' num2str(a)]};
%     
%     t = [t; nt];
%     writetable(t,['block_behavior_' fname(1:end-4) '.xls'],'WriteRowNames',1)
    end
end