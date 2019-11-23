function message = checkmouse

global cogent;

if ~isfield( cogent, 'mouse' )
   message = [ 'mouse not configured' ];
elseif ~isfield( cogent.mouse, 'hDevice' )
    message = 'COGENT not started';  
else
   message = [];
end

