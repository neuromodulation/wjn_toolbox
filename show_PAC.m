% show_PAC

if exist('file','var')
    load(file)
end
%%
figure,
subplot(4,2,1)
imagesc(f1,f2,squeeze(PAC(1,:,:)))
subplot(4,2,2)
imagesc(f1,f2,squeeze(PAC(2,:,:)));
subplot(4,2,3)
imagesc(f1,f2,squeeze(PAC(1,:,:).*sigPAC(1,:,:)))
subplot(4,2,4)
imagesc(f1,f2,squeeze(PAC(2,:,:).*sigPAC(2,:,:)))

subplot(4,2,5)
imagesc(f1,f2,squeeze(AMP(1,:,:)))
subplot(4,2,6)
imagesc(f1,f2,squeeze(AMP(2,:,:)));
subplot(4,2,7)
imagesc(f1,f2,squeeze(AMP(1,:,:).*sigAMP(1,:,:)))
subplot(4,2,8)
imagesc(f1,f2,squeeze(AMP(2,:,:).*sigAMP(2,:,:)))

figone(20,30)