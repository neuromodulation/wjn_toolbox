classdef Device < TMSi.HiddenHandle
    %DEVICE Class provides access to a single TMSi device.
    %
    %   When a device object is created a connection is opened to the TMSi device. Information
    %   about the connected TMSi device is retrieved and stored in this object. The connection
    %   is then closed.
    %
    %DEVICE Properties:
    %   library - The TMSi object.
    %   name - The name of the TMSi device.
    %   mode - Unknown
    %   serial - The serial of the device.
    %   num_channels - The number of channels on the TMSi device.
    %   num_exg - The number of EXG channels.
    %   num_aux - The number of AUX channels.
    %   hardware_version - The hardware version number.
    %   software_version - The software version number.
    %   max_channel_supported - The maximum number of channels (unused).
    %   base_sample_rate - The default sample rate in Hz (max).
    %   sample_rate_setting - How often the base_sample_rate can be divided.
    %   channels - Information about channels.
    %   is_connected - True, if there is an open connection to the device.
    %
    %DEVICE Methods:
    %   createSampler - Create a sampler object for this device.
    %   connect - Open a connection to the TMSi device.
    %   disconnect - Close the connection to the TMSi device.
    %   getUnit - Return a string representing the unit, and exponent.
    %
    %DEVICE Example:
    %   device = lib.getDevice(lib.devices{1});
    %
    %   if numel(device.channels) > 0
    %       disp(['Sample Rate: ' device.base_sample_rate]);
    %       disp(['Channel Name: ' device.channels{1}.name]);
    %       disp(['Unit: ' device.getUnit(device.channels{1}.unit_id, device.channels{1}.unit_exponent)]);
    %   end

    properties (SetAccess = private)
        % The TMSi object
        library

        % The name of the TMSi device.
        name

        % Unknown
        mode

        % The serial of the device.
        serial

        % The number of channels on the TMSi device.
        num_channels

        % The number of EXG channels.
        num_exg

        % The number of AUX channels.
        num_aux

        % The hardware version number.
        hardware_version

        % The software version number.
        software_version

        % The maximum number of channels (unused).
        max_channel_supported

        % The max/base sample rate (max).
        base_sample_rate

        %  How often the base_sample_rate can be divided.
        sample_rate_setting

        % Cell array of structures with information about individual channels.
        %
        %   Each cell contains a structure with the following elements:
        %       channels{i}.name - The name of the channel.
        %       channels{i}.type - The type of the channel (internal use).
        %       channels{i}.format - The output type of a channel (internal use).
        %       channels{i}.unit_gain - The unit gain of the channel (internal use).
        %       channels{i}.unit_offset - The unit offset of the channel (internal use).
        %       channels{i}.unit_id - The unit identified (internal use).
        %       channels{i}.unit_exponent - The unit exponent (internal use).
        %       channels{i}.port - n/a (internal use).
        %       channels{i}.port_name - n/a (internal use).
        %       channels{i}.serial_number - Serial number of TMSi device (internal use).
        channels

        % True, if there is an open connection to the device.
        is_connected
    end

    methods
        function obj = Device(library, name)
            %DEVICE - Constructor for device object.
            %
            %   It will retrieve information about the TMSi device named by <name>. It 
            %   will do this by connecting to the TMSi device requesting information and
            %   then closing the connection again.
            %   
            %   When the object is created the device is not connected and can be used
            %   by different instances of this object. But, only ONE device object can 
            %   connect to a TMSi device at any given moment.
            %
            %   library - TMSi library object.
            %   name - An identifier for the TMSi device used in the TMSi library.
            
            obj.library = library;
            obj.name = name;
            obj.mode = 4;
            obj.serial = 0;
            obj.num_channels = 0;
            obj.num_exg = 0;
            obj.num_aux = 0;
            obj.hardware_version = 0;
            obj.software_version = 0;
            obj.max_channel_supported = 0;
            obj.base_sample_rate = 0;
            obj.sample_rate_setting = 0;
            obj.channels = {};
            obj.is_connected = false;

            obj.init();
        end

        function sampler = createSampler(obj)
            %CREATESAMPLER - Create a Sampler object. 
            %   
            %   Creates a sampler object, that will be able to sample from this device.

            sampler = TMSi.Sampler(obj.library, obj);
            sampler.setSampleRate(obj.base_sample_rate);
        end

        function connect(obj)
            %CONNECT - Open a connection to a TMSi device.
            %
            %   Opens a connection to a TMSi device.

            if (obj.is_connected)
                return
            end

            % Connect device
            successful = calllib(obj.library.alias, 'Open', obj.library.handle, obj.name);
            if ~successful
                throw(MException('Device:connect', 'Could not open device.'));
            end

            % Bug in driver?!
            obj.getChannelInfo();

            obj.is_connected = true;
        end

        function disconnect(obj)
            %DISCONNECT - Closes the connection to a TMSi device.
            %   
            %   Closes a connection to a TMSi Device.

            if (~obj.is_connected)
                return
            end

            % Disonnect device
            successful = calllib(obj.library.alias, 'Close', obj.library.handle);
            if ~successful
                throw(MException('Device:disconnect', 'Could not close device.'));
            end

            obj.is_connected = false;
        end
        
        function unit = getUnit(obj, unit_id, unit_exp)
            %GETUNIT - Returns a string with unit given unit_id, and unit_exp.
            %
            %   This function returns a string given a unit identified number, and 
            %   an exponent. Known units are: V, %, b/m, bar, psi, mH2O, mmHg. Known
            %   exponents are ^-3, ^-6, ^-9.
            %   
            %   unit_id - An id that represents a known unit.
            %   unit_exp - The exponent.
            
            unit = '';
            switch unit_exp
                case -3
                    unit = 'm';
                case -6
                    unit = 'u';
                case -9
                    unit = 'n';
            end
            
            switch unit_id
                case 0
                    unit = '?';
                case 1
                    unit = [unit 'V'];
                case 2
                    unit = [unit '%'];
                case 3
                    unit = [unit 'b/m'];
                case 4
                    unit = [unit 'bar'];
                case 5
                    unit = [unit 'psi'];
                case 6
                    unit = [unit 'mH2O'];
                case 7
                    unit = [unit 'mmHg'];
            end
        end
    end

    methods (Access = private) 

        function init(obj)
            %INIT - Initializes the device object.
            %
            %   Retrieves front end info, and channel info of the TMSi device.

            obj.connect();
            obj.getFrontEndInfo();
            obj.getChannelInfo();
            obj.disconnect();
        end

        function getFrontEndInfo(obj)
            %GETFRONTENDINFO - Retrieve front end info from TMSi Device.
            %
            %   Retrieve front end info from TMSi Device.

            % Struct to retrieve frontend info
            frontend_info.NrOfChannels = 0;
            frontend_info.SampleRateSetting = 0;
            frontend_info.Mode = 0;
            frontend_info.maxRS232 = 0;
            frontend_info.Serial = 0;
            frontend_info.NrExg = 0;
            frontend_info.NrAux = 0;
            frontend_info.HwVersion = 0;
            frontend_info.SwVersion = 0;
            frontend_info.RecBufSize = 0;
            frontend_info.SendBufSize = 0;
            frontend_info.NrOfSwChannels = 0;
            frontend_info.BaseSf = 0;
            frontend_info.Power = 0;
            frontend_info.Check = 0;

            % Get frontend info
            frontend_info = libpointer('s_FRONTENDINFO', frontend_info);
            successful = calllib(obj.library.alias, 'GetFrontEndInfo', obj.library.handle, frontend_info);
            if (~successful)
                throw(MException('Device:getFrontEndInfo', 'Could not query frontend.'));
            end

            % Output
            obj.num_channels = double(frontend_info.Value.NrOfChannels);
            obj.mode = double(frontend_info.Value.Mode);
            obj.serial = double(frontend_info.Value.Serial);
            obj.num_exg = double(frontend_info.Value.NrExg);
            obj.num_aux = double(frontend_info.Value.NrAux);
            obj.hardware_version = double(frontend_info.Value.HwVersion);
            obj.software_version = double(frontend_info.Value.SwVersion);
            obj.max_channel_supported = double(frontend_info.Value.NrOfSwChannels);
            obj.base_sample_rate = double(frontend_info.Value.BaseSf);
            obj.sample_rate_setting = double(frontend_info.Value.SampleRateSetting);
        end

        function getChannelInfo(obj)
            %GETCHANNELINFO - Retrieve channel info from TMSi device.
            %
            %   Retrieve channel info from TMSi device.

            % Get channel information
            signal_format = calllib(obj.library.alias, 'GetSignalFormat', obj.library.handle, libpointer('string'));
            if (signal_format == 0)
                throw(MException('Device:getChannelInfo', 'Could not get channel information.'));
            end
            setdatatype(signal_format, 's_SIGNAL_FORMATPtr');

            % Retrieve channel information
            obj.channels = cell(signal_format.Value.Elements, 1);
            for i=0:(signal_format.Value.Elements - 1)
                ptr = signal_format + i;

                obj.channels{i + 1}.name = deblank(native2unicode(ptr.Value.Name));
                obj.channels{i + 1}.type = double(ptr.Value.Type);
                obj.channels{i + 1}.format = double(ptr.Value.Format);
                obj.channels{i + 1}.unit_gain = double(ptr.Value.UnitGain);
                obj.channels{i + 1}.unit_offset = double(ptr.Value.UnitOffSet);
                obj.channels{i + 1}.unit_id = double(ptr.Value.UnitId);
                obj.channels{i + 1}.unit_exponent = double(ptr.Value.UnitExponent);
                obj.channels{i + 1}.unit_name = obj.getUnit(double(ptr.Value.UnitId), double(ptr.Value.UnitExponent));
                obj.channels{i + 1}.port = double(ptr.Value.Port);
                obj.channels{i + 1}.port_name = deblank(native2unicode(ptr.Value.PortName));
                obj.channels{i + 1}.serial_number = ptr.Value.SerialNumber;
            end

            % Channel structure was malloc'd inside driver.
            successful = calllib(obj.library.alias, 'Free', signal_format);
            if (~successful)
                throw(MException('Device:getChannelInfo', 'Could not free memory.'));
            end
        end
    end
end