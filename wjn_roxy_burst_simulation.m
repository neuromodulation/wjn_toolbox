clear
close all
nd=[rand(1,100)*250 rand(1,100).*[1:100]+20 rand(1,30)*350 rand(1,70)*220];


nt=linspace(0,90,length(nd));
t = linspace(0,90,90*200);
d=interp1(nt,nd,t,'linear');

z= wjn_moving_zscore(d,3000);

ti = wjn_sc(t,[0 30 60 90]);
cc=colorlover(5);
cc=cc([1 3 5],:);
figure
subplot(2,3,1:3)
plot(t,z.*100,'linewidth',1.5)
hold on
plot(t,d,'linewidth',1.5);
legend({'weighted Z-Score','original'})
xlabel('Time [s]')
ylabel('Beta amplitude [a.u.]')
subplot(2,3,4)
wjn_corr_plot(d(ti(1):ti(2))',z(ti(1):ti(2))',cc(1,:));
title('rest')
subplot(2,3,5)
wjn_corr_plot(d(ti(2):ti(3))',z(ti(2):ti(3))',cc(2,:));
title('move')
subplot(2,3,6)
wjn_corr_plot(d(ti(3):ti(4))',z(ti(3):ti(4))',cc(3,:));
title('rest')