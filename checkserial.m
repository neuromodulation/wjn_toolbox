function message = checkserial( i )

global cogent;

if ~isfield( cogent, 'serial' )
   message = [ 'COM' num2str(i) ' not configured' ];
elseif i < 1 | i > length(cogent.serial) 
   message = [ 'COM' num2str(i) ' not configured' ];
elseif isempty(cogent.serial{i})
   message = [ 'COM' num2str(i) ' not configured' ];
elseif ~isfield(cogent.serial{i},'hPort')
   message = 'COGENT not started';
else
   message = [];
end

