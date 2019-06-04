function D = wjn_meg_import_ptb_con(confile,fiducialtxtfile,mri,fidmricoordinates)
% D = wjn_meg_import_ptb_con(confile,fiducialtxtfile,mri,fidmricoordinates)
% confile = ***.00?0.con file
% fiducialtxtfile = '***.before-coregis.txt'
% mri = ***.nii % individual structural mri (optional)
% fidmricoordinates = fid(1,:) = nas, fid(2,:) = lpa, fid(3,:) = rpa;
% alternatively load a txt file created by till

S = [];
S.dataset = confile;
S.checkboundary = 0;
S.saveorigheader = 1;
S.mode = 'continuous';
D=spm_eeg_convert(S);
%%
origsens  = {};
origfid   = [];
fixedsens = {};
fixedfid  = [];
D = sensors(D, 'EEG', []);
origsens =[origsens  {ft_datatype_sens(ft_read_sens(S.dataset, 'senstype', 'meg'), 'version', 'latest', 'amplitude', 'T', 'distance', 'mm')}];
origfid  =[origfid ...
ft_convert_units(ft_read_headshape(spm_file(S.dataset, 'filename', fiducialtxtfile)))];  
D = fiducials(D, origfid(end)); 
str = stringsplit(confile,'.');
fname = D.fname;
D.move([fname(1:end-4) '_' str{2}(2)]);
D=spm_eeg_load([fname(1:end-4) '_' str{2}(2)]);

try
    eventchannels = {'EEG157','EEG158','EEG159','EEG160'};



event = struct('type',[],'value',[],'time',[],'sample',[],'offset',[],'duration',[]);
n=0;

    for a = 1:length(eventchannels)
        d = round(10.*D(D.indchannel(eventchannels{a}),:,1))/10;
        i = 1+find(diff(abs(d)>.05));
        for b  =1:2:length(i)-1
            n=n+1;
            event(n).type = eventchannels{a};
            event(n).value = d(i(b));
            event(n).time = i(b)/D.fsample;
            event(n).sample = i(b);
            event(n).offset = 0;
            event(n).duration = i(b+1)/D.fsample-i(b)/D.fsample;
        end          
    end



eventdata = zeros(1, D.nsamples);
eventdata([event(:).sample]) = [event(:).value];


D=events(D,1,rmfield(event,'sample'));

save(D);



dim = size(D);
dim(1) = dim(1) + 1;

[fdir,fname,ext]=fileparts(D.fullfile);
nD = clone(D,fullfile(fdir,['a' fname ext]),dim);
nD = chanlabels(nD,':',[D.chanlabels 'event']);
nD(1:D.nchannels,:,:) = D(:,:,:);
nD = chantype(nD,':',[D.chantype 'Other']);
nD = chantype(nD,nD.indchantype('EEG'),'Other');
nD(nD.indchannel('event'),:,1) = eventdata;
save(nD);
clear D
delete(fullfile(fdir,[fname '.*']))
D=nD;
catch
    disp('No events created from event channels!')
end



% ampthresh = 10098;
% flatthresh = 3.4241;
% 
% 
% S = [];
% S.D = D;
% S.mode = 'mark';
% S.badchanthresh = 0.2; % 0.4; % 0.8;
% S.methods(1).channels = {'MEGGRAD'};
% S.methods(1).fun = 'flat';
% S.methods(1).settings.threshold = flatthresh; 
% S.methods(1).settings.seqlength = 10;
% S.methods(2).channels = {'MEGPLANAR'};
% S.methods(2).fun = 'flat';
% S.methods(2).settings.threshold = 0.1;
% S.methods(2).settings.seqlength = 10;
% S.methods(3).channels = {'MEGGRAD'};
% S.methods(3).fun = 'jump';
% S.methods(3).settings.threshold = 1e4;
% S.methods(3).settings.excwin = 2000;
% S.methods(4).channels = {'MEGPLANAR'};
% S.methods(4).fun = 'jump';
% S.methods(4).settings.threshold = 5000;
% S.methods(4).settings.excwin = 2000;
% S.methods(5).channels = {'MEG'};
% S.methods(5).fun = 'threshchan';
% S.methods(5).settings.threshold = ampthresh;
% S.methods(5).settings.excwin = 1000;
% D = spm_eeg_artefact(S);




