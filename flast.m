

% root = fullfile(dbf,'Kamera-Uploads');
va  =1; % ask for rating?
visible = 'on';
mp = [500 2000]; % max pixel of the square
mn = [2 15]; % max number of images
mg = 5000; % number of generated images
npc = [10 90]; % max percentile of color mix
outsize = [1000 1000];
% cd(root);
files = ffind('*.jpg');

for nx = 1:mg
    keep nx ops mp mn mi files va mnc npc mg outsize prcrun visible
    nd=[];
    while isempty(nd)
        n=randi(mn,1);
        i = randperm(length(files),n);
        np = randi(mp,1);
        nd = nan([length(i) np np 3]);
        iout = [];
        
        for a = 1:length(i)
            d=imread(files{i(a)});
            s = size(d);
            if s(1)/2<=np || s(2)/2 <=np
                iout = [iout a];
                continue
            else
                ix = np+randi(s(1)-2*np,1);
                iy = np+randi(s(2)-2*np,1);
                sx = ix+1-np:ix;
                sy = iy+1-np:iy;
                nd(a,:,:,:) = d(sx,sy,:);
            end
            %     imagesc(d(sx,sy,:));
        end
        nd(iout,:,:,:)=[];
    end
    nprc = randi(npc,1);    
    close all
    prc = nprc(pnp);
    nc = uint8(squeeze(prctile(nd,prc,1)));
    inc = imresize(nc,outsize);
    of=figure('Visible',visible);
    imagesc(squeeze(inc));
    set(gca,'XTick',[],'YTick',[],'XColor','none','YColor','none','box','off');
    figone(20,20),set(gca,'position',[0.11 0.11 .785 .79])
    drawnow
    ops(nx,:) = [nx n np prc]
    fname = strrep(strrep([datestr(datetime) '_' num2str(ops(nx,:))],' ','_'),':','_');
    print(of,fullfile(targetfolder,[fname '.png']),'-dpng','-painters','-r600')
end