D = spm_eeg_load

lbl = D.chanlabels';

montage = [];
montage.labelorg = lbl;
montage.labelnew = [lbl(1:strmatch('MZP01', lbl, 'exact'));...
    'HLC0011'
    'HLC0012'
    'HLC0013'
    'HLC0021'
    'HLC0022'
    'HLC0023'
    'HLC0031'
    'HLC0032'
    'HLC0033'
    'LFP_R12'
    'LFP_R23'
    'LFP_R34'
    'LFP_R45'
    'LFP_R56'
    'LFP_R67'
    'LFP_R78'
    'LFP_L12'
    'LFP_L23'
    'LFP_L34'
    'LFP_L45'
    'LFP_L56'
    'LFP_L67'
    'LFP_L78'
    'VEOG'
    'HEOG'
    'EKG'
    'AccX'
    'AccY'
    'AccZ'
    'Fz'
    'Cz'
    'Pz'
    'T9'
    'T10'
    ];


montage.tra = zeros(numel(montage.labelnew), numel(montage.labelorg));

for i = 1:numel(montage.labelnew)
    ind = strmatch(montage.labelnew{i}, montage.labelorg, 'exact');
    if ~isempty(ind)
      montage.tra(i, ind) = 1;
    end
end

for i = 1:7
    r = strmatch(['LFP_R' num2str(i) num2str(i+1)], montage.labelnew, 'exact');
    c1 = strmatch(['LFP_R' num2str(i)], montage.labelorg, 'exact');
    c2 = strmatch(['LFP_R' num2str(i+1)], montage.labelorg, 'exact');
    
    montage.tra(r, c1) = 1;
    montage.tra(r, c2) = -1;
    
    r = strmatch(['LFP_L' num2str(i) num2str(i+1)], montage.labelnew, 'exact');
    c1 = strmatch(['LFP_L' num2str(i)], montage.labelorg, 'exact');
    c2 = strmatch(['LFP_L' num2str(i+1)], montage.labelorg, 'exact');
    
    montage.tra(r, c1) = 1;
    montage.tra(r, c2) = -1;
end    

r = strmatch('VEOG', montage.labelnew, 'exact');
c1 = strmatch('EOGu', montage.labelorg, 'exact');
c2 = strmatch('EOGl', montage.labelorg, 'exact');

montage.tra(r, c1) = 1;
montage.tra(r, c2) = -1;

r = strmatch('HEOG', montage.labelnew, 'exact');
c1 = strmatch('EOGu', montage.labelorg, 'exact');
c2 = strmatch('EOGs', montage.labelorg, 'exact');

montage.tra(r, c1) = 1;
montage.tra(r, c2) = -1;
