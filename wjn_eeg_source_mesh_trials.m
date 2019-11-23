function D=wjn_eeg_source_mesh_trials(filename)



matlabbatch{1}.spm.tools.beamforming.data.dir = {'E:\Dropbox (Personal)\Motorneuroscience\vm_eeg\HC02NL02-2-13-06-2017\ndata'};
matlabbatch{1}.spm.tools.beamforming.data.D = {'E:\Dropbox (Personal)\Motorneuroscience\vm_eeg\HC02NL02-2-13-06-2017\ndata\rbrarear_dfcspmeeg_N02HC_NL13062017_vm.mat'};
matlabbatch{1}.spm.tools.beamforming.data.val = 1;
matlabbatch{1}.spm.tools.beamforming.data.gradsource = 'inv';
matlabbatch{1}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{1}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{2}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{2}.spm.tools.beamforming.sources.reduce_rank = [2 3];
matlabbatch{2}.spm.tools.beamforming.sources.keep3d = 1;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.orient = 'downsampled';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.fdownsample = 10;
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.symmetric = 'no';
matlabbatch{2}.spm.tools.beamforming.sources.plugin.mesh.flip = false;
matlabbatch{2}.spm.tools.beamforming.sources.visualise = 0;
matlabbatch{3}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.features.whatconditions.condlabel = {
                                                                          'go_aut'
                                                                          'go_con'
                                                                          'move_aut'
                                                                          'move_con'
                                                                          }';
matlabbatch{3}.spm.tools.beamforming.features.woi = [-500 1000];
matlabbatch{3}.spm.tools.beamforming.features.modality = {'EEG'};
matlabbatch{3}.spm.tools.beamforming.features.fuse = 'no';
matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.foi = [21 27];
matlabbatch{3}.spm.tools.beamforming.features.plugin.cov.taper = 'hanning';
matlabbatch{3}.spm.tools.beamforming.features.regularisation.manual.lambda = 5;
matlabbatch{3}.spm.tools.beamforming.features.bootstrap = true;
matlabbatch{4}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.orient = true;
matlabbatch{4}.spm.tools.beamforming.inverse.plugin.lcmv.keeplf = false;
matlabbatch{5}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.whatconditions.condlabel = {
                                                                                           'go_aut'
                                                                                           'go_con'
                                                                                           'move_aut'
                                                                                           'move_con'
                                                                                           }';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.sametrials = false;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.woi = [-500 0];
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.foi = [21 27];
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.logpower = true;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.result = 'bycondition';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
matlabbatch{5}.spm.tools.beamforming.output.plugin.image_power.modality = 'EEG';
matlabbatch{6}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.write.plugin.gifti.normalise = 'all';
matlabbatch{6}.spm.tools.beamforming.write.plugin.gifti.space = 'mni';
matlabbatch{6}.spm.tools.beamforming.write.plugin.gifti.visualise = 2;