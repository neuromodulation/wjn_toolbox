function [current_amp]=wjn_stim_AO(start_stop,channel_number,stim_amp,ramp_duration,stim_duration,return_channel,freq_hz,pulse_width,display)

if length(start_stop)==2
    rs = start_stop(2);
else
    rs = 1;
end

if ~exist('display','var')
    display=0;
end

if ~exist('freq_hz','var') ||isempty(freq_hz)
    freq_hz = 130;
end

if ~exist('pulse_width','var') || isempty(pulse_width)
    pulse_width = 60;
end


if ~exist('return_channel','var') ||isempty(return_channel)
    return_channel = -1;
end



if ~exist('ramp_duration','var') || isempty(ramp_duration)
    ramp_duration = 5:5:250;
elseif ramp_duration(1) == 0 && length(ramp_duration)>1
    ramp_duration(1) = [];
end

if exist('stim_amp','var') && length(return_channel)==1 && length(channel_number)>1
    return_channel(1:length(channel_number))=return_channel;
end

if ~exist('stim_amp','var')
    stim_amp = 0;
elseif length(stim_amp) == 1
    stim_amp = [0 stim_amp];
end

for a =1:length(return_channel)
    if return_channel(a) ~= -1
        return_channel(a) = 10015+return_channel(a);
    end
end

if ~exist('stim_duration','var') || isempty(stim_duration) || stim_duration == 0
    duration_set = 0;
    stim_duration_sec = inf;
else
    stim_duration_sec = stim_duration;
    duration_set = 1;
    disp(['Duration : ' num2str(stim_duration_sec) ' s'])
end
FirstPhaseDelay_mS    =0;       %the delay of the first phase
FirstPhaseWidth_mS    =pulse_width/1000;    %the width of the first phase
SecondPhaseDelay_mS   =0;       %the delay of the second phase
SecondPhaseWidth_mS   =pulse_width/1000;

if start_stop(1) == 1
    channel_number = 10015+channel_number;
    if display
        disp(['Freq : ' num2str(freq_hz) ' Hz'])
        disp(['Channel : ' num2str(channel_number) ])
        disp(['Amplitude : ' num2str(stim_amp(end)) ' mA'])
        disp(['Ramp : ' num2str(ramp_duration(end))])
    end
    if ramp_duration(1)~=0
        ramptic = tic;
        ramp_amps = linspace(stim_amp(1),stim_amp(2),length(ramp_duration));
        for c = 1:length(ramp_duration)
            while (toc(ramptic)*1000)<ramp_duration(c)
            end
            cstim = ramp_amps(c);
            if display
            fprintf([num2str(cstim,1) 'mA '])
            end
            FirstPhaseAmpl_mA = cstim;
            SecondPhaseAmpl_mA = cstim;
            if rs
                for d = 1:length(channel_number)
                    AO_StartDigitalStimulation(channel_number(d), FirstPhaseDelay_mS, FirstPhaseAmpl_mA, FirstPhaseWidth_mS, SecondPhaseDelay_mS, SecondPhaseAmpl_mA, SecondPhaseWidth_mS, freq_hz, stim_duration_sec, return_channel(d));%set stimulation params
                end
            end
        end
    else
        cstim = stim_amp(2);FirstPhaseAmpl_mA = cstim;SecondPhaseAmpl_mA = cstim;
        ramptic=tic;
        if display
            fprintf([num2str(cstim,1) 'mA '])
        end
        if rs
            for d = 1:length(channel_number)
                AO_StartDigitalStimulation(channel_number(d), FirstPhaseDelay_mS, FirstPhaseAmpl_mA, FirstPhaseWidth_mS, SecondPhaseDelay_mS, SecondPhaseAmpl_mA, SecondPhaseWidth_mS, freq_hz, stim_duration_sec, return_channel(d));%set stimulation params
            end
        end
%         disp(cstim)
    end
    
    if duration_set
        while toc(ramptic)<=stim_duration_sec-(ramp_duration(end)/1000)
        end
        if ramp_duration(1)~=0
            ramptic=tic;
            ramp_amps = linspace(stim_amp(2),stim_amp(1),length(ramp_duration));
            for c = 1:length(ramp_duration)
                while (toc(ramptic)*1000)<ramp_duration(c)
                end
                cstim = ramp_amps(c);
                if display
                    fprintf([num2str(cstim,1) 'mA '])
                end
                FirstPhaseAmpl_mA = cstim;
                SecondPhaseAmpl_mA = cstim;
%                 disp(cstim)
                if rs
                    for d = 1:length(channel_number)
                        AO_StartDigitalStimulation(channel_number(d), FirstPhaseDelay_mS, FirstPhaseAmpl_mA, FirstPhaseWidth_mS, SecondPhaseDelay_mS, SecondPhaseAmpl_mA, SecondPhaseWidth_mS, freq_hz, stim_duration_sec, return_channel(d));%set stimulation params
                    end
                end
            end
            
        else
            cstim = stim_amp(1);FirstPhaseAmpl_mA = cstim;SecondPhaseAmpl_mA = cstim;
            if display
                fprintf([num2str(cstim,1) 'mA '])
            end
            %             disp(cstim)
            if rs
                for d = 1:length(channel_number)
                    AO_StartDigitalStimulation(channel_number(d), FirstPhaseDelay_mS, FirstPhaseAmpl_mA, FirstPhaseWidth_mS, SecondPhaseDelay_mS, SecondPhaseAmpl_mA, SecondPhaseWidth_mS, freq_hz, stim_duration_sec, return_channel(d));%set stimulation params
                end
            end
        end
    end
    
    current_amp = cstim;
elseif start_stop(1) == 0
    disp('STIM OFF')
    if ~exist('channel_number','var')
        channel_number = 1:16;
        return_channel = ones(size(channel_number)).*-1;
    end
    channel_number = 10015+channel_number;
    cstim = 0;
    if display
        fprintf([num2str(cstim,1) 'mA '])
    end
    FirstPhaseAmpl_mA = cstim;
    SecondPhaseAmpl_mA = cstim;
    if rs
        for d = 1:length(channel_number)
            AO_StartDigitalStimulation(channel_number(d), FirstPhaseDelay_mS, FirstPhaseAmpl_mA, FirstPhaseWidth_mS, SecondPhaseDelay_mS, SecondPhaseAmpl_mA, SecondPhaseWidth_mS, freq_hz, stim_duration_sec, return_channel(d));%set stimulation params
        end
    end
    
    current_amp = cstim;
elseif start_stop(1) == -1
    if rs
        if ~exist('channel_number','var')
            channel_number = 1:16;
        end
        channel_number = 10015+channel_number;
        for d = 1:length(channel_number)
            AO_StopStimulation(channel_number(d))
        end
    end
    current_amp = 0;
end

% disp(['CURRENT AMP: ' num2str(current_amp,2)])