origfid.fid.pnt = origfid.fid.pos;
fid  = origfid;
D=fiducials(D,fid);
save(D);

try
    D = rmfield(D, 'inv');
    save(D)
end


clear matlabbatch
matlabbatch{1}.spm.meeg.source.headmodel.D = {fullfile(D)};
matlabbatch{1}.spm.meeg.source.headmodel.val = 1;
matlabbatch{1}.spm.meeg.source.headmodel.comment = '';

if exist('mri','var')
    disp('loading MRI')
    try
        fid = importdata(fidmricoordinates);
    catch
        fid.data = fidmricoordinates;
    end
    matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.mri = { mri};
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.type = fid.data(1, :);
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.type = fid.data(2, :);
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'rpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.type = fid.data(3, :);
else
    disp('Using template head model')
    matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.template = 1;
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.select = 'nas';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.select = 'lpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'rpa';
    matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.select = 'rpa';
end
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshres = 2;
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.useheadshape = 0;
matlabbatch{1}.spm.meeg.source.headmodel.forward.meg = 'Single Shell';
spm_jobman('run', matlabbatch);
%%
D = reload(D);
print([fname 'headmodel'],'-dpng')
    


if exist('fid.data', 'var')
    
    meegfid = D.fiducials;
    mrifid.fid.pnt = fid.data;
    mrifid.fid.label = {'nas'; 'lpa'; 'rpa'};
    mrifid.pnt = [];

    tempfid = ft_transform_headshape(D.inv{1}.mesh.Affine\D.inv{1}.datareg.toMNI, meegfid);
    tempfid.fid.pnt(:, 2) = tempfid.fid.pnt(:, 2)- tempfid.fid.pnt(1, 2)+ mrifid.fid.pnt(1, 2);
    tempfid.fid.pnt(:, 3) = tempfid.fid.pnt(:, 3)- mean(tempfid.fid.pnt(2:3, 3))+ mean(mrifid.fid.pnt(2:3, 3));
    M1 = spm_eeg_inv_rigidreg(tempfid.fid.pnt', meegfid.fid.pnt');

    D.inv{1}.datareg(1).sensors = D.sensors('MEG');
    D.inv{1}.datareg(1).fid_eeg = meegfid;
    D.inv{1}.datareg(1).fid_mri = ft_transform_headshape(inv(M1), mrifid);
    D.inv{1}.datareg(1).toMNI = D.inv{1}.mesh.Affine*M1;
    D.inv{1}.datareg(1).fromMNI = inv(D.inv{1}.datareg(1).toMNI);
    D.inv{1}.datareg(1).modality = 'MEG';


    % check and display registration
    %--------------------------------------------------------------------------
    spm_eeg_inv_checkdatareg(D);

    print('-dtiff', '-r600', fullfile(D.path, 'datareg.tiff'));

    D = spm_eeg_inv_forward(D);

    spm_eeg_inv_checkforward(D);

    print('-dtiff', '-r600', fullfile(D.path, 'forward.tiff'));

    save(D);
end
D.move(fullfile(fdir,fname));
D=spm_eeg_load(fullfile(fdir,[fname '.ext']));
delete(fullfile(fdir,['faa' fname '.*']))
delete(fullfile(fdir,['aa' fname '.*']))
delete(fullfile(fdir,['a' fname '.*']))

S = [];
S.D = D;
S.type = 'butterworth';
S.band = 'high';
S.freq = .5;
S.dir = 'twopass';
S.order = 5;
D = spm_eeg_filter(S);



S = [];
S.D = D;
S.type = 'butterworth';
S.band = 'low';
S.freq = 150;
S.dir = 'twopass';
S.order = 5;
D = spm_eeg_filter(S);

S = [];
S.D = D;
S.type = 'butterworth';
S.band = 'stop';
S.freq = [48 52];
S.dir = 'twopass';
S.order = 5;
D = spm_eeg_filter(S);


S.D = D.fullfile;
S.fsample_new = 256;
D=spm_eeg_downsample(S);

D.move(fullfile(fdir,['d' fname ext]));
delete(fullfile(fdir,['f*' fname '.*']));
D=spm_eeg_load(fullfile(fdir,['d' fname ext]));
