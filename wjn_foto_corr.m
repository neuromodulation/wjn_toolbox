clear all
close all
files = ffind('*.jpg');

s=[500 500];

for a = 1:500
    
    
    im = imread(files{a});
    try
    nim(n,:,:,:) = im(1:s(1),1:s(2),:);
    n=n+1;
    catch
    end
    
end

%%
nim=single(nim);
nnim = nim;
cn=randi(size(nim,1),1);
ni=cn;
oi = 1:size(nim,1);
while length(ni)<size(nim,1)
    clear r i
    y=single(nim(cn,:));
    nim(cn,:)=nan;
    for b = 1:size(nim,1)
        r(b,1)=corr(nim(b,:)',y','rows','pairwise');
    end
    [~,i]=nanmax(r);
    cn=i;
    ni(length(ni)+1,1) = i;
end
%%
mov = VideoWriter('test.mp4');
open(mov)

for a = 1:length(ni)
    writeVideo(mov,im2frame(uint8(squeeze(nnim(ni(a),:,:,:)))));
end
close(mov)



