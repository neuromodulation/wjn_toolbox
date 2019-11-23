function [data]=wjn_import_maze_log(folder)
% clear all, close all, clc

files = wjn_subdir(fullfile(folder,'Trial*.txt'));
n=0;
for a = 1:length(files)
    filename = files{a};
    h=wjn_maze_import_header(filename);
    if ~isempty(h)
        n=n+1;
        [x,y]=wjn_maze_import_coordinates(filename);
        t=wjn_maze_import_timestamp(filename);
        h.nsamples = length(t);
    
    data(n).t=t';
    data(n).tstart = t(1);
    data(n).tstop = t(end);
    data(n).tt = (t-t(1))./1000;
    data(n).x=x';
    data(n).y=y';
    data(n).h = h;
    data(n).run = h.run_id;
    [~,fname]=fileparts(filename);
    data(n).trial = str2num(fname(6));
    data(n).date=datestr(h.date);
    if n>1 && data(n).run == data(n-1).run
        data(n).pretrialinterval = data(n).t(1)-data(n-1).t(end);
    end
%     figure
%     subplot(1,3,1)
%     plot(data(n).tt,data(n).x);
%     title(['RUN = ' num2str(data(n).run) ' TRIAL = ' num2str(data(n).trial)]);
%     xlabel('Time [s]')
%     ylabel('X')
%     subplot(1,3,2)
%     plot(data(n).tt,data(n).y);
%     title(data(n).h.scripted_spawn_points{1}(4))
%     xlabel('Time [s]')
%     ylabel('Y')
%    subplot(1,3,3)
%    plot3(data(n).tt,data(n).x,data(n).y)
%    xlabel('Time [s]');ylabel('X');zlabel('Y');
    end
end

