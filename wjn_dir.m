function dirs = wjn_dir(folder)


if ~exist('folder','var')
    folder = '.';
end

ndirs = dir(folder);

dirs = {ndirs(3:end).name};
dirs = dirs([ndirs(3:end).isdir])';
