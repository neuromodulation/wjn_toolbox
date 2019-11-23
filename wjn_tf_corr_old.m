function nD = wjn_tf_corr(filename,x,cond,type)
% nD = wjn_tf_corr(filename,x,cond,type);
% 
% 
D=spm_eeg_load(filename);


if (~exist('type','var') || isempty(cond)) 
    type = 'permspearman';
end

switch type
    case 'permspearman'
        corrstring = '[nd(a,b,c,1),nd(a,b,c,2)] = mypermCorr(x,y,''spearman'',500);';
    case 'permpearson'
        corrstring = '[nd(a,b,c,1),nd(a,b,c,2)] = mypermCorr(x,y,''pearson'',500);';
    case 'spearman'
        corrstring = '[nd(a,b,c,1),nd(a,b,c,2)] = corr(x,y,''type'',''spearman'',''rows'',''pairwise'');';
    case 'pearson'
        corrstring = '[nd(a,b,c,1),nd(a,b,c,2)] = corr(x,y,''type'',''pearson'',''rows'',''pairwise'');';
end
        
        
if (~exist('cond','var') || isempty(cond)) 
    i = 1:D.ntrials;
    cond = unique(D.conditions(i))
    ncond=[];
    for a = 1:length(cond);
        ncond = [ncond cond{a} '_'];
    end
    ncond(end)=[];
    cond = ncond;
    if length(i) ~= length(x)
        error('If condition is not defined x must have the number of trials in D');
    end
    
elseif ischar(cond) || iscell(cond)
    i = ci(cond,D.conditions);
elseif isnumeric(cond);
    i = cond;
    cond = unique(D.conditions(i))
    ncond=[];
    for a = 1:length(cond);
        ncond = [ncond cond{a} '_'];
    end
    ncond(end)=[];
    cond = ncond;
end
if length(i) ~= length(x)
    error('If condition is defined x must have the number of condition trials in D');
end
dims = size(D);
dims(4) = 2;

nd = nan(dims);
nn = D.nchannels*D.nfrequencies*D.nsamples;
for a = 1:D.nchannels
    for b = 1:D.nfrequencies
        for c = 1:D.nsamples
            y=squeeze(D(a,b,c,i));
            eval(corrstring)
        end
    end
end
                



nD = clone(D,['rp' D.fname],dims);
nD = conditions(nD,1,['R-' cond]);
nD = conditions(nD,2,['P-' cond]);
nD(:,:,:,:) = nd(:,:,:,:);
save(nD)

