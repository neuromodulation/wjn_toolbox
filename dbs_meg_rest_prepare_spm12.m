function D = dbs_meg_rest_prepare_spm12(initials, drug)

druglbl = {'off', 'on'};
prefix = '';

keep = 0;
tsss = 1;

if tsss
    prefix = 'tsss';
end

try
    [files, seq, root, details] = dbs_subjects(initials, drug);
catch
    try
        [files, seq, root, details] = wjn_subjects(initials,drug);
    catch
        D = [];
    return
    end
end
%%
if ~exist(root, 'dir')
    if ismember(root(end), {'/', '\'})
        root(end) = [];
    end
    [p, p1] = fileparts(root);
    if ~exist(p, 'dir')
        if ismember(p(end), {'/', '\'})
            p(end) = [];
        end
        [p2, p3] = fileparts(p);
        if ~exist(p2, 'dir')
            if ismember(p2(end), {'/', '\'})
                p2(end) = [];
            end
            [p4, p5] = fileparts(p2);
            res = mkdir(p4, p5);
        end
        res = mkdir(p2, p3);
    end
    res = mkdir(p, p1);
end

cd(root);
res = mkdir('SPMrest');
cd('SPMrest');

if details.cont_head_loc
    [alldewar, alldist, allsens, allfid] = dbs_meg_headloc(files);
else
    alldewar = [];
    alldist = [];
end

fD = {};
%%
origsens  = {};
origfid   = [];
fixedsens = {};
fixedfid  = [];
for f = 1:numel(files)
    if ~isequal('R', seq{f}(1));
        continue;
    end
    
    % =============  Conversion =============================================
    S = [];
    S.dataset = files{f};
    S.channels = details.chanset;
    S.checkboundary = 0;
    S.saveorigheader = 1;
    S.conditionlabels = seq{f};
    S.mode = 'continuous';
    S.outfile = ['spmeeg' num2str(f) '_' spm_file(S.dataset,'basename')];
    
    if details.brainamp
        D = dbs_meg_brainamp_preproc(S);
    else
        D = spm_eeg_convert(S);
    end
%     keyboard
     % =============  Post conversion refinements
    
    D = sensors(D, 'EEG', []);
    
    origsens =[origsens  {ft_datatype_sens(ft_read_sens(S.dataset, 'senstype', 'meg'), 'version', 'latest', 'amplitude', 'T', 'distance', 'mm')}];
    
    if details.berlin
        origfid  =[origfid ...
            ft_convert_units(ft_read_headshape(spm_file(S.dataset, 'filename', details.markers(f).files{1})))];
        
        D = fiducials(D, origfid(end)); 
        
        hdr = ft_read_header(S.dataset);
       
        event     = ft_read_event(S.dataset, 'detectflank', 'down', 'trigindx', ...
            spm_match_str({'EEG157', 'EEG159', 'EEG160'}, hdr.label), 'threshold', 5e-3);
        
        save(D);
    else
        origfid  =[origfid ft_convert_units(ft_read_headshape(S.dataset), 'mm')];
        event    = ft_read_event(fullfile(D), 'detectflank', 'both');
    end
    
    
    eventdata = zeros(1, D.nsamples);
    trigchanind = D.indchannel(details.eventchannel);
    
    if ~isempty(event)    
        trigind  = find(strcmp(details.eventtype, {event.type}));
        eventdata([event(trigind).sample]) = 1;
         D(D.indchannel('event'), :) = eventdata;
          D = chanlabels(D, trigchanind, 'event'); 
          
   
    
    save(D);
    
    end
    
       

    if details.cont_head_loc
        S = [];
        S.D = D;
        if ~isempty(alldewar)
            S.valid_fid = squeeze(alldewar(:, :, f));
        end
        D = spm_eeg_fix_ctf_headloc(S);              
    end
    
    fixedsens = [fixedsens {sensors(D, 'MEG')}];
    fixedfid  = [fixedfid fiducials(D)];
    
    % Montage ========== =============================================
    if ~isempty(details.montage)
        montage = details.montage;

        S = [];
        S.D = D;
        
        if details.oxford
            ind = [];
            
            neeg = length(strmatch('EEG', D.chanlabels));
            if neeg < 8
                ind = [ind; strmatch('Cz', montage.labelnew, 'exact')];
            end
            
            if neeg < 5
                ind = [ind; strmatch('HEOG', montage.labelnew, 'exact')];
                ind = [ind; strmatch('VEOG', montage.labelnew, 'exact')];
            end
            
        elseif details.berlin
        else
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
        end
        
        S.montage = montage;
        S.keepothers = 0;
        D = spm_eeg_montage(S);
        
        if ~keep, delete(S.D);  end
        
    end
    
    D = chantype(D, D.indchannel(details.chan), 'LFP');
    save(D);
    %%
    %D = chantype(D, D.indchannel('LFP_L0R0'), 'PHYS');
    %%
    % Downsample =======================================================
    if 0%D.fsample > 350
        
        S = [];
        S.D = D;
        S.fsample_new = 300;
        
        D = spm_eeg_downsample(S);
        
        if ~keep, delete(S.D);  end
    end
    
    % Artefact marking in MEG =========================================
    if details.berlin % && (isequal(initials(1:4),'PLFP') || isequal(initials(1:4),'DYST'))
        [ampthresh, flatthresh] = berlin_gain(spm_file(files{f}, 'ext', 'gain.txt'));
    end
    
    S = [];
    S.D = D;
    S.mode = 'mark';
    S.badchanthresh = 0.8;
    if details.oxford
        S.methods(1).channels = {'MEGMAG'};
    else
        S.methods(1).channels = {'MEGGRAD'};
    end
    S.methods(1).fun = 'flat';
    if details.berlin % && (isequal(initials(1:4),'PLFP') || isequal(initials(1:4),'DYST'))
        S.methods(1).settings.threshold = flatthresh;%***** Flat thresh
    else
        S.methods(1).settings.threshold = 1e-010;
    end
    S.methods(1).settings.seqlength = 10;
    S.methods(2).channels = {'MEGPLANAR'};
    S.methods(2).fun = 'flat';
    S.methods(2).settings.threshold = 0.1;
    S.methods(2).settings.seqlength = 10;
    if details.oxford
        S.methods(3).channels = {'MEGMAG'};
    else
        S.methods(3).channels = {'MEGGRAD'};
    end
    S.methods(3).fun = 'jump';
    if details.oxford
        S.methods(3).settings.threshold = 50000;
    elseif details.berlin
        S.methods(3).settings.threshold = 1e4; %****Jump thresh
    else
        S.methods(3).settings.threshold = 20000;
    end
    S.methods(3).settings.excwin = 2000;
    S.methods(4).channels = {'MEGPLANAR'};
    S.methods(4).fun = 'jump';
    S.methods(4).settings.threshold = 5000;
    S.methods(4).settings.excwin = 2000;
    
    if details.oxford
        %S.methods = S.methods(2:4); % Just check MEGPLANAR for now
    elseif details.berlin % && (isequal(initials(1:4),'PLFP') || isequal(initials(1:4),'DYST'))
        S.methods(5).channels = {'MEG'};
        S.methods(5).fun = 'threshchan';
        S.methods(5).settings.threshold = ampthresh;
        S.methods(5).settings.excwin = 1000;
    end
    
    D = spm_eeg_artefact(S);
    
    %***** Breakpoint 1
    figure;imagesc(badsamples(D, D.indchantype('MEG'), ':', 1))
    figure;plot(diff(D(D.indchannel('AG083'), :, 1)))
    
    if ~keep
        delete(S.D);
    end
    
    if details.oxford && tsss
%         S = [];
%         S.D = D;
%         S.samples2use = ones(1, D.nsamples);
%         S.trials= 1:D.ntrials;
%         S.modalities = {'MEGMAG', 'MEGPLANAR'};
%         S.do_plots = 1;
%         S.pca_dim = 0;
%         S.force_pca_dim = 0;
%         
%         [D, montage_norm] = normalise_sensor_data(S);
%         
%         
%        [sel1, sel2] = spm_match_str(origsens{end}.label, montage_norm.labelorg);
%         montage_norm.labelorg = montage_norm.labelorg(sel2);
%         montage_norm.tra = montage_norm.tra(:, sel2);
%         selempty  = find(all(montage_norm.tra == 0, 2));
%         montage_norm.tra(selempty, :) = [];
%         montage_norm.labelnew(selempty) = [];
%         
%         
%         origsens{end}  = ft_apply_montage(origsens{end},  montage_norm);
%         fixedsens{end} = ft_apply_montage(fixedsens{end}, montage_norm);   
%         
%         if ~keep, delete(S.D);  end
        
        S = [];
        S.D = D;
        S.magscale   = 0.1;
        D = tsss_spm_enm(S);
        
        D = badchannels(D, D.indchantype('MEGANY'), 0);save(D);
        
        if ~keep, delete(S.D);  end
    end
   
    % Filtering =========================================
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'high';
    S.freq = 1;
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [48 52];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [98 102];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    if ~keep, delete(S.D);  end
        
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [148 152];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [198 202];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [248 252];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [298 302];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [348 352];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [398 402];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [448 452];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [498 502];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [548 552];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'stop';
    S.freq = [598 602];
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    if ~keep, delete(S.D);  end    
    
    % Epoching =========================================
    S = [];
    S.D = D;
    S.trl = trialfun_dcms_rest(struct('dataset', fullfile(D)));
    S.conditionlabels = [seq{f}(isstrprop(seq{f}, 'alpha')) '_' druglbl{drug+1}];
    S.bc = 0;
    D = spm_eeg_epochs(S);
    if ~keep, delete(S.D);  end
    
 
    
    
    % Trial rejection =========================================
    if ~isequal(initials(1:4),'DYST') && isfield(details,'lfpthresh') % dystonia data w/o metal electrode artefact

    S.badchanthresh = details.badchanthresh;
    S.methods(1).channels = details.lfptocheck;
    S.methods(1).fun = 'threshchan';
    S.methods(1).settings.threshold =  details.lfpthresh;
    

    D = spm_eeg_artefact(S);
    if ~keep, delete(S.D);  end
    end
    
    % ************ Breakpoint 2
    ind = D.indchantype('LFP');
    figure;plot(D.time, squeeze(D(ind(2), :, :)))
    
     details.badchanthresh = 0.02;
    S=[];
    S.D=D;
    if ~(details.oxford && tsss)
        S.methods(2).fun = 'events';
        S.methods(2).channels = 'all';
        S.methods(2).settings.whatevents.artefacts = 1;
    end
    
     S.badchanthresh = details.badchanthresh;
     D = spm_eeg_artefact(S);
    
    if ~keep, delete(S.D);  end
    
   
    save(D);
    
    %%
    S = [];
    S.D = D;
    fD{f} = spm_eeg_remove_bad_trials(S);
    
    if ~keep && ~isequal(fname(fD{f}), fname(S.D))
        delete(S.D);
    end
end
%%
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
        
        origheader{f} = fD{f}.origheader;
        
        if ~keep
            delete(fD{f});
        end
    end
    D.fileind = fileind;
    D.origheader = origheader;
elseif  numel(fD)==1
    D = fD{1};
    D.fileind = ones(1, ntrials(D));
end

%%
for i = 1:numel(origfid)
    origfid(i).fid.pnt = origfid(i).fid.pos;
end
sens = spm_cat_struct(origsens{:}, fixedsens{:});
fid  = spm_cat_struct(origfid, fixedfid);
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

rdist = 10*round([dist alldist]/10);

valid = find(all(abs(dist - repmat(mode(rdist, 2), 1, size(dist, 2)))<10));

if isempty(valid)
    if ~isempty(alldist)
        sens = allsens;
        fid  = allfid;
        
        valid = 1:numel(allsens);
    else
        error('No valid senosrs found');
    end
end
% keyboard
spm_figure('GetWin','Graphics');clf;
h = axes;
[asens afid] = ft_average_sens(sens(valid), 'fiducials', fid(valid), 'feedback', h);
%%
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
D.initials = initials;

if details.oxford
    fids = D.fiducials;
    [~, sel] = spm_match_str({'Nasion', 'LPA', 'RPA'}, fids.fid.label);
    fids.fid.pnt = fids.fid.pnt(sel, :);
    fids.fid.label = {'nas'; 'lpa'; 'rpa'};
    
    D = fiducials(D, fids);
end

save(D);

D = dbs_meg_headmodelling(D);
%%
D = D.move([prefix initials '_' druglbl{drug+1}]);