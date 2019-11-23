 function [r,p,rx,px,rp,yp]=wjn_sst_map(x,y,type,cv)

    % toi = [-2:.05:3];
    % foi = [5 10 15 25];
    %x=shiftdim(D(D.indchantype('EEG'),foi,D.indsample(toi),:),3);
    
    if ~exist('cv','var')
        cv=0;
    end
    if ~exist('type','var')
        type = 'spearman';
        gauss = 0;
    end
    if ~exist('gauss','var')
        gauss = 0;
    end
    if strcmp(type,'gauss')
        type = 'pearson';
        gauss = 1;
    end
    x=squeeze(x);
    ss=size(x);
    rx=nan(ss(2:end));
    px=rx;
    [r,p,rall,pall,rp,yp]=wjn_fox_loom(x(:,:),y,type,cv,gauss);
    rx(:) = rall;
    px(:) = pall;


    