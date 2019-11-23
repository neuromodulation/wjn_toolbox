function D = dbs_meg_stim_clean_lfp(S)

D = spm_eeg_load(S.D);
%%
D = chanlabels(D, D.indchannel('STIM_CLEAN'), 'LFP_CLEAN');

save(D);

% Not cleaning 0 and 130 Hz, just copying
D(D.indchannel('LFP_CLEAN'), :, D.indtrial('STIM_R_0')) = D(D.indchannel('LFP_STIM'), :, D.indtrial('STIM_R_0'));
D(D.indchannel('LFP_CLEAN'), :, D.indtrial('STIM_L_0')) = D(D.indchannel('LFP_STIM'), :, D.indtrial('STIM_L_0'));

D(D.indchannel('LFP_CLEAN'), :, D.indtrial('STIM_R_130')) = D(D.indchannel('LFP_STIM'), :, D.indtrial('STIM_R_130'));
D(D.indchannel('LFP_CLEAN'), :, D.indtrial('STIM_L_130')) = D(D.indchannel('LFP_STIM'), :, D.indtrial('STIM_L_130'));


cond = {'STIM_L_5', 'STIM_R_5'};

for i = 1:numel(cond)
    
    ostim = squeeze(D(D.indchannel('STIM'), :, D.indtrial(cond{i})));
    ostim = ostim(:);
    
    spm_figure('GetWin','Graphics');clf;
    
    fs = D.fsample;
    
    isi = fs/5;
 
    for s = [1 -1]
        clf;
        stim = s*ostim;
        
        stim = stim./spm_percentile(abs(stim), 99);
        
        stim(stim<0.2) = 0;
        
        plot(stim)
        hold on
        
        [jnk, ind] = findpeaks(stim);
        
        ind(find(diff(ind)<(0.4*min(isi)))+1) = [];
        
        plot(ind, stim(ind), 'ro');
        
        ind1 = find(abs(diff(ind) - isi)./isi<=0.05);
        
        if ~isempty(ind1)
            break;
        end
    end
    %%
    
    d =  reshape(squeeze(D(D.indchannel('LFP_STIM'), :,  D.indtrial(cond{i}))), [], 1);
    
    m = min(max(ind(2:end) - ind(1:(end-1))), floor(1.1*isi));
    
    ii = repmat(1:m, length(ind), 1)+repmat(ind, 1, m);
    ii(any(ii'>length(d)), :) = [];
    dd = d(ii);
    id = 1:length(d);
    idd = id(ii);
    
    [u s] = svd(dd'*dd);
    %
    uu= u(:, 3:end);
    M = uu*pinv(uu);
    
    dd2 = dd*M';
    
    d3 = d;
    d3(idd) = dd2;
    
    dd4 = reshape(d3, D.nsamples, []);
    
    spm_figure('GetWin','Graphics');clf;
    
    subplot(2, 2, 1)
    imagesc(dd);
    subplot(2, 2, 2)
    imagesc(dd2);
    subplot(2, 2, 3)
    plot(mean(dd2));
    % hold on
    % plot(mean(dd), 'r');
    subplot(2, 2, 4)
    plot(dd2');
    %%
    D(D.indchannel('LFP_CLEAN'), :, D.indtrial(cond{i}))= shiftdim(dd4, -1);
end

cond = {'STIM_L_20', 'STIM_R_20'};

for i = 1:numel(cond)
     lfp = reshape(squeeze(D(D.indchannel('LFP_STIM'), :, D.indtrial(cond{i}))), 1, []);
     
     for f = 20:20:120
         lfp = ft_preproc_bandstopfilter(lfp, D.fsample, [f-1 f+1], [], [], [], 'split');
     end
     
     lfp = reshape(lfp, D.nsamples, []);
     
     D(D.indchannel('LFP_CLEAN'), :, D.indtrial(cond{i}))= shiftdim(lfp, -1);
     
%     lfp = squeeze(D(D.indchannel('LFP_STIM'), :, D.indtrial(cond{i})))';
%     ns  = size(lfp, 2);
%     
%     lfppad = zeros(size(lfp, 1), 3*ns);
%     lfppad(:, (ns+1):(2*ns)) = lfp;
%     lfppad(2:end, 1:ns) = lfp(1:(end-1), :);
%     lfppad(1:(end-1), (2*ns+1):end) = lfp(2:end, :);
%     lfppad(1, 1:ns) = fliplr(lfp(1, :));
%     lfppad(end, (2*ns+1):end) = fliplr(lfp(end, :));
%     
%     %%
%     for f = 20:20:120
%         lfppad = ft_preproc_dftfilter(lfppad, D.fsample, f);
%     end
%     
%     D(D.indchannel('LFP_CLEAN'), :, D.indtrial(cond{i}))= shiftdim(lfppad(:, (ns+1):(2*ns))', -1);
end

cfg = [];
cfg.output ='pow';
cfg.keeptrials = 'no';
cfg.keeptapers='no';
cfg.taper = 'dpss';
cfg.method = 'mtmfft';
cfg.foilim     = [0 200]; % Frequency range
cfg.tapsmofrq = 2.5; % Frequency resolution


sides = {'L', 'R'};

freqs = {'0', '5', '20', '130'};

c = {'k', 'b', 'g', 'r'};

spm_figure('GetWin','Graphics');clf;

for s = 1:2
    for f = 1:4
        inp = D.ftraw(D.indchannel('LFP_CLEAN'), ':', D.indtrial(['STIM_' sides{s} '_' freqs{f}]));
        
        %
        freq = ft_freqanalysis(cfg, inp);
        
        subplot(2, 1, s);
        plot(freq.freq, log(freq.powspctrm), c{f});
        hold on
        legend(freqs);
    end
end

print('-dtiff', '-r600', 'lfp.tiff')