function D=wjn_import_rawdata(filename,idata,chanlabels,fs,format,additional_info)
% function D=wjn_import_rawdata(filename,idata,chanlabels,fs,format,additional_info)
% format is optional, defaults to spm, but can also be fieldtrip


if ~exist('format','var')
    format = 'spm';
end
if size(idata,1) > 400 && size(idata,1) > size(idata,2)
    idata = idata';
end
data.trial{1} = double(idata);
data.time{1} = linspace(0,length(idata)/fs,length(idata));
data.label = chanlabels;
data.fsample = fs;
if exist('additional_info','var')
    data.info = additional_info;
end

if strcmp(format,'fieldtrip')
    
    data.hdr.Fs = fs;
    data.hdr.nChans =length(chanlabels);
    data.hdr.nSamples = length(data.trial{1});
    data.hdr.nSamplesPre = 0;
    data.hdr.nTrials = 1;
    data.hdr.label = chanlabels;
    data.hdr.chantype = wjn_chantype(chanlabels,'fieldtrip');
    data.hdr.chanunit = repmat({'unknown'},[1 data.hdr.nChans]);
    
    save(filename,'data')
    D=data;
elseif strcmp(format,'spm')
    D=spm_eeg_ft2spm(data,filename);
    D=chantype(D,':','Other');
    ilfp = ci({'LFP','STN','GPi','VIM','ecog'},chanlabels);
    iemg = ci({'EMG'},chanlabels);
    ieeg = ci({'EEG','Cz','C3','C4'},chanlabels);
    D=chantype(D,ieeg,'EEG');
    D=chantype(D,iemg,'EMG');
    D=chantype(D,ilfp,'LFP');
    if exist('additional_info','var')
        D.info = additional_info;
    end
    save(D)
    check(D)
end
