function backupfolder(p1, p2)
%copytofolder backup a folder under another folder.
%
%   backup(p1, p2) backup the folder p1 under p2. It will make a directory
%   named today's date under p2. The backup will backup all the modified
%   and newly added files but ignored the unchanged files.
%
% See also: getbackups, revertbackup
%
% Copyright: zhang@zhiqiang.org, 2010



% replace the '/'
p1 = strrep(p1, '/', '\');
p1 = strrep(p1, '\\', '\');
p2 = strrep(p2, '/', '\');
p2 = strrep(p2, '\\', '\');

% if p1 or p2 is not a directory, then make one
try
    if ~isdir(p1), error([p1 ' doesn''t exist or is not a directory']); end
    if ~isdir(p2)
        disp(['''' p2 ''' is created']);
        mkdir(p2); 
    end
catch ME
    error([p1 ' or ' p2 ' is not a directory']);    
end

% add a '\' to the last of the path
if isdir(p1) && p1(end)~='\', p1 = [p1, '\']; end
if isdir(p2) && p2(end)~='\', p2 = [p2, '\']; end

% get the last backup path, when there was no backup yet, use the current
% backup path.
% and the current backup path is the subfolder under p2, the directory name
% is today's date string with form 'yyyy-mm-dd'
backups = sortstruct(dir(p2), 'name');
curbackup = [p2, (datestr(clock, 'yyyy-mm-dd')), '\'];
if strcmp(backups(end), '.')
    lastbackuptime = 0;
else
    try
        lastbackuptime = datenum(backups(end).name);
    catch ME %#ok<NASGU>
        lastbackuptime = 0;
    end
end

copytofolder(p1, curbackup, lastbackuptime);


%% copy new files a folder
function copytofolder(p1, p2, dt)
%copytofolder backup folder
%
%  syncfolder(p1, p2, syncdirect), backup folder p1 to p3 with respect to
%  p2. When a file or subdirectories in p1 is newer than the file in the
%  coresponding position in p2, then it is backuped to p3.
%
% Copyright: zhang@zhiqiang.org, 2010

% replace the '/' and '\\'
p1 = strrep(p1, '/', '\');
p1 = strrep(p1, '\\', '\');
p2 = strrep(p2, '/', '\');
p2 = strrep(p2, '\\', '\');


% add a '\' to the last of the path
if p1(end)~='\', p1 = [p1, '\']; end
if p2(end)~='\', p2 = [p2, '\']; end

if ~isdir(p1), error([p1 ' doesn''t exist or is not a directory']); end

% get the files and subdirectories, and sort them by alphabetically
files1 = dir(p1);

% compare the files and subdirectories one by one
for nf1 = 1:numel(files1)
    % deal with '.' and '..'
    if nf1 <= numel(files1) && (strcmp(files1(nf1).name, '.') || strcmp(files1(nf1).name, '..'))
        continue;
    end
    
    if files1(nf1).isdir
        copytofolder([p1, files1(nf1).name], [p2, files1(nf1).name], dt)
    else % the same files, then when the file in p1 is newer, it is copied to p3
        if files1(nf1).datenum > dt && ...
                files1(nf1).datenum > modifiedtime([p2, files1(nf1).name]) + 1.0/24/60
            if ~isdir(p2), mkdir(p2); end
            display(['''', p1, files1(nf1).name, ''' is backuped']);            
            copyfile([p1, files1(nf1).name], [p2, files1(nf1).name], 'f');            
        end
    end
end


%% get the last modified time
function t = modifiedtime(f)
if ~exist(f, 'file')
    t = 0;
else
    t = dir(f);
    t = t(1).datenum;
end
 

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

