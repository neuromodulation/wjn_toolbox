classdef Library < TMSi.HiddenHandle
    %LIBRARY Class provides access to the TMSi driver and its devices associated with it.
    %
    %   This class is build around the TMSi PC Driver, and requires TMSiSDK.dll to be 
    %   present on the system (either in path or directory).
    %
    %LIBRARY Properties:
    %   handle - A handle for the TMSi library, used in callib functions.
    %   alias - An alias for the TMSi library, used in callib functions.
    %   revision - A revision text of the TMSi library.
    %   connection_type - Type of connection that is used to connect device with.
    %   devices - A cell array of device names that are connected.
    %   is_loaded - Is true when library is loaded.
    %
    %LIBRARY Methods:
    %   Library - Constructor for the Library class. 
    %   getDevice - Create a device object connected to the device name.
    %   getFirstDevice - Create a device object of the first connected device.
    %   refreshDevices - Returns a list of devices connected via the specific type of connection.
    %   destroy - Clean up the TMSi library.
    %
    %LIBRARY Example:
    %   lib = TMSi.Library('usb');
    %
    %   lib.refreshDevices();
    %   if numel(lib.devices) > 0
    %       device = lib.getDevice(lib.devices{1});
    %       % Do something with device
    %   end
    %
    %   lib.destroy();
    
    properties (SetAccess = private)
        % A handle for the TMSi library, used in callib functions.
        handle
        
        % An alias for the TMSi library, used in callib functions.
        alias
        
        % A revision text of the TMSi library.
        revision
        
        % Type of connection that is used to connect device with.
        % Is one the following values: 'usb', 'bluetooth', 'network', 'wifi', 'fiber'.
        connection_type

        % A cell array of device names that are connected.
        devices

        % Is true when library is loaded.
        is_loaded
    end

    methods
        function obj = Library(connection_type)
            %LIBRARY - Constructor for the Library class. 
            %   It will open the TMSiSDK.dll and then find devices connected.
            %
            %   connection_type - Type of connection that devices are connected with. 
            %       Can be 'usb', 'bluetooth', 'network', 'wifi', 'fiber'

            obj.handle = 0;
            obj.alias = 'TMSiSDK';
            obj.revision = '';
            obj.connection_type = lower(connection_type);
            obj.devices = {};
            obj.is_loaded = false;

            obj.init();
            obj.refreshDevices();
        end
    
        function device = getDevice(obj, name)
            %GETDEVICE - Create a device object connected to the device name.
            %   
            %   name - (char) Device name.
            
            device = TMSi.Device(obj, name);
        end

        function device = getFirstDevice(obj) 
            %GETFIRSTDEVICE - Create a device object of the first connected device.

            if numel(obj.devices) <= 0
                throw(MException('TMSi:getFirstDevice', 'No device found.'));
            end

            device = TMSi.Device(obj, obj.devices{1});
        end
        
        function device_list = refreshDevices(obj) 
            %REFRESHDEVICES - Returns a list of devices connected via the specific type of connection.

            device_list = {};

            % Get list of devices connected
            num_devices = libpointer('int32Ptr', 0);
            frontend_ids = calllib(obj.alias, 'GetDeviceList', obj.handle, num_devices);
            setdatatype(frontend_ids, 'stringPtrPtr');

            % If there are no devices connected
            if num_devices.Value == 0
                return
            end
            
            obj.devices = frontend_ids.Value;
            
            % Free device list
            calllib(obj.alias, 'FreeDeviceList', obj.handle, num_devices.Value, frontend_ids);

            device_list = obj.devices;
        end

        function destroy(obj)
            %DESTROY - Clean up the TMSi library.
            
            if (~obj.is_loaded)
                return
            end
            
            error_code = calllib(obj.alias, 'LibraryExit', obj.handle);
            
            if (error_code ~= 0)
                throw(MException('TMSi:destroy', 'Could not destroy TMSi library.'));
            end

            obj.is_loaded = false;
        end
    end

    methods (Access = private) 
        function init(obj)
            %INIT - Initialize the TMSi library 

            % If library is already loaded, do not load again.
            if (obj.is_loaded)
                return
            end

            % Check if the dll is loaded, else load it.
            if ~libisloaded(obj.alias)
                switch computer
                    case 'PCWIN'
                        loadlibrary('TMSiSDK.dll', @TMSi.TMSiHeader32);
                    case 'PCWIN64'
                        loadlibrary('TMSiSDK.dll', @TMSi.TMSiHeader64);
                end
            end

            % Check the connection type if it is allowed.
            if strcmp('fiber', obj.connection_type)
                type_id = 1;
            elseif strcmp('bluetooth', obj.connection_type)
                type_id = 2;
            elseif strcmp('usb', obj.connection_type)
                type_id = 3;
            elseif strcmp('wifi', obj.connection_type)
                type_id = 4;
            elseif strcmp('network', obj.connection_type)
                type_id = 5;
            else
                throw(MException('TMSi:init', 'Connection type invalid.'));
            end

            % Initialize the dll.
            error_code = libpointer('int32Ptr', 0);
            obj.handle = calllib(obj.alias, 'LibraryInit', type_id, error_code);
            
            if (error_code.Value ~= 0)
                throw(MException('TMSi:init', 'Could not init TMSi library.'));
            end
            
            % Get revision of the dll.
            obj.revision = calllib(obj.alias, 'GetRevision', obj.handle);

            obj.is_loaded = true;
        end

    end 
end