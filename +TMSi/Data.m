classdef Data < TMSi.HiddenHandle
    %DATA Class that will store data that we sampled from a TMSi device.
    %
    %DATA Properties:
    %   name - Name for this data object.
    %   sample_rate - Rate this data was sampled at.
    %   channels - A cell array containing channel structures (see TMSi.Device).
    %   data - A matrix containing the sample data order as num_channels x num_samples.
    %   num_samples - Number of samples in this data object.
    %   time - The total time of data (num_samples / sample_rate).
    %   date - Date of objects creation.
    %
    %DATA Methods:
    %   Data - Constructor for the Data object.
    %   append - Append samples to this data object.
    %   trim - Trim the internal data matrix to exact propertions.
    %   toEEGLab - Transform information to EEG EEGLAB object.
    %
    %DATA Example:
    %   sampler = device.createSampler();
    %   data = TMSi.Data('Example', sampler.sample_rate, sampler.device.channels);
    %
    %   sampler.connect();
    %   sampler.start();
    %   while n < 10
    %       samples = sampler.sample();
    %       data.append(samples);
    %   end
    %   sampler.stop();
    %   sampler.disconnect(); 
    %   data.trim();
    %
    %   eeglab(data.toEEGLab());

    properties (SetAccess = private)
        % Name for this data object.
        name

        % Rate this data was sampled at.
        sample_rate

        % A cell array containing channel structures (see TMSi.Device).
        channels

        % A matrix containing the sample data order as num_channels x num_samples.
        samples

        % Number of samples in this data object.
        num_samples

        % The total time of data (num_samples / sample_rate).
        time

        % Date of objects creation.
        date
    end

    properties (Access = private) 
        
    end

    methods
        function obj = Data(name, sample_rate, channels, samples)
            %DATA - Constructor for the Data object.
            %
            %   Contructor for the data object. Requires a name, sample rate and
            %   channel information as part of the Device object.
            %
            %   name - Name of the Data object.
            %   sample_rate - Sample rate of this data in Hz.
            %   channels - Cell structure with channel structure (see TMSi.Device/channels)
            %       Minimum elements need to be .name and .unit_name.

            if ~exist('samples', 'var')
                samples = [];
            end

            obj.name = name;
            obj.sample_rate = sample_rate;
            obj.channels = channels;
            obj.samples = [];
            obj.num_samples = 0;
            obj.time = 0;
            obj.date = clock;

            if size(samples, 2) > 0
                obj.samples = samples;
                obj.num_samples = size(samples, 2);
                obj.time = size(samples, 2) / obj.sample_rate;
            end

        end

        function append(obj, samples)
            %APPEND - Append samples to this data object.
            %
            %   Append samples as retrieved from a Sampler object to the current
            %   data. If a subset of channels are selected, make sure you also only
            %   add the samples from the channels you want stored.
            %
            %   samples - A matrix with samples of the form numel(channels) x num_samples.

            index_start = obj.num_samples + 1;
            index_end = obj.num_samples + size(samples, 2);

            if index_end > size(obj.samples, 2)
                obj.samples(:, size(obj.samples, 2) + obj.sample_rate * 10) = 0;
            end

            obj.samples(:, index_start:index_end) = samples(:, :);

            obj.num_samples = obj.num_samples + size(samples, 2);
            obj.time = obj.num_samples / obj.sample_rate;
        end

        function trim(obj)
            %TRIM - Trim the internal data matrix to exact propertions.
            %
            %   This function will trim the data variable to precise size. If you
            %   do not do this the samples variable will have more samples than you 
            %   appended.

            obj.samples = obj.samples(:, 1:obj.num_samples);
        end

        function eeg = toEEGLab(obj)
            %TOEEGLAB - Transform information to EEG EEGLAB object.
            %
            %   This function will transform the data contained in this object, into
            %   a EEGLAB compatible object. You can use the returned object as follows:
            %       eeglab(data.toEEGLab());
            
            if obj.num_samples ~= size(obj.samples, 2)
                warning('You forgot to trim the data, call obj.trim() before calling this function.');
            end
            
            eeg = eeg_emptyset;

            eeg.setname = ['Continuous Data TMSi Name: ' obj.name];
            eeg.pnts = obj.num_samples;
            eeg.nbchan = size(obj.samples, 1);
            eeg.trials = 1;
            eeg.srate = obj.sample_rate;

            eeg.xmax = (obj.num_samples - 1) / obj.sample_rate;

            eeg.times = (0:obj.num_samples-1) / obj.sample_rate;

            eeg.data = reshape(obj.samples, size(obj.samples, 1), size(obj.samples, 2), 1);

            for i=1:numel(obj.channels)
                eeg.chanlocs(i).theta = 0;
                eeg.chanlocs(i).radius = 0;
                eeg.chanlocs(i).labels = obj.channels{i}.name;
                eeg.chanlocs(i).sph_theta = 0;
                eeg.chanlocs(i).sph_phi = 0;
                eeg.chanlocs(i).sph_radius= 0;
                eeg.chanlocs(i).X = 0;
                eeg.chanlocs(i).Y = 0;
                eeg.chanlocs(i).Z = 0;
            end

            eeg = eeg_checkset(eeg);
        end
    end
end