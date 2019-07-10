function [D,Dc,Dcf] = wjn_spikeconvert(filename,timewin,lowcut,linefilter,downsample)
% [D,Dc] = wjn_spikeconvert(filename,timewin,lowcut,linefilter,downsample)
% filename = filename
% if timewin is empty data will be continuous
% if timewin is trial duration, arbitrary epochs will be generated
% if timewin is PST data will be epoched from event channels

if ~exist('linefilter','var')
    linefilter = 1;
end
if ~exist('downsample','var')
    downsample = 0;
end
x=load(filename);
try
    x=rmfield(x,'Keyboard');
catch
    disp('No Keyboard channel found!')
end

if ~exist('timewin','var')
 timewin = [];
end

if sum(abs(timewin)) > 500
    timewin = timewin/1000;
end

fn = fieldnames(x);
for a = 1:length(fn)
    try
        fsample = 1/x.(fn{1}).interval;
    catch
    end

end
dc = zeros(size(fn));ec=dc;
for a = 1:length(fn)
    nt{a}=x.(fn{a}).title;
    if isfield(x.(fn{a}),'scale')
        dc(a) = 1;
    else
        ec(a) =1;
    end
end

S.channels = nt(dc==1);

% 

    
S.dataset = filename;
D = spm_eeg_convert(S);

chans = D.chanlabels;
[nchans,i]=sort(chans);

D(:,:,:)=D(i,:,1);
D=chanlabels(D,':',nchans);
save(D);
if downsample
    D=wjn_downsample(D.fullfile,downsample);
end


ch = numel(D.chanlabels);

for a = 1:ch
    if sum(strncmpi(D.chanlabels{a},{'STN','LFP','GPi','VIM','CMPf','rLFP','rSTN','ECOG','Cg25','BNST','EP','M1','M3','M13','M9'},3));    
        D=chantype(D,a,'LFP');
    elseif sum(strncmpi(D.chanlabels{a},{'EMG','FDI','SCM'},3))
        D=chantype(D,a,'EMG');
    elseif sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4','Pz'},3)) || sum(strncmpi(D.chanlabels{a},{'EEG','Cz','C3','C4'},2));  
        D=chantype(D,a,'EEG');
    end
end
csample = D.fsample;
% keyboard
if sum(ec) 
    ie = find(ec);     
    n=0;
    for a = 1:length(ie)
        try
            it = x.(fn{ie(a)}).times(find(x.(fn{ie(a)}).values));
        catch
            it = round(x.(fn{ie{a}}).times*fsample);
        end
  
        for b  =1:length(it)   
            n=n+1;
            if numel(timewin)==2
                    trl(n,1:3) = [D.indsample(it(b)+timewin(1))  D.indsample(it(b)+timewin(1))+diff(timewin)*csample round(timewin(1)*csample)];
            end
            eventtimes(n) = it(b);
            conditionlabels{n} = x.(fn{ie(a)}).title;          
        end

    end

    
if exist('eventtimes','var')
[~,ni]=sort(eventtimes);
if exist('trl','var')
    inan=[find(isnan(trl(:,1)))];
    trl(inan,:)=[];
    D.trl = trl(ni,:);
    D.ttrl = D.trl/D.fsample;

end
    D.eventtimes = eventtimes(ni);
    D.conditionlabels =conditionlabels(ni);


end


end
save(D)
Dc=D;

if exist('lowcut','var') && ~isempty(lowcut) && lowcut
    i=find(~strcmp(D.chantype,'Other'));
    cfg = [];
    cfg.padding = 2;
    cfg.hpfilter = 'yes';
    cfg.hpfreq = lowcut;
    cfg.hpfiltord = 3;
%     cfg.channel = 'all';
    data = ft_preprocessing(cfg,D.ftraw(i));
    D(i,:,1) = data.trial{1};
    save(D);
end



if linefilter
        fs = D.fsample;
        n = fs/200;
        cfg = [];
        cfg.padding = 2;
        cfg.bsfilter = 'yes';
        cfg.bsfreq = [49 51];
        for a  =2:n
            cfg.bsfreq(a,:) = cfg.bsfreq(a-1,:)+50;
        end
        for ord = 5:-1:2
            try
                cfg.bsfiltord = ord;
                data=ft_preprocessing(cfg,D.ftraw(0));
            catch
                disp(['BS filter with order ' num2str(ord) ' not possible'])
            end
        end
        D(:,:,1) = data.trial{1};
        save(D);
end


S=[];
S.D = D.fullfile; 
Dcf=D;
if  numel(timewin)==1
    S.trialength = timewin(1)*1000;
    S.eventpadding = 20;
    D=spm_eeg_epochs(S);

elseif sum(ec) && numel(timewin)==2
    S.trl = D.trl;
    S.conditionlabels = D.conditionlabels;
    D=spm_eeg_epochs(S);
end
fname = Dc.fname;
% delete(['f*' Dc.fname])
