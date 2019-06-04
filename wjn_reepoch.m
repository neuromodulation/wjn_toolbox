function nD=wjn_reepoch(filename,nsamples,cond)

    

D=wjn_sl(filename);
nl = numel(D(1,:,:));
t = linspace(0,nl./D.fsample,nl);
for a =1:D.nchannels

    td=D(a,:,:);
    td=td(:);
       n=0;
    for b =1:nsamples:nl


        try
            n=n+1;
            
            nd(a,:,n) = td(b:b+nsamples-1);
            to(n) = t(b);
        catch
            warning([num2str(nl-b) ' samples cut off!'])
        end
    end
end

if length(size(nd))==2
    dim = [size(nd) 1];
else
    dim = size(nd);
end

nD = clone(D,['r' D.fname],dim);
nD = trialonset(nD,1:nD.ntrials,to);
nD(:,:,:) = nd;
nD = conditions(nD,'(:)',cond);
save(nD)
%     clear nd
