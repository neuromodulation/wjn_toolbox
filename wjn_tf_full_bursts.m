function [D,bursttables]=wjn_tf_full_bursts(filename,mode,thresh)

if ~exist('mode','var')
    mode = 'Z';
    thresh = 3;
end

freqrange = [1 3; 4 7;8 12; 13 20; 21 35; 55 80];
freqnames = {'full_delta','full_theta','full_alpha','low_beta','high_beta','full_gamma'};

D=spm_eeg_load(filename);
try
    D=rmfield(D,'bursts');
catch
end
for b = 1:D.nchannels
    tf = squeeze(D(b,:,:,1));
    
    if strcmp(mode,'Z')
        nntf = wjn_raw_baseline(tf,D.frequencies);
        zntf = nntf>thresh;
        [bmap,nbursts]=bwlabeln(zntf,4);
    elseif strcmp(mode,'P')  
        nntf = tf;

        zntf = double(zeros(size(tf)));
        for f = 1:D.nfrequencies
            i = find((f>=freqrange(:,1)).*(f<=freqrange(:,2)));
            fthresh = prctile(tf(f,:),thresh);
            zntf(f,tf(f,:)>=fthresh)=i;
        end
    elseif strcmp(mode,'F')
        nntf = tf;

        zntf = double(zeros(size(tf)));
        for f = 1:D.nfrequencies
            i = find((f>=freqrange(:,1)).*(f<=freqrange(:,2)));
            if ~isempty(i)
            fthresh = thresh(f);
            zntf(f,tf(f,:)>=fthresh)=i;
            end
                
        end
    end
%     keyboard
    bmap = zeros(size(tf));
    for c = 1:size(freqrange,1)
    map=bwlabeln(zntf==c,4);
    map(map>=1)=map(map>=1)+max(max(bmap));
    bmap = bmap+map;
    end
    nbursts = max(max(bmap));
%     end
    nbmap = bmap;
    clear burst sa zsa tf ntf zntf
    a=0;
    for n = 1:nbursts
        [y,x]=find(bmap==n);
        freqwidth=D.frequencies(max(y))-D.frequencies(min(y));
        meanfreq=nanmean(D.frequencies(y));
        timewidth=D.time(max(x))-D.time(min(x));
        
        timethresh = 2*(1/meanfreq);
        if timewidth > timethresh && freqwidth >=1
            a=a+1;
             [ym,xm]= find((nntf.*(bmap==n))==max(nntf(bmap==n)),1);
            burst(a).n = n;
            burst(a).peaktime = D.time(xm);
            burst(a).map = find(bmap==n);
            burst(a).y = y;
            burst(a).x = x;
            burst(a).onset = D.time(min(burst(a).x));
            burst(a).offset = D.time(max(burst(a).x));
            burst(a).flow = D.frequencies(min(burst(a).y));
            burst(a).fhigh = D.frequencies(max(burst(a).y));
            burst(a).size = nansum(nansum(bmap==a));
            burst(a).weight = nansum(nntf(bmap==a));
            burst(a).meanamp = nanmean(nntf(bmap==a));
            burst(a).maxamp = nanmax(nntf(bmap==a));
            burst(a).timewidth = timewidth;
            burst(a).freqwidth = burst(a).fhigh-burst(a).flow;
            burst(a).meanfreq = nanmean(D.frequencies(burst(a).y));
            burst(a).peakfreq = D.frequencies(ym);
            burst(a).freqrange = find((burst(a).peakfreq>=freqrange(:,1)).*(burst(a).peakfreq<=freqrange(:,2)));

        else
            nbmap(bmap==n) = 0;
        end
        %     disp([num2str(n) ' of ' num2str(nbursts) ' logged']);
    end
    D.bursts.bmap(b,:,:,1) = bmap;
    D.bursts.nbmap(b,:,:,1)= nbmap;
    D.bursts.bursts{b} = burst;
    btable =  struct2table(burst);
    btable = btable(:,8:end);
    bursttables{b} = btable;
    
    
    
    
end
D.bursts.mode = mode;
D.bursts.thresh = thresh;
save(D);

n=0;
clear bursts mtable
for c = 1:size(freqrange,1)
    ifreq = D.indfrequency(freqrange(c,1)):D.indfrequency(freqrange(c,2));
    for b = 1:D.nchannels
        
        bursts = D.bursts.bursts{b};
        %             freqs = [bursts(:).peakfreq];
        freqs = [bursts(:).meanfreq];
        clear idx
        
        n=n+1;
        idx = find(freqs>=freqrange(c,1)&freqs<=freqrange(c,2));
        nbursts = numel(idx);
        if ~isempty(idx)
            burst = bursts(idx);
            burst = rmfield(burst,{'n','map','y','x','peaktime','onset','offset'});
            ctables = struct2table(burst);
            
            mtable(n,:) = [nanmean(ctables.Variables,1) nbursts./D.time(end) squeeze(nanmean(nanmean(nanmean(D(b,ifreq,:,:),2),3),4))];
            
        else
           
            mtable(n,1:13) = nan;
        end
        fields = fieldnames(burst);
        VarNames = [fields' 'burstfreq' 'mean_power'];
        %             VarNames = [ctables.Properties.VariableNames 'Nbursts'];
        RowNames{n} = [D.chanlabels{b} '_' freqnames{c}];
    end
end
burst_table = array2table(mtable);
burst_table.Properties.VariableNames = VarNames;
burst_table.Properties.RowNames = RowNames;



D.bursts.mbursts = burst_table;

for a = 1:length(freqnames)
    frows = ci(freqnames{a},RowNames);
    mmburstmatrix(a,:) = nanmean(table2array(D.bursts.mbursts(frows,:)),1);
    
    [~,imax] = nanmax(table2array(D.bursts.mbursts(frows,ci('meanamp',VarNames))));
    maxrows{a} = freqnames{a};
    maxchan{a} = strtok(RowNames{frows(imax)},'_');
    if ~isempty(imax)
        maxburstmatrix(a,:) = table2array(D.bursts.mbursts(frows(imax),:));
    else
        maxburstmatrix(a,:) = nan;
    end
end

mmbursts = array2table(mmburstmatrix);
mmbursts.Properties.RowNames = freqnames;
mmbursts.Properties.VariableNames = VarNames;
mmaxbursts = array2table(maxburstmatrix);
mmaxbursts.Properties.RowNames = maxrows;
mmaxbursts.Properties.VariableNames = VarNames;
D.bursts.mmaxbursts = mmaxbursts;
D.bursts.mmbursts = mmbursts;
D.bursts.maxchan = maxchan;
D.bursts.freqnames = freqnames;
save(D)
% keyboard



fname = D.fname;
%
% for a = 1:length(bursttables)
%     writetable(bursttables{a},['nbursts_' fname(1:end-4) '.xls'],'Sheet',D.chanlabels{a});
% end
%
% writetable(burst_table,['nmbursts_' fname(1:end-4) '.xls'],'WriteRowNames',1);
% save(['nmbursts_' fname],'burst_table')
