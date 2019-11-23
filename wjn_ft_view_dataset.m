function wjn_ft_view_dataset(filename)

cfg=[];
cfg.dataset = filename;
data = ft_preprocessing(cfg);

cfg=[];
cfg.resamplefs=20;
data = ft_resampledata(cfg,data)

cfg=[];
cfg.viewmode = 'vertical';
ft_databrowser(cfg,data)