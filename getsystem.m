% script to automatically detect the pc used
function [mf,dbf,sys,d,spmf,leadf] = getsystem
% [mf,dbf,sys,d,spmf,leadf] = getsystem
%Desktop vs. Work vs. Laptop
%[mf,sys,dbf] = getsystem
% global matfolder
if  exist('C:\Users\rsmeg\','dir')
    dbf = 'C:\Users\rsmeg\Dropbox\Motorneuroscience\';
    mf = 'C:\Users\rsmeg\Dropbox\matlab\';
    spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'lead');
    d = 'C:\Users\rsmeg\Dropbox';
    sys = 'RSMEG';
elseif exist('C:\Users\lfp')
    dbf = 'C:\Users\wolfj\Dropbox\Motorneuroscience\';
    mf = 'C:\Users\wolfj\Dropbox\matlab\';
    spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'C:\Users\wolfj\Dropbox';
    sys = 'LENOVO_NEW';
elseif exist('/home/julian/Dropbox (Brain Modulation Lab)/wjn_toolbox','dir')
    dbf = '/home/julian/Dropbox (Brain Modulation Lab)/';
    mf = '/home/julian/Dropbox (Brain Modulation Lab)/wjn_toolbox';
    spmf = '/home/julian/Dropbox (Brain Modulation Lab)/wjn_toolbox/spm/';
    leadf = '';
    d = dbf;
    sys = 'pgh-server';
    
elseif exist('C:\dell_laptop','dir')
    dbf = 'C:\Roxanne\Arbeit\Projekte';
    mf = 'C:\Users\wjneuman\Dropbox\wjn_toolbox';
    d = 'C:\Users\wjneuman\Dropbox\';
    leadf = 'C:\Roxanne\Arbeit\Projekte\matlab_scripts\leaddbs';
    spmf = 'C:\Roxanne\Arbeit\Projekte\matlab_scripts\spm';
    sys = 'XPS15';
elseif    exist('C:\Users\B�rbara\','dir')
    dbf = 'C:\Users\B�rbara\OneDrive - Universidad Loyola Andaluc�a\Estancia Berl�n\WORK\EEG_dataset\';
    mf = 'C:\Users\B�rbara\Dropbox (Personal)\wjn_toolbox';
    d = 'C:\Users\B�rbara\OneDrive - Universidad Loyola Andaluc�a\Estancia Berl�n\WORK';
    leadf = '';
    spmf = 'C:\Users\B�rbara\OneDrive - Universidad Loyola Andaluc�a\Estancia Berl�n\WORK\EEG_ANALYSIS\spm';
    sys = 'Barbara Laptop';
    
elseif   exist('E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\','dir')
        dbf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\';
        mf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\wjn_toolbox';
        d = 'E:\Roxanne\OneDrive';
        leadf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\leaddbs';
        spmf = 'E:\Roxanne\OneDrive\Arbeit\Projekte\matlab_scripts\spm';
        sys = 'Roxanne Work';
elseif exist('E:\Dropbox (Personal)\matlab\','dir') 
    dbf = 'E:\Dropbox (Personal)\Motorneuroscience\';
    mf = 'E:\Dropbox (Personal)\matlab\';
%     spmf = fullfile('C:\','spm');
    spmf= fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'E:\Dropbox (Personal)\';
    sys = 'Desktop';
elseif exist('/home/agh14/julian','dir')
    dbf = '/n/scratch2/agh14/julian';
    mf = '/home/agh14/wjn_toolbox';
    spmf = '/home/agh14/spm';
    leadf = '/home/agh14/lead_dbs';
    d = '/n/scratch2/agh14/julian';
    sys = 'Harvard';

elseif exist('C:\Users\movdis\Dropbox (Personal)\matlab\','dir')
    dbf = 'C:\Users\movdis\Dropbox (Personal)\Motorneuroscience\';
    mf = 'C:\Users\movdis\Dropbox (Personal)\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'C:\Users\movdis\Dropbox (Personal)\';
    
    sys = 'Laptop';
elseif exist('C:\Users\wolfj\Dropbox (Personal)\matlab\','dir')
    dbf = 'C:\Users\wolfj\Dropbox (Personal)\Motorneuroscience\';
    mf = 'C:\Users\wolfj\Dropbox (Personal)\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    d = 'C:\Users\wolfj\Dropbox (Personal)\';
    
    sys = 'Thinkpad';
    elseif exist('D:\Users\movdis\Dropbox (Personal)\matlab\','dir')
    dbf = 'D:\Users\movdis\Dropbox (Personal)\Motorneuroscience\';
    
    mf = 'D:\Users\movdis\Dropbox (Personal)\matlab\';
        spmf = fullfile(mf,'spm12');
    leadf = fullfile(mf,'leaddbs');
    sys = 'Presentation';


else
    mf = 'C:\wjn_toolbox';
end
    