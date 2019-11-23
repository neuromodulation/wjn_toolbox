function addresults( varargin )
% ADDRESULTS add row of items to results file
%
% Description:
%
% Usage:
%     ADDRESULTS( field1, field2, field3, ... )
%
% Arguments:
%
% Examples:
%
% See also:
%
% Cogent 2000 function.


global cogent;

for i = 1:nargin
   switch class( varargin{i} )
   case 'double'
   case 'char'
   otherwise
      error( 'cell must be string or numeric' );
   end
end

cogent.results.data{ length(cogent.results.data)+1 } = varargin;
