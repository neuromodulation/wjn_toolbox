function folders=find_folders(sdir)

if ~exist('sdir','var')
    sdir = cd;
end
folders = dir(sdir);
folders(ismember( {folders(:).name}, {'.', '..'}))=[];
folders = {folders([folders.isdir]).name};

cdir = cd;
for a = 1:length(folders)
    folders{a} = [sdir filesep folders{a}];
end

if ~isempty(folders)

    n=0;
    outdirs = folders;
    while 1
        n=n+1;
        cn = numel(unique(outdirs));
        outdirs = [outdirs find_folders(outdirs{n})];
        cl = numel(unique(outdirs));
        if n==cl
            break
        end
    end

    folders = outdirs;
end

    


