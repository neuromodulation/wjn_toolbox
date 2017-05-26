percentage = 0:10:100;
for a = 0:length(percentage)-1;
    rt_all(1,a+1)=nanmean(rt(pct == percentage(a+1)));
    rt_neg(1,a+1)=nanmean(rt(pct == percentage(a+1) & valnum == 1));
    rt_neu(1,a+1)=nanmean(rt(pct == percentage(a+1) & valnum == 2));
    rt_pos(1,a+1)=nanmean(rt(pct == percentage(a+1) & valnum == 3));
    
    rt_erkannt_all(1,a+1)=nanmean(rt(response==recognitionbutton & pct == percentage(a+1)));
    rt_nichterkannt_all(1,a+1)=nanmean(rt(response==norecognitionbutton & pct == percentage(a+1)));
    
    n_erkannt_all(1,a+1) = sum(response==recognitionbutton & pct == percentage(a+1));
    n_nichterkannt_all(1,a+1) = sum(response==norecognitionbutton & pct == percentage(a+1));
    
    rt_erkannt_neg(1,a+1)=nanmean(rt(response==recognitionbutton & pct == percentage(a+1) & valnum == 1));
    rt_nichterkannt_neg(1,a+1)=nanmean(rt(response==norecognitionbutton & pct == percentage(a+1) & valnum == 1));

    rt_erkannt_neu(1,a+1)=nanmean(rt(response==recognitionbutton & pct == percentage(a+1) & valnum == 2));
    rt_nichterkannt_neu(1,a+1)=nanmean(rt(response==norecognitionbutton & pct == percentage(a+1) & valnum == 2));

    rt_erkannt_pos(1,a+1)=nanmean(rt(response==recognitionbutton & pct == percentage(a+1) & valnum == 3));
    rt_nichterkannt_pos(1,a+1)=nanmean(rt(response==norecognitionbutton & pct == percentage(a+1) & valnum == 3));

    
    n_erkannt_neg(1,a+1)= sum(response==recognitionbutton & pct == percentage(a+1) & valnum == 1);
    n_nichterkannt_neg(1,a+1)= sum(response==norecognitionbutton & pct == percentage(a+1) & valnum == 1);

    n_erkannt_neu(1,a+1)= sum(response==recognitionbutton & pct == percentage(a+1) & valnum == 2);
    n_nichterkannt_neu(1,a+1)= sum(response==norecognitionbutton & pct == percentage(a+1) & valnum == 2);

    n_erkannt_pos(1,a+1)= sum(response==recognitionbutton & pct == percentage(a+1) & valnum == 3);
    n_nichterkannt_pos(1,a+1)= sum(response==norecognitionbutton & pct == percentage(a+1) & valnum == 3);
    
end

figure;
subplot(4,2,1);
plot(percentage,rt_all,'LineSmoothing','on','LineWidth',2);
xlabel('% of patients face');ylabel('reaction time [ms]');
title('Reaction times across all valences');
subplot(4,2,2);
plot(percentage,rt_neg,percentage,rt_neu,percentage,rt_pos,'LineSmoothing','on','LineWidth',2);
xlabel('% of patients face');ylabel('reaction time [ms]');legend({'neg','neu','pos'});
title('Reaction times across all valences');
subplot(4,2,3);
plot(percentage,rt_erkannt_all,percentage,rt_nichterkannt_all,'LineSmoothing','on','LineWidth',2);
xlabel('% of patients face');ylabel('reaction time [ms]');
title('Reaction times across all valences');legend({'recognized','not recognized'});
subplot(4,2,4);
plot(percentage,n_erkannt_all,percentage,n_nichterkannt_all,'LineSmoothing','on','LineWidth',2);
xlabel('% of patients face');ylabel('n');
title('Number of recognitions across all valences');legend({'recognized','not recognized'});
subplot(4,2,5);
plot(percentage,rt_erkannt_neg,percentage,rt_erkannt_neu,percentage,rt_erkannt_pos,'LineSmoothing','on','LineWidth',2);
xlabel('% of patients face');ylabel('reaction time [ms]');
title('Reaction times for self-recognition');legend({'neg','neu','pos'});
subplot(4,2,6);
plot(percentage,rt_nichterkannt_neg,percentage,rt_nichterkannt_neu,percentage,rt_nichterkannt_pos,'LineSmoothing','on','LineWidth',2);
xlabel('% of patients face');ylabel('reaction time [ms]');
title('Reaction times for no self-recognition');legend({'neg','neu','pos'});
subplot(4,2,7);
plot(percentage,n_erkannt_neg,percentage,n_erkannt_neu,percentage,n_erkannt_pos,'LineSmoothing','on','LineWidth',2);
title('Number of self-recognitions');legend({'neg','neu','pos'});
xlabel('% of patients face');ylabel('n');
subplot(4,2,8);
plot(percentage,n_nichterkannt_neg,percentage,n_nichterkannt_neu,percentage,n_nichterkannt_pos,'LineSmoothing','on','LineWidth',2);
title('Number of no self-recognitions');legend({'neg','neu','pos'});
xlabel('% of patients face');ylabel('n');
