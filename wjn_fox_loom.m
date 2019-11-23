function [r,p,rall,pall,rs,y]=wjn_fox_loom(x,y,type,cv,gauss)
%%

if ~exist('type','var')
    type = 'pearson';
end

if exist('gauss','var') && gauss
    for a = 1:size(x,1)
        x(a,:) = wjn_gaussianize(x(a,:)')';
    end
    
    y=wjn_gaussianize(y);
end

fprintf('create rall');
[rall,pall]=corr(x,y,'rows','pairwise','type',type);

%

if exist('cv','var') && iscell(cv) || iscategorical(cv) || cv ~=1
    
    if iscategorical(cv)
        i =unique(cv);
        nnrs=[];
        nny=[];
        for a =1:length(i)
            [~,~,~,~,nrs,ny]=wjn_fox_loom(x,y,type,{cv~=i(a),cv==i(a)});
            nnrs=[nnrs; nrs{1}];
            nny=[nny;ny{1}];
        end
        rs = nnrs;
        y = nny;
        [r,p]=corr(nnrs,nny,'rows','pairwise','type',type);
        
    elseif iscell(cv) && numel(cv)==2 
        trainInd = cv{1};
        testInd = cv{2};
        [rc,pc]=corr(x(trainInd,:),y(trainInd),'rows','pairwise','type',type);
        [rt,ps]=corr(x(testInd,:)',rc,'rows','pairwise','type',type);
        [r,p]=corr(rt,y(testInd),'rows','pairwise','type',type);
        [rs,ps]=corr(x(trainInd,:)',rc,'rows','pairwise','type',type);
        y={y(trainInd) y(testInd) };
        rs={rs rt};
        
    elseif iscell(cv) && ismatrix(cv)
        y=cv(:,1);
        x=cv(:,2:end);
        keyboard
    
    elseif ~cv
        rs=corr(x',rall,'rows','pairwise','type',type);
        [r,p]=corr(rs,y,'rows','pairwise','type',type);
        
    end
else
    fprintf('\n LOOM')
    i=1:length(y);
    for a = i
        fprintf(['\n ' num2str(a) ' / ' num2str(max(i))])
        ic=setdiff(i,a);
        [rc,pc]=corr(x(ic,:),y(ic),'rows','pairwise','type',type);
        [rs(a,1),ps]=corr(x(a,:)',rc,'rows','pairwise','type',type);
        
    end
    [r,p]=corr(rs,y,'rows','pairwise','type',type);
    
    
end
if r<0
    p=1;
else
    p=p/2;
end




