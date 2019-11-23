function files = wjn_nii_sort_files(str,del)

files = ffind(str);

if ~exist('del','var')
    del = '_';
end

for a = 1:length(files)
    cstr = stringsplit(files{a},del);
    
    cstr = cstr{end};
    if strcmp(cstr(end-3:end),'.nii')
        cstr = cstr(1:end-4);
    end
    
    cn(a) = str2num(cstr);    
end

[~,i]=sort(cn);

files = files(i);

