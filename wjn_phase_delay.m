function d = wjn_phase_delay(filename,chancomb,freqlim)

D=wjn_sl(filename);

cfg = [];
    cfg.channel = D.chanlabels;
    cfg.channelcmb = chancomb;
    cfg.output ='powandcsd';
    cfg.keeptrials = 'no';
    cfg.keeptapers ='no';
    cfg.taper = 'hanning';
    cfg.method = 'mtmfft';
    cfg.foilim     = freqlim; % Frequency range
    inp = ft_freqanalysis(cfg, D.ftraw);
    
    phase = unwrap(angle(inp.crsspctrm));
    frequency = inp.freq;
    
    % Change here to reduce the range
    phase = phase(1:end);
    frequency = frequency(1:end);
    
    figure;
    plot(frequency, phase);
    
    p = polyfit(frequency, phase, 1);
    
    [R, Pval]= corrcoef(frequency,phase);
    
    Pval = Pval(1, 2);
    
    Rsq = R(1, 2)^2;
    
    hold on
    
    plot(frequency, polyval(p, frequency), 'r');
    
    d = 1e3*p(1)/(2*pi);
    
    disp(['Delay is: ' num2str(d) ' ms']);
