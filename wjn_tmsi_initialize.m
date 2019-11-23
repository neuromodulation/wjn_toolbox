function [sampler,poly5,channels,device,fs,library,t_init]=wjn_tmsi_initialize(filename,channels)

addpath C:\TMSi
try  poly5.close(); end, try  sampler.stop(); end;try  sampler.disconnect(); end, try  library.destroy(); end;
if exist('filename','var') && isnumeric(filename) && filename == -1 ; return ; end
if exist([filename '.Poly5'],'file')
    ov=input('Overwrite? ','s'); 
    if ~strcmp(ov,'y')
        sampler=0;poly5=nan;channels=nan;device=nan;fs=nan;library=nan;t_init=nan;
        return
    end
end

library = TMSi.Library('USB');
if isempty(library.devices)
    library = TMSi.Library('Bluetooth');
end

if isempty(library.devices)
    error('Could not connect to Porti')
end


% while numel(library.devices) == 0
%     library.refreshDevices();
%     pause(1);
% end
device = library.getFirstDevice();
sampler = device.createSampler();
sampler.setReferenceCalculation(false);
sampler.connect();
sampler.start();
fs = sampler.sample_rate;
if exist('filename','var')
    if ~exist('channels','var') 
        channels = 1:38;
    end
    poly5 = TMSi.Poly5([filename '.Poly5'], filename, sampler.sample_rate, device.channels(channels));
else
    poly5 =[];
end
t_init=datetime('now');