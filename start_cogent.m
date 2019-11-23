function start_cogent
% START_COGENT initialises Matlab for running Cogent 2000 commands.
%
% Description:
%	  Start initialise Malab for running Cogent 2000.	Call this after devices have been configued. 
%
% Usage:
%	  START_COGENT
%
% Arguments:
%	  NONE
%
% Examples:
%
% See also:
%	  STOP_COGENT, TIME, CONFIG_DATA, CONFIG_KEYBOARD, CONFIG_PARALLEL, CONFIG_SOUND, CONFIG_DEVICE,
%	  CONFIG_LOG, CONFIG_RESULTS, CONFIG_DISPLAY  CONFIG_MOUSE, CONFIG_SERIAL
%
% Cogent 2000 function.

global cogent;
cgloadlib; % added 14/03/2003. EF. (see line 64 also)
cogent.version = '1.25'; % updated to v1.25 14/04/03

cogstd( 'soutstr', [ 'Cogent 2000 Version ' num2str(cogent.version) char(10) ] )
cogstd( 'svers' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set process priority to high
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CogProcess( 'version' );
cogent.priority.class = CogProcess( 'enumpriorities' );
cogent.priority.old = CogProcess( 'getpriority' );
CogProcess( 'setpriority', cogent.priority.class.high );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise parallel ports
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4-4-2002 "cogport" obsolete
% Replaced by "inportb" & outportb" which need no initialisation
%if isfield( cogent, 'lpt' )
%	cogport( 'version' );
%	cogport( 'initialise' );
%	cogent.lpt = cogport( 'getlpts' );
%end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise log file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cogent,'log') & isfield(cogent.log,'filename')
	cogstd( 'sLogFil', cogent.log.filename );
end
cogent.log.time=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'display' )
	
	% Clear screen to background colour
	% cgloadlib; % removed 14/03/2003. EF. This comamnd is now run unconditionally (see line 22)
	cgopen( cogent.display.res, cogent.display.nbpp, 0, cogent.display.mode );
	bg = cogent.display.bg;
	fg = cogent.display.fg;
%	cgpencol( bg(1), bg(2), bg(3) ); % Add palette mode 27-3-01
	if cogent.display.nbpp~=8
		cgpencol( bg(1), bg(2), bg(3) );
	else
		cgpencol( bg(1) );
	end
	cgrect;
	cgflip;
%	cgpencol( fg(1), fg(2), fg(3) ); % Add palette mode 27-3-01
	if cogent.display.nbpp~=8
		cgpencol( fg(1), fg(2), fg(3) );
	else
		cgpencol( fg(1) );
	end
	
	% Create offscreen buffers
	for i=1:cogent.display.number_of_buffers
%		cgmakesprite( i, cogent.display.size(1), cogent.display.size(2), bg(1), bg(2), bg(3) ); % Add palette mode 27-3-01
		if cogent.display.nbpp~=8
			cgmakesprite( i, cogent.display.size(1), cogent.display.size(2), bg(1), bg(2), bg(3) );
		else
			cgmakesprite( i, cogent.display.size(1), cogent.display.size(2), bg(1) );
		end % if
	end % for
	
	% Setup drawing parameters
%	cgpencol( cogent.display.fg(1), cogent.display.fg(2), cogent.display.fg(3) ); % Add palette mode 27-3-01
	if cogent.display.nbpp~=8
		cgpencol( cogent.display.fg(1), cogent.display.fg(2), cogent.display.fg(3) );
	else
		cgpencol( cogent.display.fg(1) );
	end
	cgfont( cogent.display.font, cogent.display.fontsize );
	
	if isfield( cogent.display, 'scale' )
		cgscale( cogent.display.scale );
	end
	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise sound
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'sound' )
	cogcapture( 'Version' );
	cogcapture( 'Initialise' );
	cogsound( 'Version' );
	cogsound( 'Initialise', cogent.sound.nbits, cogent.sound.frequency, cogent.sound.nchannels );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load and initialise DirectInput if required
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(cogent,'keyboard') | isfield(cogent,'mouse')
	CogInput( 'Version' );
	CogInput( 'Initialise' );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'keyboard' )
	hDevice = CogInput( 'Create', 'keyboard', cogent.keyboard.mode, cogent.keyboard.queuelength );
	cogent.keyboard.hDevice = hDevice;
	cogent.keyboard.map = CogInput( 'GetMap', hDevice );
	CogInput( 'Acquire', hDevice );
	if ( cogent.keyboard.polling_flag )
		CogInput( 'StartPolling', hDevice, cogent.keyboard.resolution );
	end	
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise mouse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'mouse' )
	cogent.mouse.hDevice = CogInput( 'Create', 'mouse', cogent.mouse.mode );
	cogent.mouse.map = CogInput( 'GetMap', cogent.mouse.hDevice );
	CogInput( 'Acquire', cogent.mouse.hDevice );
	if ( cogent.mouse.polling_flag )
		CogInput( 'StartPolling', cogent.mouse.hDevice, cogent.mouse.resolution );
	end	
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise serial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'serial' )
	cogserial( 'version' );
	for i = 1 : length(cogent.serial)
		port = cogent.serial{i};
		if ~isempty(port)
			port.hPort = cogserial( 'open', port.name );
			
			attr.Baud = port.baudrate;
			attr.Parity = port.parity;
			attr.StopBits = port.stopbits;
			attr.ByteSize = port.bytesize;
			cogserial( 'setattr', port.hPort, attr );
			cogserial( 'record', port.hPort, 200000 );
			
			cogent.serial{i} = port;
		end
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise National Instruments DAQ DIO24
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield( cogent, 'dio24' )
	cogdio24( 'version' );
	cogdio24( 'initialise', cogent.dio24.deviceno );
	for i=1:length(cogent.dio24.input)
		if ~isempty( cogent.dio24.input{i} )
			cogdio24( 'config', i, 0 );
			cogdio24( 'start',  i, cogent.dio24.interval, 1000 );
		end
	end
end

% Set timer to 0
cogstd( 'sgettime', 0 );

logstring( 'COGENT START' );
