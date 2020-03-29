function [D,alltimes,allconds]=wjn_spw(filename)


D=spm_eeg_load(filename);
fpath = D.path;
fname = D.fname;
D=wjn_spm_copy(fullfile(fpath,fname),fullfile(fpath,['spw_' fname]));
spw=[];
filtfreq = [3 D.fsample/2.5];
chs = unique([ci({'EEG','LFP'},D.chantype) ci({'EEG','LFP'},D.chanlabels)]);
alltimes=[];
allconds=[];
mssamples = round(2*round(D.fsample/1000));
runs = {'neg','pos'};
T=table;
for nrun = 1:2
    for a = 1:length(chs)
        
        keep('T','runs','nrun','a','filename','D','spw','filtfreq','chs','alltimes','allconds','mssamples')
        data=D(chs(a),:);
        data(data==0)=nan;
        good = ~isnan(data);
        if nrun == 1
            data(good) = -zscore(data(good));
        else
            data(good) = zscore(data(good));
        end
        fdata= nan(size(D.time));
        fdata(good) = ft_preproc_highpassfilter(data(good),D.fsample,filtfreq(1));
        fdata(good) = ft_preproc_lowpassfilter(data(good),D.fsample,filtfreq(2));
        [i,w,p,m,d]=wjn_raw_spw(fdata,2.58);
        n=0;
        for b = 2:length(i)-1
            n=n+1;
            cci=i(b);
            pci=cci-mssamples:cci+mssamples;
            [m(b),hfi] = max(data(pci));
            cci = cci+hfi-mssamples-1;
            vtrough(n) = -m(b);
            i(b)=cci;
            ni(n)=cci;
            
            dpre(n) = (cci-i(b-1))./D.fsample*1000;
            dpost(n) = (i(b+1)-cci)./D.fsample*1000;
            
            t0 = 1000*D.time(cci);
            
            if cci>D.fsample && cci<D.nsamples-D.fsample
                cclimp = D.fsample;
                cclimn = D.fsample;
            elseif cci<D.fsample
                cclimn =cci-1;
                cclimp = D.fsample;
            else
                cclimn=D.fsample-1;
                cclimp = D.nsamples-cci-1;
            end
            
            nin = cci-1:-1:cci-cclimn;
            [fmin,fin]=findpeaks(-fdata(nin),'Npeaks',1);
            if isempty(fin)
                [fmin,fin]=min(fdata(nin));
            end
            pci=nin(fin)-mssamples:nin(fin)+mssamples;
            [minn,in] = min(data(pci));
            cin=pci(in);
            vpre(n)= -minn;
            tdescent(n) = t0-D.time(cin)*1000;
            ppre(n) = -minn-vtrough(n);
            vdescent(n) = ppre(n)/tdescent(n);
            nipre(n) = cin;
            
            
            nip = cci+1:cci+cclimp;
            [fmip,fip]=findpeaks(-fdata(nip),'Npeaks',1);
            if isempty(fip)
                [fmip,fip]=min(fdata(nip));
            end
            pci=nip(fip)-mssamples:nip(fip)+mssamples;
            [mip,ip] = min(data(pci));
            cip=pci(ip);
            vpost(n) = -mip;
            trise(n) = D.time(cip)*1000-t0;
            ppost(n) = -mip-vtrough(n);
            vrise(n) = ppost(n)/trise(n);
            nipost(n) = cip;
            
            pfull(n) = ppre(n)+ppost(n);
            tfull(n) = tdescent(n)+trise(n);
            dmean(n) = (dpre(n)+dpost(n))/2;
            
            if ismember(n,1000:1000:1000000)
                disp(['N=' num2str(n) '/' num2str(length(i)-2) ' CH=' num2str(a) '/' num2str(length(chs))])
            end
        end
        
        
        spw(a).i=ni';
        spw(a).ipre=nipre';
        spw(a).ipost=nipost';
        spw(a).Tpeak = D.time(ni)';
        spw(a).Tpre = D.time(nipre)';
        spw(a).Tpost = D.time(nipost)';
        spw(a).Tfull = tfull';
        spw(a).Tdescent = tdescent';
        spw(a).Trise = trise';
        spw(a).Tasymmetry = trise'./tdescent';
        
        
        spw(a).Vmax = vtrough';
        spw(a).Vpre = vpre';
        spw(a).Vpost = vpost';
        spw(a).Vasymmetry = vtrough'./nanmean([vpre',vpost'],2);
        
        spw(a).VTdescent = vdescent';
        spw(a).VTrise = vrise';
        spw(a).VTasymmetry = abs(vdescent')./abs(vrise');
        
        spw(a).Pfull = pfull';
        spw(a).Ppre = ppre';
        spw(a).Ppost = ppost';
        spw(a).Pasymmetry = vtrough'-nanmean([vpre',vpost',vtrough'],2);
        
        spw(a).Imean=dmean';
        spw(a).Ipre = dpre';
        spw(a).Ipost = dpost';
        %keyboard
        %spw(a).cond = repmat({['SPW_' runs{nrun} '_' D.chanlabels{chs(a)}]},size(ni))';
        spw(a).cond = strcat({[D.chanlabels{chs(a)} '_' runs{nrun}] },num2str([1:length(ni)]'));
        alltimes=[alltimes;D.time(ni)'];
        allconds = [allconds;spw(a).cond];
        T=[T;struct2table(spw(a))];
        D.spw.(runs{nrun}) =spw;
    end  
end
D.spw.alltimes=alltimes;
D.spw.allconds = allconds;
D.spw.T=T;

for a = 1:D.nchannels
    D.spw.Vasymmetry(a,1)=nanmedian(D.spw.neg(a).Vmax)-nanmedian(D.spw.pos(a).Vmax);
    D.spw.STDasymmetry(a,1)=nanstd(D.spw.neg(a).Vmax)-nanstd(D.spw.pos(a).Vmax);
end

save(D)

figure
subplot(2,1,1)
plot(D.time,D(1,:))
hold on
scatter(D.time(D.spw.pos(1).i),D(1,D.spw.pos(1).i))
scatter(D.time(D.spw.pos(1).ipre),D(1,D.spw.pos(1).ipre))
scatter(D.time(D.spw.pos(1).ipost),D(1,D.spw.pos(1).ipost))
xlim([1 10])
subplot(2,1,2)
plot(D.time,D(1,:))
hold on
scatter(D.time(D.spw.neg(1).i),D(1,D.spw.neg(1).i))
scatter(D.time(D.spw.neg(1).ipre),D(1,D.spw.neg(1).ipre))
scatter(D.time(D.spw.neg(1).ipost),D(1,D.spw.neg(1).ipost)')
xlim([1 10])