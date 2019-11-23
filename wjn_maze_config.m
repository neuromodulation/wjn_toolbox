clear;close all; clc;wjn_tmsi_initialize(-1);pool = gcp;
%% OPTIONS
options.root = 'C:\CODE\tasks\mwmaze\deploy';
options.name = 'WJN_Cz2';
options.diagnosis = 'test';
options.condition = 'test';
options.rec = 'LFP';
options.plot = 0;
options.start_delay = 4;
options.stim = 0;
options.stim_constant = 1;
options.stim_increase = 1.5;
options.stim_decrease = .5;
options.stim_increase_condition = {'joy(1)>.25','joy(1)<-.25','0','0','0'};
options.stim_decrease_condition = {'0','joy(1)<-.25','0','0','joy(1)>.25'};
options.stim_channel = [ 2 3 4 5 6 7 10 11 12 13 14 15];
options.stim_initial_ramp_duration = 0:25:500;
options.stim_ramp_duration = 0:25:50;
options.stim_duration= 1;
options.stim_interval = 1;
options.stim_return_channel = -1;
options.stim_freq_hz=130;
options.stim_pulse_width=60;


%% SET DIRECTORIES
addpath C:\CODE\tasks\
if strcmp(options.rec,'LFP')
    fileroot = fullfile(options.root,'TMSi',options.name);
else
    fileroot = fullfile(options.root,'BEH',options.name);
end
if exist(fileroot,'dir')
    ov=input('overwrite?','s');
    if ~strcmp(ov,'y')
        return
    end
else
    mkdir(fileroot);
end
cd(fileroot);
%% CHECK FOR JOYSTICK
joystick = vrjoystick(1);
%% INITIALIZE TMSI
if strcmp(options.rec,'LFP')
    [sampler,poly5,channels,device,fs]=wjn_tmsi_initialize(options.name);
    if options.plot
        LFP = TMSi.RealTimePlot('LFP',sampler.sample_rate,device.channels);
        LFP.setWindowSize(5);
        LFP.show;
    end
end
%% INITIALIZE Alpha Omega
if options.stim
    wjn_init_AO(name,1);
end
%% CONFIG COGENT
config_display(0,1)
config_keyboard;
start_cogent
%% CONFIG EXPERIMENT FILE
root = options.root;
config = fullfile(root,'config','VMWM-Experiment-Config.csv');
cd(fullfile(root,'config'))
delete(config)
sp='NESW';
ntrials = 10;
T = table;
for a = 1:ntrials
    T.Run_ID(a,1) = a;
    T.Pos_GoalDistance(a,1) = .5+(randi(50)/100); % Relative distance to radius
    T.Pos_Goal_Degree(a,1) = randi(360); % SE= 45 S = 90 SW=135 W = 180 NW = 225 N = 270 NE = 315  E=0
    T.Goal_Size(a,1) = 1.5;
    T.Pond_Size(a,1) = 10;
    T.Spatial_Cue_Presence{a,1} = 'yes';
    T.Time_Threshold(a,1) = 10000;
    T.Scripted_Spawn_Points{a,1} = ['"S' repmat([', ' sp(randi(4))],1,50) '"']; % W = S, S = W, N = E, E = N
    T.Spatial_Cue_Visibility{a,1} = '"NE=yes,SE=yes,SW=yes,NW=yes"';
    if a == 1
        T.Show_Target_Platform{a,1} = 'YES';
    else
        T.Show_Target_Platform{a,1} = 'NO';
    end
end
T
%% WRITE CONFIG AND START
writetable(T,config,'Delimiter',';')
system([fullfile(options.root,'build','VMWM.exe') ' &'])
%% INITIALIZE REAL-TIME UPDATE
if strcmp(options.rec,'LFP')
    nsindex = [34 35 36 37];
else
    nsindex = [4 5 6 7];
