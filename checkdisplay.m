function message = checkdisplay( varargin )

global cogent;

buf = default_arg( [], varargin, 1 );

if ~isfield( cogent, 'display' )
   message = [ 'display not configured' ];
elseif ~isempty(buf)  &  ( buf < 0 | buf > cogent.display.number_of_buffers )
   message = 'invalid buffer'; 
else
   message = [];
end

