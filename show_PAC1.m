% show_PAC

if exist('file','var')
    load(file)
end
%%
figure,
subplot(2,2,1)
imagesc(f1,f2,squeeze(PAC(:,:)))
subplot(2,2,2)
imagesc(f1,f2,squeeze(PAC(:,:).*sigPAC(:,:)))


subplot(2,2,3)
imagesc(f1,f2,squeeze(AMP(:,:)))
subplot(2,2,4)
imagesc(f1,f2,squeeze(AMP(:,:).*sigAMP(:,:)))


figone(20,30)