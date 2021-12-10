p=struct;
p(1).id = 'FK';
p(1).raw_data = 'FK.m00';
p(1).move_channel = 'X5';

p(2).id = 'SN';
p(2).raw_data = 'SN.m00';
p(2).move_channel = 'X5';

p(3).id = 'WK';
p(3).raw_data = 'A191008114007.EDF';
p(3).move_channel = 'EOG EOG1';


% WRITE OUT EXCEL FROM MOVEDATA

% for a = 1:length(p)
%     write_move_xls(p(a));
% end

%EPOCH JERKS
epoch_jerks(p(3))



function epoch_jerks(ps)
cfg=[];
cfg.trl=jerk_trials(ps);
cfg.dftfilt = 'yes';
cfg.detrend = 'yes';
cfg.lpfreq = 45;
cfg.dataset = ps.raw_data;
cfg.channel = 'all';
keyboard
data = ft_preprocessing(cfg);


    function trl=jerk_trials(ps)
        cfg=[];
        cfg.dataset=ps.raw_data;
        cfg.lpfilter = 'yes';
        cfg.lpfreq = 10;
        cfg.detrend = 'yes';
        cfg.dftfilt = 'yes';
        cfg.channel = ps.move_channel;
        data=ft_preprocessing(cfg);
        mdata = wjn_zscore(data.trial{1});
        onset=mythresh(mdata,1);
        offset=mythresh(-mdata,0);
        
        n=0;trl=[];
        for a=1:length(offset)
            ionset = find(onset>offset(a),1,'first');
            if ~isempty(ionset) && (onset(ionset)-offset(a))>=(2*data.fsample)
                n=n+1;
                trl(n)=onset(ionset);
            end
        end
        close all
        figure,plot(data.time{1},mdata),hold on,scatter(data.time{1}(trl),mdata(trl),'r*')
        
        [~,~,trl] = wjn_create_raw_epochs(trl,[-data.fsample*2 data.fsample*2]);
    end
end

function write_move_xls(ps)



cfg=[];
cfg.dataset=ps.raw_data;
data=ft_preprocessing(cfg);

cfg=[];
cfg.resamplefs = 20;
data=ft_resampledata(cfg,data);

movedata = [data.time{1}',data.trial{1}(ci(ps.move_channel,data.label),:)'];
xlswrite(ps.id,{'Time','EMG'},1,'A1');
xlswrite(ps.id,movedata,1,'A2')

end



