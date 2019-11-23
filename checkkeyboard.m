function message = checkkeyboard

global cogent;

if ~isfield(cogent,'keyboard')
   message = 'keyboard not configured';
else
   message = [];
end

