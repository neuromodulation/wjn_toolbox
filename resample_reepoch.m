function [Dn] = resample_reepoch(file,condition,fsample,nsample)
% [Dn] = resample_reepoch(file,condition,fsample,nsample)
clear conditions
cdir = cd;
D=spm_eeg_load(file);

S.D = fullfile(D.path,D.fname);
S.fsample_new = fsample;
S.prefix = 'd';
D=spm_eeg_downsample(S);


[path,ID,~]=fileparts(file);
file = fullfile(cdir,D.fname);
d=[];ttrials=[];n=0;
bt = badtrials(D,'(:)');
for a=1:D.ntrials;
    if ~bt(a)
        n = n+1;
        if strcmpi(D.conditions(a),condition)
            d = [d squeeze(D(:,:,n))] ;
            ttrials = [ttrials n];
        end
    end
end
dim = size(D);
ndim = dim; 
ndim(2) = nsample;
ndim(3) = floor(length(d)/nsample);
% Dn = clone(D,['re_' num2str(fsample) '_' D.fname],ndim,2);
Dn = clone(D,['re' D.fname],ndim,2);
n=1;
for a = 1:ndim(3);
    Dn(:,1:ndim(2),a) = d(:,n:n+ndim(2)-1);
    n = n+ndim(2);
end
try
    Dn = conditions(Dn,1:Dn.ntrials,condition);
catch
    warning('Could not write condition labels')
end
Dn.chanlabels
Dn.chantype
save(Dn);
cd(cdir);