function [files, sequence, root, details] =dbs_subjects(initials, on)

if isequal(initials(1:4), 'PLFP') || isequal(initials(1:4), 'DYST')
    [files, sequence, root, details] =dbs_subjects_berlin_v3(initials, on);
elseif isequal(initials(1:2), 'HB')
    [files, sequence, root, details] =dbs_subjects_hamburg(initials, on);
end


