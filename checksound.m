function message = checksound( bufnum )

global cogent;

if ~isfield( cogent, 'sound' )
   message = 'sound not configured';
elseif bufnum > length(cogent.sound.buffer)  |  bufnum < 1
   message = 'invalid sound buffer';
elseif cogent.sound.buffer(bufnum) == 0 
   error( [ 'sound buffer ' num2str(bufnum) ' not prepared' ] );
else
   message = [];
end

