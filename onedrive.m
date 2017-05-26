function [odm,odr] = onedrive;

if exist('C:\Users\User\OneDrive\Motorneuroscience\','dir')
    odm = 'C:\Users\User\OneDrive\Motorneuroscience';
    odr = 'C:\Users\User\OneDrive\';
else
    error('This is system is not yet in the script.')
end