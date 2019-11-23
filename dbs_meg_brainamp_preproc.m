function D = dbs_meg_brainamp_preproc(S)
% Fuse simultaneously recorded MEG and EEG datasets based on a common
% reference noise channel
% FORMAT  D = presma_brainamp_preproc(S);
%
% S           - input structure (optional)
% (optional) fields of S:
%   S.dataset       - name of the MEG dataset
%
%   S.ref1     - name of the reference channel in EEG dataset
%   S.ref2     - name of the reference channel in MEG dataset
%
% D        - MEEG object (also written to disk, with a 'u' prefix)
%__________________________________________________________________________
% Copyright (C) 2011 Wellcome Trust Centre for Neuroimaging
%
% Vladimir Litvak
% $Id: dbs_meg_brainamp_preproc.m 76 2014-02-11 16:21:33Z vladimir $

SVNrev = '$Rev: 76 $';

%-Startup
%--------------------------------------------------------------------------
spm('FnBanner', mfilename, SVNrev);
spm('FigName','Brainamp preproc'); spm('Pointer','Watch');

if nargin == 0
    S = [];
end

%-Get MEEG objects
%--------------------------------------------------------------------------
if ~isfield(S, 'dataset')
    [dataset, sts] = spm_select(1, '.*', 'Select MEG dataset');
    if ~sts, dataset = []; return; end
    S.dataset = dataset;
end

if ~isfield(S, 'ref1')
    S.ref1 = 'Noise';
end

if ~isfield(S, 'ref2')
    S.ref2 = 'UADC001';
end

[p, f] = fileparts(S.dataset);

if ~isempty(strfind(p, '.ds'))
    p = spm_str_manip(p, 'h');
end

S1 = [];
S1.mode = 'continuous';
S1.checkboundary = 0;

S1.dataset = fullfile(p, dbs_meg_brainamp_file(S.dataset));
D1 = spm_eeg_convert(S1);
S1.dataset = S.dataset;
S1.saveorigheader = 1;

try 
    S1.channels = S.channels;
end

if isempty(strmatch(S.ref2, S1.channels))
    S1.channels{end+1} = S.ref2;
end

D2 = spm_eeg_convert(S1);

origchantypes =  D2.origchantypes;
origheader = D2.origheader;


D1 = chantype(D1, ':', 'LFP');save(D1);

S1 = [];
S1.D = D1;
S1.fsample_new = D2.fsample;
D1 = spm_eeg_downsample(S1);

delete(S1.D);

ev = ft_read_event(fullfile(D1.path, D1.fname));
ev1 = ev(2:end);
ev = ft_read_event(fullfile(D2.path, D2.fname));
ind = strmatch('UPPT001_up', {ev.type});
ev2 = ev(ind);
%
n1 = detrend(D1(D1.indchannel(S.ref1), :));
n2 = detrend(D2(D2.indchannel(S.ref2), :));

minl = min(length(n1), length(n2));

[c, lags] = xcorr(n1(1:minl), n2(1:minl), 'coeff');

[mc, mci] = max(abs(c));
if mc/median(abs(c)) < 50
    noisematch = 0;
else
    noisematch = 1;
end

%%
s1 = [ev1.sample];
[s1, ind] = unique(s1);
ev1 = ev1(ind);

s2 = [ev2.sample];

