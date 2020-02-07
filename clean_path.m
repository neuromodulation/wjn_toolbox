function pth = clean_path(new_pth)

cpth = stringsplit(path,';');

matpath = ci('R201',cpth);
pth = [];
for a = 1:length(matpath)
    pth = [pth cpth{matpath(a)} ';'];
end

if exist('new_pth','var')
    if ischar(new_pth)
        new_pth = {new_pth};
    end
    for a = 1:length(new_pth)
        pth = [new_pth{a} pth];
    end
end

        