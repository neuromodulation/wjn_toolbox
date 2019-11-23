function folderdiff(p1, p2, syncdirect)
%folderdiff 
%
%  syncfolder(p1, p2, syncdirect), sync between p1 and p2. p1 and p2 are
%  two directories. The exact behavior depends on the third parameter
%  'syncdirect'
%
%   syncdirect = 0, p1 and p2 are synced two-ways, i.e. the newest file
%   will be the final one.
%
%   syncdirect = 1, p1 are synced to p2 (the change in p2 will not synced
%   to p1); 
%
%   syncdirect = 2, p1 are synced to p2, and the file in p2 but not in p1
%   will be deleted
%
%   syncdirect = -1, p2 are synced to p1; 
%
%   syncdirect = -2, p2 are synced to p1, and the file in p1 but not in p2
%   will be deleted
%
%  syncdirect is 0 by default.
%
%
% Copyright: zhang@zhiqiang.org, 2010

% the sync direct is two-way by default
if ~exist('syncdirect', 'var'), syncdirect = 0; end;
if ischar(syncdirect), syncdirect = str2double(syncdirect); end
tmpRecycle = recycle;
recycle on;
% replace the '/' and '\\'
p1 = strrep(p1, '/', '\');
p2 = strrep(p2, '/', '\');
p1 = strrep(p1, '\\', '\');
p2 = strrep(p2, '\\', '\');
% if p1 or p2 is not a directory, then make one
try
    if ~isdir(p1), display([p1 ' doesn''t exist']); end
    if ~isdir(p2), display([p2 ' doesn''t exist']); end
catch ME
    error([p1 ' or ' p2 ' is not a directory']);    
end

% add a '\' to the last of the path
if isdir(p1) && p1(end)~='\', p1 = [p1, '\']; end
if isdir(p2) && p2(end)~='\', p2 = [p2, '\']; end

% get the files and subdirectories, and sort them by alphabetically
files1 = sortstruct(dir(p1), 'name');
files2 = sortstruct(dir(p2), 'name');


%% compare the files and subdirectories one by one
nf1 = 1; nf2 = 1;
while nf1 <= numel(files1) || nf2 <= numel(files2)
    % deal with '.' and '..'
    if nf1 <= numel(files1) && ...
            (strcmpi(files1(nf1).name, '.') || strcmpi(files1(nf1).name, '..'))
        nf1 = nf1 + 1;
        continue;
    end
    if nf2 <= numel(files2) && ...
            (strcmpi(files2(nf2).name, '.') || strcmpi(files2(nf2).name, '..'))
        nf2 = nf2 + 1;
        continue;
    end
    
    % the same files or directories in p1 and p2
    if nf1 <= numel(files1) && nf2 <= numel(files2) && ...
            strcmpi(files1(nf1).name, files2(nf2).name)
        % the same directories, recursively syncfolder
        if files1(nf1).isdir
            syncfolder([p1, files1(nf1).name], [p2, files2(nf2).name], syncdirect)
        else % the same files, copy the newer file to old file
            if files1(nf1).datenum > files2(nf2).datenum + 1.0/24/60
                if syncdirect >= 0
                    display(['''' p1, files1(nf1).name ''' --> ''' ...
                        p2, files2(nf2).name '''']);                    
                    % copyfile([p1, files1(nf1).name], [p2, files2(nf2).name], 'f');
                end
            elseif files1(nf1).datenum < files2(nf2).datenum - 1.0/24/60
                if syncdirect <= 0
                    display(['''' p1, files1(nf1).name ''' <-- ''' ...
                        p2, files2(nf2).name '''']);                            
                    % copyfile([p2, files2(nf2).name], [p1, files1(nf1).name], 'f');            
                end
            end
        end
        nf1 = nf1 + 1;
        nf2 = nf2 + 1;
    % a file or directory in p1 and not in p2
    elseif nf1 <= numel(files1) && ...
            (nf2 > numel(files2) || strcmpc(files1(nf1).name, files2(nf2).name) < 0)
        if files1(nf1).isdir % is a dir
            if syncdirect >= 0 
                display(['''' p1, files1(nf1).name ''' --> ''' ...
                        p2, '''']);                     
                % mkdir([p2, files1(nf1).name]);
                % copyfile([p1, files1(nf1).name], [p2, files1(nf1).name], 'f');                
            elseif syncdirect <= -2 % this subdirectory will be deleted                
                display(['''' p1, files1(nf1).name '\'' is deleted']);
                % rmdir([p1, files1(nf1).name], 's');
            end
        else % is a file
            if syncdirect >= 0
                display(['''' p1, files1(nf1).name ''' --> ''' ...
                        p2,  '''']);                                
                % copyfile([p1, files1(nf1).name], p2, 'f');                
            elseif syncdirect <= -2 % this file will be deleted
                display(['''' p1, files1(nf1).name ''' is deleted']);
                % delete([p1, files1(nf1).name]);
            end
        end
        nf1 = nf1 + 1;
        
    % a file or diretory in p2 not in p1
    elseif nf2 <= numel(files2) && ...
            (nf1 > numel(files1) || strcmpc(files2(nf2).name, files1(nf1).name) < 0)
        
        if files2(nf2).isdir % is a dir
            if syncdirect <= 0
                display(['''' p1, ''' <-- ''' ...
                        p2, files2(nf2).name '''']);                   
                % mkdir([p1, files2(nf2).name]);
                % copyfile([p2, files2(nf2).name], [p1, files2(nf2).name], 'f');                  
            elseif syncdirect >= 2 % this subdirectory will be deleted
                display(['''' p2, files2(nf2).name '\'' is deleted']);                                
                % rmdir([p2, files2(nf2).name], 's');
            end
        else % is a file
            if syncdirect <= 0
                display(['''' p1 ''' <-- ''' ...
                        p2, files2(nf2).name '''']);   
                % copyfile([p2, files2(nf2).name], p1, 'f');                 
            elseif syncdirect >= 2 % this file will be deleted
                display(['''' p2, files2(nf2).name ''' is deleted']);                                
                % delete([p2, files2(nf2).name]);
            end
        end
        nf2 = nf2 + 1;
    end
end


recycle(tmpRecycle);

%% sort a struct
function [sortedStruct index] = sortstruct(aStruct, fieldName, direction)
% [sortedStruct index] = sortStruct(aStruct, fieldName, direction)
% sortStruct returns a sorted struct array, and can also return an index
% vector. The (one-dimensional) struct array (aStruct) is sorted based on
% the field specified by the string fieldName. The field must a single
% number or logical, or a char array (usually a simple string).
%
% direction is an optional argument to specify whether the struct array
% should be sorted in ascending or descending order. By default, the array
% will be sorted in ascending order. If supplied, direction must equal 1 to
% sort in ascending order or -1 to sort in descending order.

%% check inputs
if ~isstruct(aStruct)
    error('first input supplied is not a struct.')
end % if

if sum(size(aStruct)>1)>1 % if more than one non-singleton dimension
    error('I don''t want to sort your multidimensional struct array.')
end % if

if ~ischar(fieldName) || ~isfield(aStruct, fieldName)
    error('second input is not a valid fieldname.')
end % if

if nargin < 3
    direction = 1;
elseif ~isnumeric(direction) || numel(direction)>1 || ~ismember(direction, [-1 1])
    error('direction must equal 1 for ascending order or -1 for descending order.')
end % if

%% figure out the field's class, and find the sorted index vector
fieldEntry = aStruct(1).(fieldName);

if (isnumeric(fieldEntry) || islogical(fieldEntry)) && numel(fieldEntry) == 1 % if the field is a single number
    [dummy index] = sort([aStruct.(fieldName)]);
elseif ischar(fieldEntry) % if the field is char
    [dummy index] = sort({aStruct.(fieldName)});
else
    error('%s is not an appropriate field by which to sort.', fieldName)
end % if ~isempty

%% apply the index to the struct array
if direction == 1 % ascending sort
    sortedStruct = aStruct(index);
else % descending sort
    sortedStruct = aStruct(index(end:-1:1));
end