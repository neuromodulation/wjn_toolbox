function [D,alltimes,allconds]=wjn_spw(filename)

filtfreq = 95;
D=spm_eeg_load(filename);
spw=[];

chs = unique([ci({'EEG','LFP'},D.chantype) ci({'EEG','LFP'},D.chanlabels)]);
alltimes=[];
allconds=[];
mssamples = round(2*round(D.fsample/1000));
runs = {'neg','pos'};
for nrun = 1:2
    for a = 1:length(chs)
        keep('runs','nrun','a','filename','D','spw','filtfreq','chs','alltimes','allconds','mssamples')
        if nrun == 1
            data = -zscore(D(chs(a),:));
        else
            data = zscore(D(chs(a),:));
        end
        fdata = ft_preproc_lowpassfilter(data,D.fsample,filtfreq);
        [i,w,p,m,d]=wjn_raw_spw(fdata,0);
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
                cclimn=D.fsample;
                cclimp = D.nsamples-cci-1;
            end
            
            nin = cci-1:-1:cci-cclimn;
            [fmin,fin]=findpeaks(-fdata(nin),'Npeaks',1);
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
        spw(a).Tpeak = D.time(ni)';
        spw(a).Tpre = D.time(nipre)';
        spw(a).Tpost = D.time(nipost)';
        spw(a).Tfull = tfull';
        spw(a).Tdescent = tdescent';
        spw(a).Trise = trise';
        
        spw(a).Vmax = vtrough';
        spw(a).Vpre = vpre';
        spw(a).Vpost = vpost';
        spw(a).Vdescent = vdescent';
        spw(a).Vrise = vrise';
        
        spw(a).Pfull = pfull';
        spw(a).Ppre = ppre';
        spw(a).Ppost = ppost';
        
        spw(a).Imean=dmean';
        spw(a).Ipre = dpre';
        spw(a).Ipost = dpost';
        
        spw(a).cond = repmat({['SPW_' runs{nrun} '_' D.chanlabels{chs(a)}]},size(ni))';
        alltimes=[alltimes;D.time(ni)'];
        allconds = [allconds;spw(a).cond];
        
    end
    keyboard
    eval([runs{nrun} '=struct2table(spw(a))']);
    D.spw.(runs{nrun}){a} = struct2table(spw(a));
    save(D)
    save(fullfile(D.path,['spw_' runs{nrun} '_' D.fname]),'D.spw');
end
