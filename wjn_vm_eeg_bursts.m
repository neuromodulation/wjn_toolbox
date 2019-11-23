clear

filename = 'clr_spmeeg_reproc_N15HC_CB20072017_vm.mat';

D=wjn_sl(filename);

D=wjn_tf_wavelet(D.fullfile,[1:100],100)



