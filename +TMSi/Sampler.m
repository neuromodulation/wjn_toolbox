classdef Sampler < TMSi.HiddenHandle
    %SAMPLER Class provides sampling capabilities for a single TMSi device.
    %
    %   The Sampler class encapsulates the functionality of sampling TMSi device. This
    %   can be either done in normal mode, or impedance mode. In case of impedance mode
    %   the sampling frequency is fixed and is not represented in the sample_rate value
    %   of the class.
    %
    %   The sample rate can be set to a maximum of device.base_sample_rate and a minimum
    %   of device.base_sample_rate / 2^device.sample_rate_setting. For example a TMSi device
    %   that runs at 2048 Hz, and has a sample_rate_setting of 4, can be set to sample at a
    %   minimum of 128 Hz. 
    %
    %   Reference calculation is turned on by default. Reference calculation removes common
    %   distortion on all channels from the signal. For example 50 Hz. 
    %
    %   When sampling with a Sampler, the device has to be connected through the sampler, and
    %   not through the device object. Reason for this is that the sample rate and buffer size
    %   can only be set after connection is established and is lost as soon as the device is
    %   disconnected.
    %
    %SAMPLER Properties:
    %   library - The TMSi library.
    %   device - The device that is used as source.
    %   is_sampling - True, if currently sampling from device.
    %   is_impedance - True, if currently sampling in impedance mode.
    %   sample_rate - The sample rate in Hz.
    %   buffer_size - The buffer size used on the device (internal use).
    %   reference_calculation - True, if reference calculation is done.
    %   overflow_value - The default value for when a channel is in overflow.
    %   impedance_mode - True, if device is going to sample in impedance_mode.
    %
    %SAMPLER Methods:
    %   Sampler - Constructor of a sampler object.
    %   connect - Open a connection to device and set sampling settings.
    %   disconnect - Close connection to device.
    %   setImpedanceMode - Turn on/off to sample in impedance mode.
    %   setOverflowValue - Sets the overflow value.
    %   setBufferSize - Sets the buffer size used.
    %   setSampleRate - Sets the sample rate.
    %   setReferenceCalculation - Turn on/off the reference calculation.
    %   start - Start sampling from device.
    %   stop - Stop sampling from device.
    %   sample - Sample from device.
    %
    %SAMPLER Example:
    %   sampler = device.createSampler();
    %   
    %   sampler.setSampleRate(2048);
    %   
    %   sampler.connect();
    %   sampler.start();
    %   for i=1:10
    %       samples = sampler.sample();
    %   end
    %   sampler.stop();
    %   sampler.disconnect();

    properties (SetAccess = private)
        % The TMSi library.
        library

        % The device that is used as source.
        device

        % True, if currently sampling from device.
        is_sampling

        % True, if currently sampling in impedance mode.
        is_impedance

        % The sample rate in Hz.
        sample_rate

        % The buffer size used on the device (internal use).
        buffer_size

        % True, if reference calculation is done.
        reference_calculation

        % The default value for when a channel is in overflow.
        overflow_value

        % True, if device is going to sample in impedance_mode.
        impedance_mode
    end

    properties (Access = private)
        % A pre-allocated buffer for the samples
        sample_buffer

        % The size of sample_buffer in samples.
        sample_buffer_size

        % The size of sample_buffer in bytes.
        sample_buffer_size_bytes

        % A boolean object, that specifies which channels can be overflowed.
        channels_overflow_types
    end

    methods
        function obj = Sampler(library, device)
            %SAMPLER - Constructor for the Sampler class.
            %
            %   
            %   library - TMSi library object.
            %   device - TMSi device object.

            obj.library = library;
            obj.device = device;
            obj.is_sampling = false;
            obj.is_impedance = false;
            obj.sample_rate = device.base_sample_rate;
            obj.buffer_size = obj.sample_rate * device.num_channels * 30;
            obj.reference_calculation = true;
            obj.overflow_value = 0;
            obj.impedance_mode = false;
            
            obj.sample_buffer = [];
            obj.sample_buffer_size = 0;
            obj.sample_buffer_size_bytes = 0;
            obj.channels_overflow_types = [];
        end

        function connect(obj)
            %CONNECT - Establish a connection with the device.
            %
            %   Opens a connection to the TMSi device. It will also set the reference
            %   calculation, sample rate and buffer size.

            obj.device.connect();

            % Set default settings
            obj.setReferenceCalculation(obj.reference_calculation);
            obj.setSignalBuffer();
        end

        function disconnect(obj)
            %DISCONNECT - Breaks down the connection with the device.

            obj.device.disconnect();
        end

        function setImpedanceMode(obj, on)
            %SETIMPEDANCEMODE - Turn impedance mode measurements on/off.
            %
            %   Impedance mode cannot be changed during sampling. Turning impedance
            %   mode on causes the sample() method to sample impedance values instead
            %   of signals.
            %
            %   Can only be set while not sampling.
            %
            %   on - A boolean value stating if impedance mode should be on/off.

            if obj.is_sampling
                throw(MException('Sampler:setImpedanceMode', 'Can only set impedance mode while not sampling.'));
            end

            obj.impedance_mode = on;
        end

        function setOverflowValue(obj, value)
            %SETOVERFLOWVALUE - Set the value that channels that overflow are given.
            %
            %   When a signal is not connected, it will go in overflow. By default
            %   the value NaN is given to any sample from a channel that was in overflow.
            %
            %   Can only be set while not sampling.
            %
            %   value - The value that is set as overflow value. 

            obj.overflow_value = value;
        end

        function setBufferSize(obj, buffer_size)
            %SETBUFFERSIZE - Set the buffer size of the device.
            %
            %   Internal on the device a buffer is maintained for storage of samples, 
            %   until these are sampled. 
            %
            %   Can only be set while not sampling.
            %
            %   buffer_size - Size of the buffer used on the TMSi device.

            if obj.is_sampling
                throw(MException('Sampler:setBufferSize', 'Can only set buffer size while not sampling.'));
            end

            obj.buffer_size = buffer_size;

            if (~obj.buffer_size) 
                return
            end

            obj.setSignalBuffer();
        end

        function setSampleRate(obj, sample_rate)
            %SETSAMPLERATE - Set the sample rate of the device.
            %
            %   The sample rate can be set to a maximum of device.base_sample_rate and a minimum
            %   of device.base_sample_rate / 2^device.sample_rate_setting. For example a TMSi device
            %   that runs at 2048 Hz, and has a sample_rate_setting of 4, can be set to sample at a
            %   minimum of 128 Hz. When the device is connected, or started the sample rate is 
            %   automatically updated to a sample rate the device can support.
            %
            %   Can only be set while not sampling.
            %
            %   sample_rate - Frequency of sampling in Hz.

            if obj.is_sampling
                throw(MException('Sampler:setSampleRate', 'Can only set sample rate while not sampling.'));
            end

            obj.sample_rate = sample_rate;

            if (~obj.device.is_connected)
                return
            end

            obj.setSignalBuffer();
        end

        function setReferenceCalculation(obj, on)
            %SETREFERENCECALCULATION - Set the reference calculation on/off.
            %
            %   This will turn on/off the reference calculation inside the TMSi device.
            %   This will remove a common average of all active channels from all 
            %   channels. 
            %
            %   on - A boolean to turn reference calculation on/off.

            if obj.is_sampling
                throw(MException('Sampler:setReferenceCalculation', 'Can only set reference calculation while not sampling.'));
            end

            obj.reference_calculation = on;

            if (~obj.device.is_connected)
                return
            end

            successful = calllib(obj.library.alias, 'SetRefCalculation', obj.library.handle, obj.reference_calculation);
            if (~successful) 
                throw(MException('Sampler:setReferenceCalculation', 'Could not set reference calculation on/off.'));
            end
        end

        function start(obj, limit)
            %START - Start sampling of the device.
            %
            %   This function will start the sampling of the device. If impedance mode
            %   was set to true, the limit parameter will specify what the impedance 
            %   limit for the LEDs on the TMSi device are.
            %
            %   limit - The impedance limit for the LEDs. Accepted values are: 2, 5, 
            %       10, 20, 50, 100 and 200.

            if ~exist('limit', 'var')
                limit = 20;
            end

            if (obj.is_sampling)
                return
            end

            % Pre set somethings for sampling
            obj.channels_overflow_types = zeros(obj.device.num_channels, 1);
            for i_channel = 1:obj.device.num_channels
                obj.channels_overflow_types(i_channel) = ( ...
                    obj.device.channels{i_channel}.type == 1 | ...
                    obj.device.channels{i_channel}.type == 2 | ...
                    obj.device.channels{i_channel}.type == 3 ...
                );
            end

            % Start sampling
            successful = calllib(obj.library.alias, 'Start', obj.library.handle);
            if (~successful)
                throw(MException('Sampler:start', 'Could not start sampling.'));
            end

            obj.is_sampling = true;

            % Set measuring mode to impedance
            if obj.impedance_mode
                impedance_limit = 0;
                if limit == 2
                    impedance_limit = 0;
                elseif limit == 5
                    impedance_limit = 1;
                elseif limit == 10
                    impedance_limit = 2;
                elseif limit == 20
                    impedance_limit = 3;
                elseif limit == 50
                    impedance_limit = 4;
                elseif limit == 100
                    impedance_limit = 5;
                elseif limit == 200
                    impedance_limit = 6;
                else
                    obj.stop();
                    throw(MException('Sampler:startImpedanceMode', 'Invalid impedance limit specified.'));
                end

                successful = calllib(obj.library.alias, 'SetMeasuringMode', obj.library.handle, 3, impedance_limit);
                if (~successful)
                    obj.stop();
                    throw(MException('Sampler:startImpedanceMode', 'Could not set measuring mode to impedance.'));
                end

                obj.is_impedance = true;
            end
        end

        function stop(obj)
            %STOP - Stop sampling of device.
            %
            %   Stops sampling on device.

            % Set measuring mode to normal
            if obj.impedance_mode
                if ~obj.is_impedance
                    return
                end
                
                successful = calllib(obj.library.alias, 'SetMeasuringMode', obj.library.handle, 0, 0);
                if (~successful) 
                    throw(MException('Sampler:startImpedanceMode', 'Could not set measuring mode to normal.'));
                end
                
                obj.is_impedance = false;
            end

            if(~obj.is_sampling)
                return
            end

            % Stop sampling
            successful = calllib(obj.library.alias, 'Stop', obj.library.handle);
            if ~successful
                throw(MException('Sampler:stop', 'Could not start sampling.'));
            end

            obj.is_sampling = false;
        end

        function samples = sample(obj, blocking)
            %SAMPLE - Samples device for samples.
            %
            %   This function will sample from the TMSi device and return a matrix of
            %   num_channels x num_samples. 
            %
            %   In case of impedance mode, the returned matrix only has one sample if
            %   sampled fast enough.
            %
            %   By default this function blocks, until samples are found and are 
            %   returned. This behavior can be changed with the parameter blocking.
            %   If not blocking the function can return an empty matrix with no samples.
            %
            %   blocking - A boolean that states whether or not to block.
            
            if ~exist('blocking', 'var')
                blocking = true;
            end

            samples = [];

            % Check if we are already sampling.
            if ~obj.is_sampling
                return
            end

            % Retrieve samples from the library, and if we are blocking keep on 
            % doing so until we have atleast 1 sample.
            time_start = clock;
            num_bytes = calllib(obj.library.alias, 'GetSamples', obj.library.handle, obj.sample_buffer, obj.sample_buffer_size_bytes);
            while (blocking && num_bytes == 0)
                if (etime(clock, time_start) > 30)
                    throw(MException('Sampler:sample', 'Could not sample for >30 seconds.'));
                end
                num_bytes = calllib(obj.library.alias, 'GetSamples', obj.library.handle, obj.sample_buffer, obj.sample_buffer_size_bytes);
            end

            % Transform the samples.
            if num_bytes < 0
                throw(MException('Sampler:sample', 'Could not sample device.'));

            elseif num_bytes > 0
                % Samples are stored as a continuous stream of unsigned int (32 bits)
                % that are ordered per channel.
                %
                %   | Sample #1 Chan #1 | Sample #1 Chan #2 | ... | Sample #1 Chan #32 |
                %   | Sample #2 Chan #1 | Sample #2 Chan #2 | ... | Sample #2 Chan #32 |
                %   |                                         ...                      |
                %   | Sample #N Chan #1 | Sample #N Chan #2 | ... | Sample #N Chan #32 |
                
                num_samples = num_bytes / (obj.device.num_channels * 4);
                samples_raw = obj.sample_buffer.Value(1:(obj.device.num_channels * num_samples));
                samples_raw = reshape(samples_raw, obj.device.num_channels, num_samples);
                %disp(num_samples);

                if ~obj.impedance_mode
                    % In case of normal sampling, samples are constructured based on 
                    % the type of channel.
                    %
                    % If the overflow value (2^31) is detected on AUX, EXG and ..., 
                    % the value for that sample, at that channel is set to overflow_value.
                    %
                    % Else depending on the signedness of the channel the actual sample value
                    % is calculated as follows:
                    %   <actual sample value> = <(un)signed sample value> * <unit gain of channel>

                    overflows = samples_raw == 2147483648;
                    overflows = overflows & repmat(obj.channels_overflow_types, 1, size(overflows, 2));
                    
                    samples = zeros(size(samples_raw));
                    
                    for i_channel = 1:obj.device.num_channels
                        if obj.device.channels{i_channel}.format == 0
                            samples(i_channel, :) = double(samples_raw(i_channel, :)) * double(obj.device.channels{i_channel}.unit_gain);
                        elseif obj.device.channels{i_channel}.format == 1
                            samples(i_channel, :) = double(typecast(samples_raw(i_channel, :), 'int32')) * double(obj.device.channels{i_channel}.unit_gain);
                        else 
                            samples(i_channel, :) = 0;
                        end
                    end

                    samples(overflows) = obj.overflow_value;
                else
                    samples = samples_raw;
                    samples = double(samples);    
                end
             end
        end
    end

    methods (Access = private) 
        function setSignalBuffer(obj)
            %SETSIGNALBUFFER - Set signal buffer function in TMSi library.
            %
            %   This function will set the sample rate and buffer size in the TMSi 
            %   device. If this function is not called before starting sampling, the
            %   library will most likely generate a segmentation fault.
            
            sample_rate = libpointer('ulongPtr', obj.sample_rate * 1000);
            buffer_size = libpointer('ulongPtr', obj.buffer_size);
            successful = calllib(obj.library.alias, 'SetSignalBuffer', obj.library.handle, sample_rate, buffer_size);
            if (~successful)
                throw(MException('Sampler:setSignalBuffer', 'Could not set buffer size and/or sample rate.'));
            end
            obj.sample_rate = double(sample_rate.Value / 1000);
            obj.buffer_size = buffer_size.Value;

            obj.sample_buffer_size = obj.buffer_size;
            obj.sample_buffer_size_bytes = obj.sample_buffer_size * 4;
            obj.sample_buffer = libpointer('uint32Ptr', uint32(zeros(obj.sample_buffer_size, 1)));
        end
    end
end