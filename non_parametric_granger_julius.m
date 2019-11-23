% benötigt scripts aus meiner Toolbox

filename = 'redPLFP18_off.mat'
D = spm_eeg_load(filename);
pair = [D.chanlabels(134), D.chanlabels(129)]; % Namen der Kanäle z.B. EMG + LFP

odata = D.fttimelock(D.indchannel(pair), ':', ':'); % Prepare for fieldtrip
rdata = odata(:,1:end); % create reversed data template
rdata.trial = rdata.trial(:, :, end:-1:1); % reverse 
data = {odata, rdata}; % data = original and reverse data

for i = 1:numel(data)
    
    fstep = 1/(D.nsamples/D.fsample);
    fstep = round(1/fstep)*fstep;
    
    foi     = fstep:fstep:100;
    fres    = 0*foi+fstep;
    fres(fres>10*fstep) = 0.1*fres(fres>10*fstep);
    fres(fres>50) = 5;
    
    cfg = [];
    cfg.output ='fourier';
    cfg.channelcmb=pair;
    
    cfg.keeptrials = 'yes';
    cfg.keeptapers='yes';
    cfg.taper = 'dpss';
    cfg.method          = 'mtmfft';
    cfg.foi     = foi;
    cfg.tapsmofrq = fres;
    
    inp{i} = ft_freqanalysis(cfg, data{i});
    %
    cfg = [];
    cfg.channelcmb=coherence_finder(D.chanlabels(D.indchantype('EMG')), D.chanlabels(D.indchantype('LFP')),pair);
    cfg.method  = 'coh';
    %cfg.complex = 'imag';
    
    coh{i} = ft_connectivityanalysis(cfg, inp{i});
    %
    cfg.method = 'granger';
    stat{i} = ft_connectivityanalysis(cfg, inp{i});
end
% in coh{1}.cohspctrm ist die einfache Kohärenz in stat{1}.grangerspctrm
% ist das granger spectrum für die original Daten und in stat{2} für die
% reversed Daten. Die kannst du jetzt über die Gruppe gegeneinander
% vergleichen, indem du über dein Frequenzband mittelst und original vs.
% reversed mit einem TTEST vergleichst.


%%
clear
nshuffle = 10
filename = 'redPLFP18_off.mat'  %         S.freq = [2 98];
            %         chans = [source_name{b} cohchans.(source_name{b})(a,:)];
%                      chans = [source_name{b} lfpchans];
        D = spm_eeg_load(filename);

    pair = [D.chanlabels(134), D.chanlabels(129)];
        data = D.fttimelock(D.indchannel(pair), ':', ':');
        % rdata = odata(:,1:end);
        % rdata.trial = rdata.trial(:, :, end:-1:1);
        % rdata.trial(:,:,size(rdata,3)+1) = rdata.trial(:, :, 1);
        % data = {odata, rdata};

        % for i = 1:numel(data)

            fstep = 1/(D.nsamples/D.fsample);
            fstep = round(1/fstep)*fstep;

            foi     = fstep:fstep:100;
            fres    = 0*foi+fstep;
            fres(fres>10*fstep) = 0.1*fres(fres>10*fstep);
            fres(fres>50) = 5;

            cfg = [];
            cfg.output ='fourier';
            cfg.channelcmb=pair;

            cfg.keeptrials = 'yes';
            cfg.keeptapers='yes';
            cfg.taper = 'dpss';
            cfg.method          = 'mtmfft';
            cfg.foi     = foi;
            cfg.tapsmofrq = fres;

            inp = ft_freqanalysis(cfg, data);
            %
for ns = 2:nshuffle+1;
            cfg1 = [];
            cfg1.channelcmb=coherence_finder(pair{1}, pair{2},pair);
    
            cfg1.method  = 'coh';
            cfg.complex = 'imag';

            coh = ft_connectivityanalysis(cfg1, inp);
            Ntrials = size(data.trial,1);
            shift=[ns:Ntrials 1:ns-1];
        % Compute the shift predictor for coherence
        scoh=coh;
        scoh.cohspctrm=zeros(size(scoh.cohspctrm));


            for c=1:length(data.label)
                sdata=data;
                sdata.trial(:,c,:)=data.trial(shift,c,:);
                cfg.channelcmb = {data.label{c}, 'all'};
                sinp = ft_freqanalysis(cfg, sdata);
                sscoh = ft_connectivityanalysis(cfg1, sinp);
                for in=1:size(sscoh.labelcmb, 1)
                    ind=[intersect(strmatch(sscoh.labelcmb(in,1),scoh.labelcmb(:,1),'exact'), ...
                        strmatch(sscoh.labelcmb(in,2),scoh.labelcmb(:,2),'exact'))...
                        intersect(strmatch(sscoh.labelcmb(in,1),scoh.labelcmb(:,2),'exact'), ...
                        strmatch(sscoh.labelcmb(in,2),scoh.labelcmb(:,1),'exact'))];
                    scoh.cohspctrm(ind, :)=sscoh.cohspctrm(in, :);
                end
            end
            %
            cfg1.method = 'granger';
            if ns==2;
            stat{1} = ft_connectivityanalysis(cfg1, inp);
            ostat = stat{1};
            stat{2} = ft_connectivityanalysis(cfg1, sinp);
            rstat(ns-1) = stat{2};
            ncoh  ={coh,scoh};
            else 
                stat{ns} = ft_connectivityanalysis(cfg1, sinp);
                rstat(ns-1) = stat{ns}
                ncoh{ns}  =scoh;
            end
end




