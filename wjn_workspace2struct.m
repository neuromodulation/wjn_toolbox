function str = wjn_workspace2struct(filename)


if exist('filename','var')
    s =1;
else
    s=0;
    filename = 'temp';
end

save(filename)

str = load(filename);

if ~s
    delete(filename)
end


