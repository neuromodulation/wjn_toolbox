function c = wjn_erc_colormap



c = [55 110 181 % Blue
224 74 74 % Red
113 189 174 % Yellow
216 179 66 % Green
216 214 204 % Beige
235 235 235 % Light grey
64 64 64]./256; % Dark grey 

figure;
for a = 1:size(c,1)
    
    x=nan(1,size(c,1));
    x(a) = 1;
    b=bar(x);hold on;
    set(b,'EdgeColor',c(a,:),'FaceColor',c(a,:),'BarWidth',1)
end
figone(3);
title(['Julians ERC starting grant palette'])
set(gca,'YTick',[])
xlim([0.5 size(c,1)+.5])
myprint('palette')