function [p,pp,np]=wjn_tf_cluster_corrected_correlation(ctf,y,nclusters)

ni= 500;
nsub =  length(y);
dummy = nan([size(ctf,2),size(ctf,3)]);


ix = [1:nsub]';
rix = randi(nsub,[nsub ni]);
nix = [ix rix];
rsum = [];
for a = 1:nclusters
    pp(a,:,:)=dummy;
end
for a = 1:ni+1
    [r,p] = corr(ctf(:,:),y(nix(:,a)),'rows','pairwise','type','spearman');
    clear idx
    rsum = [];
    nir = dummy;
    pir = dummy;
    nir(:) = r(:);
    pir(:) = p(:);
    cc_p=bwconncomp(pir<=.05&nir>0,4);
    cc_n=bwconncomp(pir<=.05&nir<0,4);
    idx = [cc_p.PixelIdxList , cc_n.PixelIdxList];
        for b = 1:length(idx)
            rsum(b) = sum(abs(nir(idx{b})));
        end

        for b = 1:nclusters
            if length(rsum)>=b
                [m,i]=nanmax(rsum);
                rsum(i)= nan;
                msum(a,b) = m;
                if a==1
                    pp(b,:,:)=dummy;
                    pp(b,idx{i}) = 1;
                end
            else
                if a==1
                    pp(b,:,:) = dummy;
                end
                msum(a,b) = 0;
            end
        end
        disp([num2str(a-1) '/' num2str(ni) ' permutations run'])
end

% pp =[nclusters size(ctf,2) size(ctf,3)];;
for a = 1:nclusters
    [s,i]=sort(msum(:,a));
    np(a) = 1-(find(s==msum(1),1,'last')./ni);
    pp(a,:,:) = pp(a,:,:).*(np(a)<=0.05);
end
pp=squeeze(pp);




    