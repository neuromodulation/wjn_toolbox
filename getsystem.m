% script to automatically detect the pc used
function [mf,dbf,sys,d,spmf,leadf] = getsystem
% [mf,dbf,sys,d,spmf,leadf] = getsystem
%Desktop vs. Work vs. Laptop
%[mf,sys,dbf] = getsystem
% global matfolder
if exist('E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\','dir')
    dbf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\';
    mf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\wjn_toolbox';
    d = 'E:\Roxanne\OneDrive';
    leadf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\leaddbs';
    spmf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\spm12';
    sys = 'Roxanne Work';
elseif exist('E:\Dropbox\matlab\','dir') 
    dbf = 'E:\Dropbox\Motorneuroscience\';
    mf = 'E:\Dropbox\matlab\';
    spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'E:\Dropbox\';
    sys = 'Desktop';
elseif exist('/home/agh14/julian','dir')
    dbf = '/n/scratch2/agh14/julian';
    mf = '/home/agh14/wjn_toolbox';
    spmf = '/home/agh14/spm12';
    leadf = '/home/agh14/lead_dbs';
    d = '/n/scratch2/agh14/julian';
    sys = 'Harvard';
elseif exist('D:\Dropbox\matlab\','dir') 
    dbf = 'D:\Dropbox\Motorneuroscience\';
    mf = 'D:\Dropbox\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'D:\Dropbox\';
    sys = 'Desktop';
elseif exist('C:\Users\movdis\Dropbox\matlab\','dir')
    dbf = 'C:\Users\movdis\Dropbox\Motorneuroscience\';
    mf = 'C:\Users\movdis\Dropbox\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'C:\Users\movdis\Dropbox\';
    
    sys = 'Laptop';
elseif exist('C:\Users\User\Dropbox\matlab\','dir')
    dbf = 'C:\Users\User\Dropbox\Motorneuroscience\';
    mf = 'C:\Users\User\Dropbox\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'C:\Users\User\Dropbox\';
    
    sys = 'Thinkpad';
    elseif exist('D:\Users\movdis\Dropbox\matlab\','dir')
    dbf = 'D:\Users\movdis\Dropbox\Motorneuroscience\';
    
    mf = 'D:\Users\movdis\Dropbox\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    sys = 'Presentation';
elseif exist('C:\Dropbox\matlab\','dir')
    dbf = 'C:\Dropbox\Motorneuroscience\';
    mf = 'C:\Dropbox\matlab\';
    d = 'C:\Dropbox\';
    leadf = fullfile(mf,'leaddbs');
    spmf = fullfile(mf,'spm12');
    sys = 'XPS15';

else
    sys='unknown';
end
    