function D = dbs_meg_stim_prepare_spm12(initials, drug)

druglbl = {'off', 'on'};

keep = 1;
tsss = 0;

try
    [files, seq, root, details] = dbs_subjects(initials, drug);
catch
    D = [];
    return
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
res = mkdir('SPMstim');
cd('SPMstim');

if details.cont_head_loc
    [alldewar, alldist, allsens, allfid] = dbs_meg_headloc(files);
else
    alldewar = [];
    alldist = [];
end

fD = {};
%%
origsens  = [];
origfid   = [];
fixedsens = [];
fixedfid  = [];
for f = 1:numel(files)
    if ~strncmpi('STIM', seq{f}, 4);
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
    
     % =============  Post conversion refinements
    
    D = sensors(D, 'EEG', []);
    
    origsens =[origsens ft_convert_units(ft_read_sens(S.dataset), 'mm')];
    
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
    end
    
    D = chanlabels(D, trigchanind, 'event');        
    
    D(D.indchannel('event'), :) = eventdata;
    
    save(D);
    
    if details.cont_head_loc
        S = [];
        S.D = D;
        if ~isempty(alldewar)
            S.valid_fid = squeeze(alldewar(:, :, f));
        end
        D = spm_eeg_fix_ctf_headloc(S);              
    end
    
    fixedsens = [fixedsens sensors(D, 'MEG')];
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
    
    lblorig = {'LFP_L0R0', 'LFP_R01',  'LFP_R12', 'LFP_R23', 'LFP_L01', 'LFP_L12', 'LFP_L23'};
    lblnew  = { 'STIM', 'LFP_STIM', 'LFP_CLEAN', 'Unused', 'LFP_CONTRA_01', 'LFP_CONTRA_12', 'LFP_CONTRA_23'};
    
    D = chanlabels(D, D.indchannel(lblorig), lblnew);
    
    D = chantype(D, strmatch('LFP', D.chanlabels), 'LFP');
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
    if details.berlin
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
    if details.berlin
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
    else
        S.methods(3).settings.threshold = 1e6;    
    end
    S.methods(3).settings.excwin = 500;
    S.methods(4).channels = {'MEGPLANAR'};
    S.methods(4).fun = 'jump';
    S.methods(4).settings.threshold = 5000;
    S.methods(4).settings.excwin = 500;
    
    if details.oxford
        S.methods = S.methods(2:4); % Just check MEGPLANAR for now   
    end        
    
    D = spm_eeg_artefact(S);
    
    %***** Breakpoint 1
    % figure;imagesc(badsamples(D, D.indchantype('MEG'), ':', 1))
    % figure;plot(diff(D(D.indchannel('AG083'), :, 1)))
    
    if ~keep
        delete(S.D);
    end
    
    
    S = [];
    S.D = D;
    S.channels = 'MEG';
    S.threshold = 1e6;
    
    D = spm_eeg_remove_jumps(S);
    
    if ~keep, delete(S.D);  end
    
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
    
    
    
    % Epoching =========================================    
    
    S = [];
    S.D = D;
    S.seq = seq{f};
    [S.trl, S.conditionlabels] =  stim_trialfun(S);
    S.bc = 0;
    D = spm_eeg_epochs(S);
    
    if ~keep, delete(S.D);  end      
         
    fD{f} = D;
      
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
sens = spm_cat_struct(origsens, fixedsens);
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
D.initials = initials;

if details.oxford
    fid = D.fiducials;
    [~, sel] = spm_match_str({'Nasion', 'LPA', 'RPA'}, fid.fid.label);
    fid.fid.pnt = fid.fid.pnt(sel, :);
    fid.fid.label = {'nas'; 'lpa'; 'rpa'};
    
    D = fiducials(D, fid);
end

cl = {'STIM_L_0', 'STIM_L_5', 'STIM_L_20', 'STIM_L_130', 'STIM_R_0', 'STIM_R_5', 'STIM_R_20', 'STIM_R_130'};

D = condlist(D, cl);

save(D);

D = dbs_meg_headmodelling(D);

D = D.move([initials '_' druglbl{drug+1}]);
%%
figure;
for i = 1:numel(cl)
    subplot(2, 4, i);
    imagesc(squeeze(D(D.indchannel('STIM'), :,D.indtrial(cl{i}))));
    title(cl{i}, 'Interpreter', 'none');
end
%%
print('-dtiff', '-r600', 'stimchannel.tiff')
%%
S = [];
S.D = D;
D = dbs_meg_stim_clean_lfp(S);

%%
D = badtrials(D, ':', 1);
D = badtrials(D, D.indtrial({'STIM_R_130',  'STIM_R_0',  'STIM_L_130', 'STIM_L_0'}), 0);
S = [];
S.D = D;
D = spm_eeg_remove_bad_trials(S);
%%
chancomb =  ft_channelcombination({'LFP_STIM', 'MEG'}, D.chanlabels(D.indchantype('ALL', 'GOOD')));

S = [];
S.D = D;
S.chancomb =  chancomb;
S.pretrig  = 0;
S.posttrig = 1000;
S.timewin  = 1000*(D.nsamples-1)/D.fsample;
S.timestep = 1/D.fsample;
S.freqwin  = [1 45];
S.robust.savew = false;
S.robust.bycondition = true;
S.robust.ks = 5;

D1 = spm_eeg_ft_multitaper_coherence(S);

D1 = chanlabels(D1, ':', chancomb(:, 2));
save(D1)
%
S1 = [];
S1.task = 'defaulttype';
S1.D = D1;
S1.updatehistory = 0;
D1 = spm_eeg_prep(S1);
%
S1 = [];
S1.task = 'project3D';
S1.modality = 'MEG';
S1.updatehistory = 0;
S1.D = D1;

D1 = spm_eeg_prep(S1);

save(D1);
%
S = [];
S.D = D1;
S.mode = 'scalp x frequency';
spm_eeg_convert2images(S);
