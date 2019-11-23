clear
cd('C:\Users\User\Dropbox (Personal)\Motorneuroscience\gts_imaging')
load LEAD_groupanalysis.mat
n=0;
chs = {'GPi','CMPf'};
s = 'RL';
cn = {'01','12','23'};
for a = 1:length(M.elstruct)
    cg = M.patient.group(a);
    cid = strsplit(M.patient.list{a},'/');
    cid = cid{end}(1:2);
    try
        D=wjn_sl(ffind(['*' cid '*.mat'],0));
        channels = D.chanlabels;
        data = squeeze(D(:,1:D.indsample(100),1));
        fsample = D.fsample;
        [pow,f,~,rpow] = wjn_raw_fft(data,fsample);
        f = f(wjn_sc(f,1:100));
        rpow = rpow(:,wjn_sc(f,1:100));
        rr = 1;
    catch
        rpow = nan;
        rr=0;
    end

        for b = 1:2
            for c = 1:3
                
                mni(a,b,c,:) = nanmean(M.elstruct(a).coords_mm{b}([c;c+1],:));
                
                ccn = [chs{cg} s(b) cn{c}];
                ich = ci(ccn,D.chanlabels);
                if ~isempty(ich) && rr
                    lfp(a,b,c,:) = rpow(ich,:);
                    n=n+1;
                    ndata(n,:) = [a cg b squeeze(mni(a,b,c,:))' squeeze(lfp(a,b,c,:))'];
                else
                    lfp(a,b,c,:) = nan;
                end
                M.elphys(a).coords_mm{b}(c,:) = mni(a,b,c,:);
                M.elphys(a).lfp{b}(c,:) = lfp(a,b,c,:);
                M.elphys(a).f = f;
            end
        end
end
nf = [nan(1,5) f'];

%%
keep ndata nf
close all

cc = colormap('jet');
wjn_plot_lead_scene
hold on
theta = nansum(ndata(:,wjn_sc(nf,7:13)),2);
ntheta = theta./nanmax(theta).*length(cc-1);
view(-180,0)
for a = 1:size(ndata,1)
    hold on
    plot3(abs(ndata(a,4)),ndata(a,5),ndata(a,6),'LineStyle','none','Marker','o','MarkerFaceColor',cc(round(ntheta(a)),:),'MarkerEdgeColor','none');
    
end
    








