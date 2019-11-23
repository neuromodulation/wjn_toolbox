function fD = dbs_meg_extraction_prepare_spm12(initials, drug, task)

druglbl = {'off', 'on'};

keep = 0;
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
res = mkdir('SPMtask');
cd('SPMtask');

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
    if ~any(f == strmatch(task, seq));
        continue;
    end
    
    S = [];
    S.dataset = files{f};
    if ismember('EEG158',details.eventchannels)
        S.channels = [details.chanset;'EEG158'];
    end
    S.checkboundary = 0;
    S.saveorigheader = 1;
    S.conditionlabels = seq{f};
    S.mode = 'continuous';
    S.outfile = [task num2str(f) '_' spm_file(S.dataset, 'basename')];
    
    if details.brainamp
        D = dbs_meg_brainamp_preproc(S);
    else
        D = spm_eeg_convert(S);
    end
    
    D = sensors(D, 'EEG', []);
    
    origsens =[origsens ft_convert_units(ft_read_sens(S.dataset), 'mm')];
    
    if details.berlin
        origfid  =[origfid ...
            ft_convert_units(ft_read_headshape(spm_file(S.dataset, 'filename', details.markers(f).files{1})))];
        
        D = fiducials(D, origfid(end)); 
        
        D(D.indchannel(details.eventchannels), :) = berlin_correct_eventdata(D(D.indchannel(details.eventchannels), :), initials, task);
        
%         event     = ft_read_trigger(fullfile(D), ...
%             'detectflank', 'up', 'chanindx', D.indchannel(details.eventchannels));
%                  
%         if numel(event)>0
%             for i = 1:numel(event)
%                 event(i).time = event(i).sample./D.fsample;
%             end
% %             event = berlin_motor_to_event(event, initials, task);
%         end
%         keyboard

        [event,eventdata] = wjn_meg_read_events(D,details.eventchannels);
        % global event
        % stop
        if ismember('EEG158',details.eventchannels)
            D=badchannels(D,D.indchannel('EEG158'),1);
            save(D)
            ofname=D.fullfile;
            D=wjn_remove_bad_channels(D.fullfile);
            D.move(ofname)
            D=spm_eeg_load(ofname);
        
        end
    
        D = events(D, 1, rmfield(event, 'sample'));      
        D.teventdata = find(eventdata)./D.fsample;
        D.eventdata = eventdata;
        D.deventdata = eventdata(find(eventdata));
        save(D);
   
        
    else
        origfid  =[origfid ft_convert_units(ft_read_headshape(S.dataset), 'mm')];
        event    = ft_read_event(fullfile(D), 'detectflank', 'both');
            eventdata = zeros(1, D.nsamples);
        
          if ~isempty(event)    
            trigind  = strmatch(details.eventtype, {event.type});
            eventdata([event(trigind).sample]) = [event(trigind).sample];
        end

    end
    
    

    
    trigchanind = D.indchannel(details.eventchannel);
    D = chanlabels(D, trigchanind, 'event');        
    D(trigchanind,:) = eventdata;


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
            montage.tra(end+1, end+1) = 1;
            montage.labelorg{end+1} = 'event';
            montage.labelnew{end+1} = 'event';
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
        S.keepothers = 1;
        D = spm_eeg_montage(S);
        
        if ~keep, delete(S.D);  end
        
    end
    
    D = chantype(D, D.indchannel(details.chan), 'LFP');
    save(D);
    %%
    %D = chantype(D, D.indchannel('LFP_L0R0'), 'PHYS');
    %%
    
    if 0%D.fsample > 350
        
        S = [];
        S.D = D;
        S.fsample_new = 300;
        
        D = spm_eeg_downsample(S);
        
        if ~keep, delete(S.D);  end
    end
    
    if details.berlin
        [ampthresh, flatthresh] = berlin_gain(spm_file(files{f}, 'ext', 'gain.txt'));
    end
    
    S = [];
    S.D = D;
    S.mode = 'mark';
    S.badchanthresh = 0.2; % 0.4; % 0.8;
    if details.oxford
        S.methods(1).channels = {'MEGMAG'};
    else
        S.methods(1).channels = {'MEGGRAD'};
    end
    S.methods(1).fun = 'flat';
    if details.berlin
        S.methods(1).settings.threshold = flatthresh; 
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
        S.methods(3).settings.threshold = 1e4;
    else
        S.methods(3).settings.threshold = 20000;
    end
    S.methods(3).settings.excwin = 2000;
    S.methods(4).channels = {'MEGPLANAR'};
    S.methods(4).fun = 'jump';
    S.methods(4).settings.threshold = 5000;
    S.methods(4).settings.excwin = 2000;
    
    if details.berlin
        S.methods(5).channels = {'MEG'};
        S.methods(5).fun = 'threshchan';
        S.methods(5).settings.threshold = ampthresh;
        S.methods(5).settings.excwin = 1000;
    end
    D = spm_eeg_artefact(S);
    
    if ~keep
        delete(S.D);
    end
    
    if details.oxford && tsss
        S = [];
        S.D = D;
        S.magscale   = 0.1;
        D = tsss_spm_enm(S);
        
        D = badchannels(D, D.indchantype('MEGANY'), 0);save(D);
        if ~keep
            delete(S.D);
        end
    end
    
    S = [];
    S.D = D;
    S.type = 'butterworth';
    S.band = 'high';
    S.freq = 1;
    S.dir = 'twopass';
    S.order = 5;
    D = spm_eeg_filter(S);
    
    
    if ~keep, delete(S.D);  end     
    
    D.initials = initials;
    
    save(D);
    
    fD{f} = D;
end
%%
for i = 1:numel(origfid) %% added 11.04.2017
    origfid(i).fid.pnt = origfid(i).fid.pos;
end
sens = spm_cat_struct(origsens, fixedsens);
fid  = spm_cat_struct(origfid, fixedfid);

pnt = [];

for i = 1:numel(fid)
    pnt = cat(3, pnt, fid(i).fid.pnt);
end

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
        error('No valid sensors found');
    end
end

spm_figure('GetWin','Graphics');clf;
h = axes;
[asens afid] = ft_average_sens(sens(valid), 'fiducials', fid(valid), 'feedback', h);

fD(cellfun('isempty', fD)) = [];
nf = numel(fD);

for i = 1:nf
    D = fD{i};
    
    if ismember(nf + i, valid)
        D = sensors(D, 'MEG', sens(nf + i));
        D = fiducials(D, fid(nf + i));
    elseif valid(i)
        D = sensors(D, 'MEG', sens(i));
        D = fiducials(D, fid(i));
    else
        D = sensors(D, 'MEG', asens);
        D = fiducials(D, afid);
    end
    
    if details.oxford
        fids = D.fiducials;
        [~, sel] = spm_match_str({'Nasion', 'LPA', 'RPA'}, fids.fid.label);
        fids.fid.pnt = fids.fid.pnt(sel, :);
        fids.fid.label = {'nas'; 'lpa'; 'rpa'};
        
        D = fiducials(D, fids);
    end
    
    save(D);
    D = dbs_meg_headmodelling(D);    
    D = D.move([initials '_' druglbl{drug+1} '_' task num2str(i)]);
    
    fD{i} = D;
end

%%


