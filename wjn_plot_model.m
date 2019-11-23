function [y, yp]=wjn_plot_model(mdl)

yp=mdl.Fitted;
y=mdl.Variables.(mdl.ResponseName);

wjn_corr_plot(y,yp,[.5 .5 .5],0)