ss1 = repmat(s1(:)', length(s2), 1);
ss2 = repmat(s2(:), 1, length(s1));

ssd = ss1 - ss2;

mssd = mode(ssd(:));

if isempty(ssd) || sum(abs(ssd(:)-mssd)<5)./min(length(s1), length(s2))<0.7  
    eventsmatch = 0;
else
    eventsmatch = 1;
end

disp([D1.fname ' and ' D2.fname]);
if noisematch && eventsmatch
    if abs(lags(mci)-mssd)<100
        offset = round(mean([lags(mci), mssd]));        
        disp('Noises and events both match');
    else
        warning('Noise and events do not give compatible offsets');   
        offset = lags(mci);
    end
elseif noisematch
    disp('No event match. Offset is based on noise only');
    offset = lags(mci);
elseif eventsmatch
    disp('No noise match. Offset is based on events only');
    offset = mssd;
else
    error('No way to match the files')
end

megtrl = 1:D2.fsample:D2.nsamples;

megtrl = [megtrl(1:(end-1))' megtrl(2:(end))'-1];

eegtrl = megtrl(:, 1:2)+offset;

if size(megtrl, 2)>2
    eegtrl = [eegtrl megtrl(:, 3:end)];
end

inbounds1 = (eegtrl(:,1)>=1 & eegtrl(:, 2)<=D1.nsamples);
inbounds2 = (megtrl(:,1)>=1 & megtrl(:, 2)<=D2.nsamples);

rejected = find(~(inbounds1 & inbounds2));
rejected = rejected(:)';

if ~isempty(rejected)
    eegtrl(rejected, :) = [];
    megtrl(rejected, :) = [];
    warning(['Events ' num2str(rejected) ' not extracted - out of bounds']);
end

shifts = {};

if noisematch
    
    for i = 1:size(megtrl, 1)
        cn1 = n1(eegtrl(i, 1):eegtrl(i, 2));
        cn2 = n2(megtrl(i, 1):megtrl(i, 2));
        
        [c, lags] = xcorr(cn1, cn2, 'coeff');
        [mc mci] = max(abs(c(find(abs(lags)<20))));
        mci = mci - find(lags(find(abs(lags)<20)) == 0);
        
        if mc>0.2
            eegtrl(i, 1:2) = eegtrl(i, 1:2) + mci;
            shifts{i, 1} = mci;
        end
        
        if eventsmatch
            % warning(['No fine noise match for trial ' num2str(i) '. Trying events']);
            cs1 = s1(s1>=eegtrl(i, 1) & s1<=eegtrl(i, 2)) - eegtrl(i, 1);
            cs2 = s2(s2>=megtrl(i, 1) & s2<=megtrl(i, 2)) - megtrl(i, 1);
            
            if ~isempty(cs1) && ~isempty(cs2)
                
                ccs1 = repmat(cs1(:)', length(cs2), 1);
                ccs2 = repmat(cs2(:), 1, length(cs1));
                
                ccsd = ccs1 - ccs2;
                ccsd = ccsd(:);
                ccsd = ccsd(ccsd<10);
                
                if ~isempty(ccsd)
                    mccsd = mode(ccsd);
                    shifts{i, 2} = mccsd;
                    if mc<=0.2
                        eegtrl(i, 1:2) = eegtrl(i, 1:2) - mccsd;
                    end
                end
            end
        end
    end
end
%%
S1 = [];
S1.D  = D1;  
S1.bc = 0;
S1.trl = eegtrl;
D1e = spm_eeg_epochs(S1);

delete(D1);

S1.D = D2;
S1.trl = megtrl;
D2e = spm_eeg_epochs(S1);

delete(D2);
%%
if ismember('LFP_R0', D1e.chanlabels)
    eeglabel = {
        'EEG001'
        'EEG002'
        'EEG003'
        'EEG004'
        'EEG005'
        'EEG006'
        'EEG007'
        'EEG008'
        'EEG009'
        'EEG010'
        'EEG011'
        'EEG012'
        'EEG013'
        'EEG014'
        'EEG015'
        'EEG016'
        };
    D1e = chanlabels(D1e, 1:16, eeglabel);save(D1e);
end
%%
S1 = [];
S1.D = char(fullfile(D2e), fullfile(D1e));
D = spm_eeg_fuse(S1);
D.shifts = shifts;
save(D);

delete(D1e);
delete(D2e);

S1 = [];
S1.mode = 'continuous';
S1.checkboundary = 0;
S1.dataset = fullfile(D);
Dn = spm_eeg_convert(S1);

delete(D);
D = Dn;

D.origchantypes = origchantypes;
D.origheader = origheader; 
save(D);

S1 = [];
S1.task = 'defaulttype';
S1.D = D;
S1.save = 1;
S1.updatehistory = 0;
D = spm_eeg_prep(S1);
