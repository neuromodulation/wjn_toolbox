function revertbackup(revertPath, backupPath, savePath, begDate)
%REVERTBACKUP revert backups
%
%  revertbackup(revertPath, backupPath, savePath), 'backupPath' is a path
%  to save the backups which are created by function 'backupfolder'.
%  revertbackup reverts all files under 'revertPath' under 'backupPath',
%  and saves newest version of every files. The 'savePath' is the path to
%  save the reverted files. 
%
%  revertbackup(..., begDate) only revert the backups later than begDate.
%  The backups earlier than begDate wil be ignored.
%  
% See also: backupfolder, getbackups

% Copyright: zhang@zhiqiang.org

if nargin <= 2, savePath = cd; end
if nargin <= 3, begDate = '1990-01-01'; end

% replace the '/'
backupPath = strrep(backupPath, '/', '\');
backupPath = strrep(backupPath, '\\', '\');
revertPath = strrep(revertPath, '/', '\');
revertPath = strrep(revertPath, '\\', '\');
savePath = strrep(savePath, '/', '\');
savePath = strrep(savePath, '\\', '\');

if ~isdir(backupPath)
    display(['''' backupPath ''' doesn''t exist']);
    return;
end

% 
if backupPath(end) ~= '\', backupPath(end+1) = '\'; end
if savePath(end) ~= '\', savePath(end+1) = '\'; end

lists = getbackups(revertPath, backupPath, begDate);
if isempty(lists)
    display(['No backups for ''' revertPath ...
        '''are found under ''' backupPath '''']);
end
for i = 1:numel(lists)
    syncfolder(lists{i}, savePath, 1);
end

