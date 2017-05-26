function [closedmode,circlesize,circledistance,scalingfactor,fixationcrosssize,cursorsize,homingsize,pretrialtime,sc,blocksize,screen_resolution,background_color,font_color,stay_length,done_color,homing_color,green_color,red_color,over_color]=get_parameters(save_param,name);
%% Variables to tweak the paradigm
% 
% if exist('parameters.mat','file');
%     load parameters
% else
closedmode=0;

background_color = [0.95    0.95    0.95];
font_color = [0 0 0];
homing_color = [ 0.8    0.8    0.8; 0.95    0.95    0.95];
over_color = [0.7373    0.7843    0.8627] .*0.7;
done_color = [0.7373    0.7843    0.6];
green_color = [0.0627    0.4314    0.0118];
red_color = [0.7804    0.1451    0.0863];

circlesize= 70; % Size of the presented target circle
circledistance = 150; %default 325
fixationcrosssize = 30; % Fontsize
cursorsize= 5; % Size of the cursor ellipse
homingsize = 20;
stay_length = 100;

pretrialtime = 1; % seconds

blocksize = 30; % number of trials per block


screen_resolution = 2; % 1 for 640x480 , 2 for 800x600

scalingfactor = 1.5; % Max Joystick to circledistance;
sc = circledistance*scalingfactor/5;


% 
% if exist('save_param','var') 
%     if save_param == 1;
% %         save parameters
% %     elseif save_param == 2;
%         save(fullfile(mdf,'visuomotor_tracking',name,'task_data','backup'));
%     end
% end
end