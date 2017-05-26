close all
% x=rand(1,1)*100;
% y=rand(1,1)*100;
% z=rand(1,1)*100;

c=colorlover
figure;
b1=bar([1,2,3],[x,nan,nan])
hold on;
b2=bar([1,2,3],[nan,y,nan]);
b3=bar([1,2,3],[nan,nan,z]);

set(b1,'facecolor',c(1,:))
set(b2,'facecolor',c(3,:))
set(b2,'facecolor',c(5,:))

e1=errorbar([1 2 3],[x,y,z],[0 0 0],[x/2 y/2 z/2],'LineStyle','none','color','k');
xlim([0.5 3.5])
figone(7)

sigbracket('**',[1 2],130)
sigbracket('*',[1 3],150)
% LineH = get(gca, 'children');
% Value = get(LineH, 'YData');
% Time = get(LineH, 'XData');
% [maxValue, maxIndex] = max(Value);
% maxTime = Time(maxIndex);

