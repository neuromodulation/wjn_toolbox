function ndir = dirfind(string)

if ~exist('string','var') || isempty(string)
    string = '*';
end

x = dir(string);
n=0;
for a = 1:numel(x)
    if x(a).isdir  && ~strcmp(x(a).name,'.') && ~strcmp(x(a).name,'..') 
        n=n+1;
        ndir{n} = x(a).name;
    end
end