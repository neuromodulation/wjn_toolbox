function F=wjn_plot_sst(mesh,x,t,d)
%%
x = squeeze(x);
if exist('d','var')
    ns=3;
else
    ns=4;
end


figure
subplot(4,1,1:ns)
p = wjn_plot_surface(mesh,x(:,1));
% colormap('jet');
% caxis([-50 50]);
c=colorbar;
set(c,'Color','w','FontSize',20);
c.Label.String='Beta power [%]';
caxis([prctile(x(:),.0001) prctile(x(:),99.999)])
caxis([-30 30])
if ns==3
subplot(4,1,4)
plot(t,d,'color','w','Linewidth',5)
hold on
sp=scatter(t(1),d(1),60,'ro','filled');
% axis off
 xlabel('Time [s]')
   set(gca,'XColor','k')
set(gca,'color','k')
bax = gca;
end
set(gcf,'Position', [ 680          85        1157         893])
pause
% figone(40,40)

for a = 1:length(t)
%     [m,i]=nanmax(abs(x(:,:,a))');
%     p.CData=i;
%     p.FaceVertexAlphaData = m';

% pause(.3)
    title(bax,['Movement onset: ' num2str(t(a),3) ' s'],'color','w','FontSize',20);
    p.CData = squeeze(x(:,a));
    p.FaceVertexAlphaData = abs(squeeze(x(:,a)));
    drawnow
%     pause(nanmean(diff(t)))
   
%     pause
F(a) = getframe(gcf);
    if ns==3
        try
    sp.XData = t(a);
    sp.YData = d(a);
        catch
            return
        end
    end
end
    
    

% %%
% rall=[];pall=[];mcx=[]
% for a = 1:20
%   
% cx = nnx(T.subj==num2str(a),:,:,:);
% cT = T(T.subj==num2str(a),:);
% mrt(a,1) = nanmean(cT.mt);
% % [r,p,rall(a,:,:,:),pall(a,:,:,:)]=wjn_sst_map(cx,cT.rt,0);
% mcx(a,:,:,:) = squeeze(nanmean(cx));
% disp(a)
% end
% 
% [mr,mp,mrall,mpall,rp,yp]=wjn_fox_loom(mcx(:,:),mrt,'spearman')
% 
% xx = cx;
% xx=squeeze(xx(1,:,:,:));
% pp=xx;
% xx(:) = mrall(:);
% pp(:) = mpall(:);
% 
% figure
% for a = 1:size(xx,3)
%     wjn_plot_surface(D.sources.mesh,xx(:,2,a));
%     caxis([-.5 .5])
%     title(toi(a),'color','w')
%     pause(.2)
% end
% 
% 
% [hbeta,x]=hist(xx(:,2,:));
% [htheta,x]=hist(xx(:,1,:));
% figure
% subplot(1,2,1)
% imagesc(toi,x,hbeta),axis xy
% title('beta')
% subplot(1,2,2)
% imagesc(toi,x,htheta), axis xy
% title('theta')