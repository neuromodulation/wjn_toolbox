delete(dio);
clear all

dio = digitalio('nidaq','Dev2'),
all = addline(dio,[0:1],1,'Out');

%%
for a = 1:128;
%     x=zeros(1,8);
%     x= [1 zeros(1,7)]
    putvalue(all,a)
%     pause(0.05)
%     putvalue(all,zeros(1,8))
    pause(0.5)
%     putvalue(all,x)
end