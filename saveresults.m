function saveresults

global cogent;

fid = fopen( cogent.results.filename, 'w' );
if fid == -1
   error( [ 'cannot open file ', cogent.results.filename ] );
end

for i = 1 : length(cogent.results.data)
   row = cogent.results.data{i};
   for j = 1 : length(row)
      cel = row{j};
      switch class(cel)
      case 'double'
         fprintf( fid, '%d\t', cel );
      case 'char'
         fprintf( fid, '''%s''\t', cel );
      otherwise
         fclose( fid );
         error( [ 'cannot write cell of type ' class(cel) ' to results file' ] );
      end
   end
   fprintf( fid, '\n' );
end

fclose( fid );

         
      