end
nstart=0;clc;t0=tic;tlast=tic;tstop = tic;pause(.1)
btn = button(joystick);ax = axis(joystick);joy =  [ax(1:2) btn([11 10]) 0 0];
x=0;ns = [];
cinc = repmat(options.stim_increase_condition,1,100);
cdec = repmat(options.stim_decrease_condition,1,100);
%% START STIMULATION AT SPECIFIED CONSTANT CURRENT
current_amp=wjn_stim_AO([1 options.stim],options.stim_channel,options.stim_constant,options.stim_initial_ramp_duration,0,options.stim_return_channel,options.stim_freq_hz,options.stim_pulse_width);
%% START REAL-TIME LOOP
while x==0
    tnew=tic;
    btn = button(joystick);ax = axis(joystick);joy =  [ax(1:2) btn([11 10])  0 0];
    if strcmp(options.rec,'LFP')
        if options.plot
            rs = sampler.sample();
            ns=rs;
        else
            ns = sampler.sample();
        end
        ns(32:37,:) = repmat(joy',1,size(ns,2));
    elseif ~strcmp(options.rec,'LFP') && toc(tlast)-toc(tnew)>.02
        ns = [ns,[toc(t0);joy']];
        tlast = tic;
    end
    
    readkeys
    
    if lastkeydown == 60 || joy(3)
        ns(nsindex(1),end) = 1;
        disp('start')
        nstart=nstart+1;
        
        
    elseif lastkeydown== 70 || joy(4)
        ns(nsindex(2),end) = 1;
        disp('confirm')
    end
    
    
    if nstart && eval(cinc{nstart}) && toc(tstop)>options.stim_interval
        disp(['INCREASE TO ' num2str(options.stim_increase)])
        parfevalOnAll(pool,'wjn_stim_AO',1,[1 options.stim],options.stim_channel,[current_amp options.stim_increase],options.stim_ramp_duration,options.stim_duration,options.stim_return_channel);
        ns(nsindex(3),end) = 1;
        tstop=tic;
        
    elseif nstart && eval(cdec{nstart}) && toc(tstop)>options.stim_interval
        parfevalOnAll(pool,'wjn_stim_AO',1,[1 options.stim],options.stim_channel,[current_amp options.stim_decrease],options.stim_ramp_duration,options.stim_duration,options.stim_return_channel);
        ns(nsindex(4),end) = 1;
        tstop=tic;
        disp(['DECRASE TO ' num2str(options.stim_increase)])
    end
    
    if strcmp(options.rec,'LFP')
        poly5.append(ns);
        if options.plot
            LFP.append(rs);
            LFP.draw;
        end
    end
    
    if lastkeydown == 52
        disp('stopping')
        x=1;
    end
    
end

%% CLEAN UP

if strcmp(options.rec,'LFP')
    wjn_tmsi_initialize(-1), poly5.close();
end

save(fullfile(fileroot,[options.name '_mwmaze']))



try
    stop_cogent
end
if options.stim
    wjn_stim_AO(-1,options.stim_channel,0);
    wjn_init_AO(options.name,-1)
end
logs = dir(fullfile(root,'Logs'));
[~,i] = max([logs(3:end).datenum]);
try
    maze = wjn_import_maze_log(fullfile(root,'Logs',logs(2+i).name));
catch
    disp('LOG COULD NOT BE LOADED')
    logfound = 0;
end



cd(fileroot)

if strcmp(options.rec,'LFP')
    nchannels = wjn_tmsi_standard_channels;
    data = TMSi.Poly5.read(poly5.filepath);
    nchannels(32:37,:) = {'joy_x','joy_y','btn_start','btn_confirm','stim_increase','stim_decrease'};
    D=wjn_import_rawdata(['spm_' data.name '.mat'],data.samples,nchannels,data.sample_rate);
    
else
    nx = linspace(ns(1,1),ns(1,end),(ns(1,end)-ns(1,1))*50);
    ins = interp1(ns(1,:)',ns(2:end,:)',nx')';
    nchannels = {'joy_x','joy_y','btn_start','btn_confirm','stim_increase','stim_decrease'};
    D=wjn_import_rawdata(['spm_' options.name '_mwmaze'],ins,nchannels,50);
end
% keyboard
D(ci({'btn_start','btn_confirm','stim_increase','stim_decrease'},D.chanlabels),:,1)= ceil(D(ci({'btn_start','btn_confirm','stim_increase','stim_decrease'},D.chanlabels),:,1));

iinc = find(D(ci('stim_increase',D.chanlabels),:));
for a = 1:length(iinc)
    D(ci('stim_increase',D.chanlabels),iinc(a):iinc(a)+wjn_sc(D.time,options.stim_duration))=1;
end
idec = find(D(ci('stim_decrease',D.chanlabels),:));
for a = 1:length(idec)
    D(ci('stim_decrease',D.chanlabels),idec(a):idec(a)+wjn_sc(D.time,options.stim_duration))=1;
end


D.info.name = options.name;
D.info.diagnosis = options.diagnosis;
D.info.condition = options.condition;
D(ci('joy_y',D.chanlabels),:,1) = D(ci('joy_y',D.chanlabels),:,1).*-1;
D.task.maze=maze;
% D.task.
D.task.start_delay = options.start_delay;
D.task.spm_istart = round(D.task.start_delay*D.fsample+mythresh(D(ci('btn_start',D.chanlabels),:,1),.5));
D.task.spm_iconfirm = round(D.task.start_delay*D.fsample+mythresh(D(ci('btn_confirm',D.chanlabels),:,1),.5));
D.task.spm_tstart = D.time(D.task.spm_istart(1));
D.task.tstart=maze(1).t(1)-(D.task.spm_tstart*1000);
D.task.t = linspace(D.task.tstart,D.task.tstart+(1000*D.time(end)),D.nsamples);
D.task.config = T;
save(D)
dummy = zeros(size(D.time));
add.maze_running = dummy;
add.maze_nrun = dummy;
add.maze_ntrial = dummy;
add.maze_X = dummy.*nan;
add.maze_Y = dummy.*nan;
% keyboard
for a = 1:length(maze)
    i = wjn_sc(D.task.t,maze(a).tstart):wjn_sc(D.task.t,maze(a).tstop);
    add.maze_running(i) = 1;
    add.maze_nrun(i) = maze(a).run;
    add.maze_ntrial(i) = maze(a).trial;
    [~,iu]=unique(maze(a).t);
    add.maze_X(i) = interp1(maze(a).t(iu),maze(a).x(iu),D.task.t(i));
    add.maze_Y(i) = interp1(maze(a).t(iu),maze(a).y(iu),D.task.t(i));
    logfound = 1;
end
D=wjn_add_channels(D.fullfile,add);


figure,
plot(D.time,5.*squeeze(D(ci('joy',D.chanlabels),:,1)),'linewidth',1)
hold on
sigbar(D.time,D(ci('stim_increase',D.chanlabels),:),[.5 .5 .5])
sigbar(D.time,D(ci('stim_decrease',D.chanlabels),:),[.7 .7 .7])
plot(D.time,5.*squeeze(D(ci('joy',D.chanlabels),:,1)),'linewidth',1)
plot(D.time,D(ci({'maze_X','maze_Y'},D.chanlabels),:),'linewidth',1.5)

