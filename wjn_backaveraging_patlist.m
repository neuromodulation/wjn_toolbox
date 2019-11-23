p=struct;
p(1).id = 'FK';
p(1).raw_data = 'FK.m00';
p(1).move_channel = 'X5';

p(2).id = 'SN';
p(2).raw_data = 'SN.m00';
p(2).move_channel = 'X5';



%% WRITE OUT EXCEL FROM MOVEDATA

for a = 1:length(p)
    write_move_xls(p(a));
end


function write_move_xls(p)



cfg=[];
cfg.dataset=p.raw_data;
data=ft_preprocessing(cfg);

cfg=[];
cfg.resamplefs = 20;
data=ft_resampledata(cfg,data);

movedata = [data.time{1}',data.trial{1}(ci(p.move_channel,data.label),:)'];
xlswrite(p.id,{'Time','EMG'},1,'A1');
xlswrite(p.id,movedata,1,'A2')

end



