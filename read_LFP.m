

root = fullfile(mdf,'visuomotor_tracking');
cd(root);
patcode  = 'PD_STN_LFP01HR01-1-10-02-2014';


cd(fullfile(patcode,'raw_data'))
cond = 'LFP_ON';
load(patcode,'AO0');
load(patcode,'AO1');
load(fullfile(root,patcode,'task_data',[patcode '_LFP_ON']),'blockorder','nrounds','side');


t = AO0.times;
x = AO0.values;
y = AO1.values;

dx = find(round(x)==1 & round(y) == 1);
dy = find(round(y)==1 & round(y) == 1);
plot(t,x);
hold on;
plot(t,y);
scatter(t(dx),x(dx))
scatter(t(dy),y(dy));
xlim([0 20]);

% keep root patcode x y t

% %% find start
% 
% istart = find(round(x) == 5 & round(y) == -5,1,'first');
% 
% figure,
% plot(t,x,t,y);
% xlim([0 3])
% hold on;
% scatter(t(istart),x(istart));
% scatter(t(istart),y(istart));
% 
% xlim([t(istart)-10 t(istart)+10])

%% find trials
i = 1;
for a = 1:length(side);
    for b=5:length(t);
        if round(x(b)*100)/100 == side(a) && round(y(b)*100)/100 == side(a)
            i(a,1) = b;
        end
    end
end
        
