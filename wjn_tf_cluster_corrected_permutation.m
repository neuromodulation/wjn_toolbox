function [p,pp]=wjn_tf_cluster_corrected_permutation(ctf,nclusters,type)
keep dtf D ctf nclusters type
ni= 500;
ctf = squeeze(ctf);
nsub =  size(ctf,1);
dummy = nan([size(ctf,2),size(ctf,3)]);

if ~exist('type','var')
    type = 'signrank';
end

ix = [1:nsub]';
rix = randi(nsub,[nsub ni]);
nix = [ix rix];
rsum = [];
si = [1 -1];
for a = 1:nclusters
    pp(a,:,:)=dummy;
end
for a = 1:ni+1
    if a==1
        ttf = ctf;
    else
        for b=1:nsub
            ttf(b,:,:) = ctf(b,:,:).*si(randi(2));
        end
    end
    p = eval(['wjn_tf_' type '(ttf)']);
    clear idx 
    rsum = [];
    cc_p=bwconncomp(p<=.05&squeeze(nanmean(ttf))>0,4);
    cc_n=bwconncomp(p<=.05&squeeze(nanmean(ttf))<0,4);
    idx = [cc_p.PixelIdxList , cc_n.PixelIdxList];
        for b = 1:length(idx)
            rsum(b) = sum(1-p(idx{b}));
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
    [s,i]=sort(msum(:,1));
    disp(1-(find(s==msum(1,1),1,'last')./a));
end
% keyboard
for a = 1:nclusters
    [s,i]=sort(msum(:,a));
    np(a) = 1-(find(s==msum(1,a),1,'last')./(ni+1.5));
    pp(a,:,:) = pp(a,:,:).*(np(a)<=0.05);
end



    