function field = loadlog( filename )
% LOADLOG loads a text file and return an array of cell containing text field
%
% Description:
%     Loads a text file and returns an array of cell containing text field of each line.
%
% Usage:
%     field = LOAD_LOG( filename )
%     Fields can be accessed by 'field{row}{col}' e.g. 2nd line 5th word 'field{2}{5}.
%
% Arguments:
%     filename - name of text file
%
% Examples:
%     LOAD_LOG( 'test.dat' )
%
% See also:
%
% Cogent 2000 function.

fid = fopen( filename );
if fid == -1
    error( [ 'cannot open file ' filename ] );
end

text = fgetl( fid );
row = 1;

while ~isnumeric(text)
    field{row} = getfields(text);
    row = row + 1;
    text = fgetl( fid );
end

fclose( fid );