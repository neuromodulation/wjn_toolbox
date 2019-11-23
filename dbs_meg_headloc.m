function [alldewar, alldist, allsens, allfid] = dbs_meg_headloc(files) 

origsens  = [];
origfid   = [];
origdewar = [];
fixedsens = [];
fixedfid  = [];
fixeddewar = [];
for f = 1:numel(files)
    
    S = [];
    S.dataset = files{f};
    S.channels = {
        'HLC0011'
        'HLC0012'
        'HLC0013'
        'HLC0021'
        'HLC0022'
        'HLC0023'
        'HLC0031'
        'HLC0032'
        'HLC0033'
        };
    S.checkboundary = 0;
    S.saveorigheader = 1;
    S.mode = 'continuous';
    D = spm_eeg_convert(S);
    
    origsens =[origsens D.sensors('MEG')];
    origfid  =[origfid D.fiducials];
    origdewar = cat(3, origdewar, 0.01*D.origheader.hc.dewar');
    
    S = [];
    S.D = D;
    D = spm_eeg_fix_ctf_headloc(S);
    
    fixedsens = [fixedsens sensors(D, 'MEG')];
    fixedfid  = [fixedfid fiducials(D)];
    fixeddewar = cat(3, fixeddewar, 0.01*D.origheader.hc.dewar');
    
    delete(D);
end


%%
sens = spm_cat_struct(origsens, fixedsens);
fid  = spm_cat_struct(origfid, fixedfid);
dewar = cat(3, origdewar, fixeddewar);
%%
pnt = [];
for i = 1:numel(fid)
    pnt = cat(3, pnt, fid(i).fid.pnt);
end
%%
cont_fid  = permute(pnt, [3 1 2]);

dist = [
    squeeze(sqrt(sum((cont_fid(:, 1, :) - cont_fid(:, 2, :)).^2, 3)))';...
    squeeze(sqrt(sum((cont_fid(:, 2, :) - cont_fid(:, 3, :)).^2, 3)))';...
    squeeze(sqrt(sum((cont_fid(:, 3, :) - cont_fid(:, 1, :)).^2, 3)))' ];

rdist = 10*round(dist/10);
%%
valid = all(abs(dist - repmat(mode(rdist, 2), 1, size(dist, 2)))<10);

spm_figure('GetWin','Graphics');clf;
h = axes;
[asens afid] = ft_average_sens(sens(valid), 'fiducials', fid(valid), 'feedback', h);

%%
nf = numel(files);
alldewar = zeros(3, 3, nf);
alldist  = zeros(3, nf);
for i = 1:nf
    if ismember(nf + i, valid)
        allsens(i) = sens(nf + i);
        allfid(i)  = fid(nf + i);
        alldewar(:, :, i) = dewar(:, nf + i);
        alldist(:, i) = dist(:, nf + i);
    elseif valid(i)
        allsens(i) = sens(i);
        allfid(i)  = fid(i);
        alldewar(:, :, i) = dewar(:, :, i);
        alldist(:, i) = dist(:, i);
    else
        allsens(i) = asens;
        allfid(i)  = afid;
        alldewar(:, :, i) = mean(dewar(:, :, valid), 3);
        alldist(:, i) = mean(dist(:, valid), 2);
    end
end

%{
for f = 1:numel(files)
    
    S = [];
    S.dataset = files{f};
    S.channels = {
        'HLC0011'
        'HLC0012'
        'HLC0013'
        'HLC0021'
        'HLC0022'
        'HLC0023'
        'HLC0031'
        'HLC0032'
        'HLC0033'
        };
    S.checkboundary = 0;
    S.saveorigheader = 1;
    S.mode = 'continuous';
    D = spm_eeg_convert(S);    
    
    S = [];
    S.D = D;
    S.valid_fid = alldist(:, f);
    D = spm_eeg_fix_ctf_headloc(S);    
    
    delete(D);
end
%}