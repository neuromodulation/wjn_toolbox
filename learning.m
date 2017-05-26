clear
cd('C:\Users\User\Dropbox\Motorneuroscience\visuomotor_tracking_ana\Matlab Export')
clear all
close all
groups = {'OFF','ON','HC'};
fid = {'rPD*s0m1*.mat','rPD*s1m1*.mat','rhealthy*.mat'};

for pg =1:length(groups);
files = ffind(fid{pg});
ngrt = nan(length(files),60);
nrrt=ngrt;
nrmv=nrrt;
ngmv = ngrt;

for a = 1:length(files);

x=load(files{a},'block','color','order','rt','mv');
ncolor = x.color;
ncolor(x.mv>3000)=6;
ncolor(x.rt>2000)=6;
iorder(a) = x.order;

ig = find(x.block==1 & ncolor == 1);
ig1 = ig(ig<60);
ig2 = ig(ig>119);
oig = [ig1 ig2];

ir = find(x.block==1 & ncolor == 2);
ir1 = ir(ir<60);
ir2 = ir(ir>119);
oir = [ir1 ir2];

if x.order==2
    ig1=ig1-29;
    ig2=ig2-119;
    ir2=ir2-89;
else
    ir1=ir1-29;
    ir2=ir2-119;
    ig2=ig2-89;
end

nig = [ig1 ig2];
nir = [ir1 ir2];

ngrt(a,nig) = x.rt(oig);
ngmv(a,nig) = x.mv(oig);
nrrt(a,nir) = x.rt(oir);
nrmv(a,nir) = x.mv(oir);
i=1:60;
% [rgmv(a),pgmv(a)]=mypermCorr(i',ngmv(a,i)');
% [rgrt(a),pgrt(a)]=mypermCorr(i',ngrt(a,i)');
% [rrmv(a),prmv(a)]=mypermCorr(i',nrmv(a,i)');
% [rrrt(a),prrt(a)]=mypermCorr(i',nrrt(a,i)');

[rgmv(a),pgmv(a)]=corr(i',ngmv(a,i)','rows','pairwise');
[rgrt(a),pgrt(a)]=corr(i',ngrt(a,i)','rows','pairwise');
[rrmv(a),prmv(a)]=corr(i',nrmv(a,i)','rows','pairwise');
[rrrt(a),prrt(a)]=corr(i',nrrt(a,i)','rows','pairwise');

clear x
end
%
mngmv = nanmean(ngmv(:,1:60),1);
mngrt = nanmean(ngrt(:,1:60),1);
mnrmv = nanmean(nrmv(:,1:60),1);
mnrrt = nanmean(nrrt(:,1:60),1);

d.(groups{pg}).rgmv = rgmv;
d.(groups{pg}).rrmv = rrmv;
d.(groups{pg}).rgrt = rgrt;
d.(groups{pg}).rrrt = rrrt;
d.(groups{pg}).mngmv = mngmv;
d.(groups{pg}).mnrmv = mnrmv;
d.(groups{pg}).mngrt = mngrt;
d.(groups{pg}).mnrrt = mnrrt;


end


figure
subplot(2,1,1) 
mybar([d.OFF.rgmv',d.ON.rgmv',d.HC.rgmv']);
subplot(2,1,2) 
mybar([d.OFF.rrmv',d.ON.rrmv',d.HC.rrmv']);


%
figure
subplot(2,1,1) 
mybar([d.OFF.rgrt',d.ON.rgrt',d.HC.rgrt']);
subplot(2,1,2) 
mybar([d.OFF.rrrt',d.ON.rrrt',d.HC.rrrt']);
