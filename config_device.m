function device = config_device( varargin )

%   CONFIG_DEVICE configures Direct Input device

global cogent;


% Check number of arguments
if nargin > 4
   error( 'wrong number of arguments' );
end

device.polling_flag = default_arg( 1,   varargin, 1 );
device.queuelength  = default_arg( 100, varargin, 2 );
device.resolution   = default_arg( 5,   varargin, 3 );
device.mode         = default_arg( 'exclusive', varargin, 4 );
device.time  = [];
device.id    = [];
device.value = [];

