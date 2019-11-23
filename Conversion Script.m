function D = dbs_meg_rest_prepare_ctfeeg(initials)

dbsroot = 'C:\home\Data\Thalamus\';

try
    [files, seq, root, mont, lfpthresh] = thalamus_subjects(initials);
catch
    D = [];
    return
end
%%
cd(root);
res = mkdir('SPMrest');
cd('SPMrest');
fD = {};
%%
origsens  = [];
origfid   = [];
fixedsens = [];
fixedfid  = [];
for f = 1:numel(files)
    if ~isequal('R', seq{f}(1));
        continue;
    end
    
    
    S = [];
    S.dataset = files{f};
    S.channels = getfield(load(fullfile(dbsroot, 'SPM', 'dbs_meg_chan.mat')), 'label');
    S.checkboundary = 0;
    S.saveorigheader = 1;
    S.conditionlabels = seq{f};
    S.mode = 'continuous';
    D = spm_eeg_convert(S);
    
    origsens =[origsens ft_convert_units(ft_read_sens(S.dataset), 'mm')];
    origfid  =[origfid ft_convert_units(ft_read_headshape(S.dataset), 'mm')];
    
    event     = ft_read_event(S.dataset, 'detectflank', 'both');
    eventdata = zeros(1, D.nsamples);
    
    trigind  = find(strcmp('UPPT001_up', {event.type}));
    trigchanind = D.indchannel('SCLK01');
    
    eventdata([event(trigind).sample]) = 1;
    
    D = chanlabels(D, trigchanind, 'event');
    
    D(D.indchannel('event'), :) = eventdata;
    
    save(D);
    
    S = [];
    S.D = D;
    S.valid_fid = 1;
    D = spm_eeg_fix_ctf_headloc(S);
    
    ind = strmatch('EEG', D.chanlabels);
    
    if ~isempty(ind)
        D = chantype(D, ind, 'LFP');
        save(D);
    end
    
    if D.fsample > 350
        
        S = [];
        S.D = D;
        S.fsample_new = 300;
        
        D = spm_eeg_downsample(S);
        delete(S.D);
    end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'high';
    S.freq = 1;
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    delete(S.D);
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [48 52];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    delete(S.D);
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [98 102];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    delete(S.D);
    
    
    S = [];
    S.D = D;
    S.trl = trialfun_thalamus_rest(fullfile(D));
    S.conditionlabels = seq{f};
    S.bc = 0;
    D = spm_eeg_epochs(S);
    
    delete(S.D);
    
    
    fixedsens = [fixedsens sensors(D, 'MEG')];
    fixedfid  = [fixedfid fiducials(D)];
    
    chantocheck = {
        'EEG001'
        'EEG002'
        'EEG003'
        'EEG004'
        %         'EEG005'
        %         'EEG006'
        %         'EEG007'
        %         'EEG008'
        %         'EEG016'
        };
    
    chantocheck = intersect(chantocheck, D.chanlabels);
    
    for m = 1:numel(chantocheck)
        chanind = strmatch(chantocheck{m}, D.chanlabels);
        for l = 1:D.ntrials
            if  (sum(sum(diff(squeeze(D(chanind, :, l)))==0))./...
                    numel(diff(squeeze(D(chanind, :, l)))))>0.01
                D(chanind, :, l) = zeros(size(D(chanind, :, l)));
                D(chanind, 1:2:end, l) = 1e10;
                disp(['Flat detected in ' chantocheck{m} ' trial ' num2str(l)]);
            end
        end
    end
    
    S = [];
    S.D = D;
    
    montage = load(mont);
    name = fieldnames(montage);
    montage = getfield(montage, name{1});
    
    ind = [];
    if isempty(strmatch('HLC', D.chanlabels))
        ind = [ind; strmatch('HLC', montage.labelnew)];
    end
    
    neeg = length(strmatch('EEG', D.chanlabels));
    if neeg < 16
        ind = [ind; strmatch('Cz', montage.labelnew, 'exact')];
    end
    
    if neeg < 13
        ind = [ind; strmatch('HEOG', montage.labelnew, 'exact')];
        ind = [ind; strmatch('VEOG', montage.labelnew, 'exact')];
    end
    
    if neeg == 0
        ind = [ind; strmatch('EMG', montage.labelnew)];
        ind = [ind; strmatch('LFP', montage.labelnew)];
    end
    
    if ~isempty(ind)
        montage.labelnew(ind) = [];
        montage.tra(ind, :) = [];
    end
    
    S.montage = montage;
    S.keepothers = 0;
    D = spm_eeg_montage(S);
    
    delete(S.D);
    
    D = chantype(D, strmatch('LFP', D.chanlabels), 'LFP');
    save(D);
    %%
    S = [];
    S.D = D;
    S.badchanthresh = 1;
    S.methods.channels = 'LFP';
    S.methods.fun = 'threshchan';
    S.methods.settings.threshold = lfpthresh;
    D = spm_eeg_artefact(S);
    
    delete(S.D);
    %%
    S = [];
    S.D = D;
    fD{f} = spm_eeg_remove_bad_trials(S);
    
    delete(S.D);
end

fD(cellfun('isempty', fD)) = [];

nf = numel(fD);

if numel(fD)>1
    S = [];
    S.D = fname(fD{1});
    for f = 2:numel(fD)
        S.D = strvcat(S.D, fname(fD{f}));
    end
    S.recode = 'same';
    D = spm_eeg_merge(S);
    
    fileind =[];
    for f = 1:numel(fD)
        fileind = [fileind f*ones(1, ntrials(fD{f}))];
        D = events(D, find(fileind == f), events(fD{f}, ':'));
        D = trialonset(D, find(fileind == f), trialonset(fD{f}, ':'));
        delete(fD{f});
    end
    D.fileind = fileind;
elseif  numel(fD)==1
    D = fD{1};
    D.fileind = ones(1, ntrials(D));
end

%%
sens = [origsens fixedsens];
fid  = [origfid fixedfid];
%%
pnt = [];
for i = 1:numel(fid)
    pnt = cat(3, pnt, fid(i).fid.pnt);
end
%%
cont_fid  = permute(pnt, [3 1 2]);

dist = [
    squeeze(sqrt(sum((cont_fid(:, 1, :) - cont_fid(:, 2, :)).^2, 3)))';...
    squeeze(sqrt(sum((cont_fid(:, 2, :) - cont_fid(:, 3, :)).^2, 3)))';...
    squeeze(sqrt(sum((cont_fid(:, 3, :) - cont_fid(:, 1, :)).^2, 3)))' ];

dist = 10*round(dist/10);

valid = find(all(dist == repmat(mode(dist, 2), 1, size(dist, 2))));

spm_figure('GetWin','Graphics');clf;
h = axes;
[asens afid] = ft_average_sens(sens(valid), 'fiducials', fid(valid), 'feedback', h);

D = sensors(D, 'MEG', asens);
D = fiducials(D, afid);

for i = 1:nf
    if ismember(nf + i, valid)
        D.allsens(i) = sens(nf + i);
        D.allfid(i)  = fid(nf + i);
    elseif valid(i)
        D.allsens(i) = sens(i);
        D.allfid(i)  = fid(i);
    else
        D.allsens(i) = asens;
        D.allfid(i)  = afid;
    end
end
%%
try
    D.inv = getfield(load('inv.mat'), 'inv');
end

save(D);

D.move(initials);