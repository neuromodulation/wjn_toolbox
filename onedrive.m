function [odm,odr] = onedrive;

if exist('C:\Users\User\Dropbox (Personal)\OneDrive\','dir')
    odm = 'C:\Users\User\Dropbox (Personal)\OneDrive\';
    odr = 'C:\Users\User\Dropbox (Personal)\OneDrive\';
else
    error('This is system is not yet in the script.')
end