clear all, close all, clc
addpath E:\Dropbox\wjn_toolbox\

stim_settings = [130,600,1.5;
    130,600,2;
    130,600,3;
    190,600,1;
    250,600,1;
    400,600,1;
    130,600,1;
    130,1000,1;
    130,600,1;
    130,200,1];
fdur= .025;

fsample = 100000;

stim_settings=[repmat([130 600 1],4,1);stim_settings;repmat([130 600 1],4,1)];
master_vector =[];

for i = 1:size(stim_settings,1)
    stim_vector = zeros(1,fdur*fsample);
    
    freq = stim_settings(i,1);
    pw = stim_settings(i,2);
    amp = stim_settings(i,3);
    stim_interval = round(fsample/freq);
    negative_samples = round(pw/1000/1000*fsample);
    neutral_samples = round(500/1000/1000*fsample);
    positive_samples = round(stim_interval-negative_samples-neutral_samples);
    for a=1:stim_interval:length(stim_vector)
        stim_vector(a:a+negative_samples)=-amp;
        stim_vector(a+negative_samples:a+negative_samples+neutral_samples)=0;
        stim_vector(a+negative_samples+neutral_samples:a+negative_samples+neutral_samples+positive_samples)=negative_samples/positive_samples*amp;
    end
    master_vector=[master_vector stim_vector];
end
time = linspace(0,length(master_vector)/fsample*1000,length(master_vector));
%%
close all
figure,plot(time,master_vector,'color','k','linewidth',2)
figone(10,40)
ylim([-3.5 .75])
axis off
box off
clear frames
for a = 1:time(end)-180
    if a+100>120 && a+100 <= 210
        title('AMPLITUDE','FontSize',30)
    elseif a+100>210 && a+100 <= 298
        title('FREQUENCY','FontSize',30)
    elseif a+100>298 && a+100 <= 415
        title('PULSE WIDTH','FontSize',30)
    else
        title('STANDARD','FontSize',30)
    end
    xlim([a a+100])
    frames(a)=getframe(gcf);
%     drawnow
%     pause(0.03)
end
v = VideoWriter('stimulation_settings.mp4','MPEG-4');
v.FrameRate = 30;
open(v)
writeVideo(v,frames)
close(v)
