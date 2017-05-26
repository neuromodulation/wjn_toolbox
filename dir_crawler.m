function varargout = dir_crawler(varargin)
%crawls through a directory tree and returns files,
%
%[files, dirs ] = dir_crawler(master_dir, regexp_search_params )
%where regexp_search_params are arguments used for regexp
%
%examples
% show all sub- and files therein: dir_crawler
% collect all files therein: [files] = dir_crawler
% collect all files from superdirectory .. containing and files with extension .fig [files] = dir_crawler( '..', '\.fig$' )
% collect all dirs and files from superdirectory .. matching 'test' [files, dirs] = dir_crawler( '..', 'test' )


if numel( varargin ) == 0 | ~isdir( varargin{1} )
    varargin = [pwd, varargin];
end
N = 1E5;
[dirs, files] = deal( repmat( {''}, N, 1) );
[dirs(1), search_params] = deal( varargin(1), varargin(2:end) );
str = sprintf( 'searching %s', varargin{1} );
n = length(str);
fprintf( str );
h.dirs = 1;
h.files = 0;
for i=1:N
    if i>h.dirs
        break
    end
    str = dirs{i};
    fprintf( sprintf( '%s%%s', repmat( '\b', 1, n ) ), str );
    n = length(str);
    [dirs_, files_] = get_dirs_files( str );
    dirs( h.dirs+[1:numel(dirs_)] ) = dirs_;
    files(h.files+[1:numel(files_)]) = files_;
    h.dirs = h.dirs+numel(dirs_);
    h.files = h.files+numel(files_);
    if h.files>N || h.dirs > N
        fprintf( '\n' );
        warning( 'number of iterations %i > %i', max( [h.files, h.dirs] ), N );
        break;
    end
end
fprintf( '\ndone\n' );
%%
for i=1:numel(search_params)
    good = ~cellfun( 'isempty', regexp(  files, search_params{i} ) );
    files = files(good);
    if nargout > 1
        good = ~cellfun( 'isempty', regexp(  dirs, search_params{i} ) );
        dirs = cellstr(dirs(good));
    end
end
if nargout == 0
    disp( 'files:' );
    disp( files );
elseif nargout == 1
    varargout = {files};
else
    varargout = {files, dirs};
end

function [dirs, files] = get_dirs_files( curr_dir )
tmp = dir( curr_dir );
[dirs, files] = deal( [] );
if ~isempty( tmp )
    str = char( tmp.name );
    tmp = tmp(str(:,1) ~= '.' );
    tmp1 = tmp( [tmp.isdir] );
    tmp2 = tmp( ~[tmp.isdir] );
    str = {strcat( curr_dir, filesep)};
    dirs = strcat( str, {tmp1.name} );
    files = strcat( str, {tmp2.name} );
end
