
root = fullfile(mdf,'mdd_bursts');
cd(root)
files = ffind('r*.mat');

for a = 1:length(files)
%     
%     D=wjn_spikeconvert(files{a});
%     fname = stringsplit(files{a},'_');
%     D.info.n = str2double(fname{2});
%     D.info.target = fname{3}; 
%     D.info.diagnosis = fname{4};
%     D.info.age = str2double(fname{5}(4:end));
%     D.info.sex = fname{6}(end);
%     D.info.dd = str2double(fname{7}(3:end));
%     D.info.bdi = str2double(fname{8}(4:end));
%     D.info.hamd = str2double(fname{9}(5:end));
%     D.info.id = fname{11};
%     save(D)
    
%     D=wjn_tf_wavelet(D.fullfile,1:100,100,D.info.target);
%     D=wjn_tf_smooth(D.fullfile,2,250);
D=wjn_sl(['stf*' files{a}]);
    D=wjn_tf_normalization(D.fullfile);

    D=wjn_tf_full_bursts(D.fullfile);
end


%%
clear all
close all
files = ffind('nstf*bnst*.mat');
for a = 1:length(files)
    D=wjn_sl(files{a});
    in = ci('weight',D.mbursts.Properties.VariableNames);
    spow(a,:) = squeeze(nanmean(nanmean(D(:,8:14,:,1),2),3));
    mspow(a,1) = nanmean(spow(a,:),2);
    bdi(a,1)=D.info.hamd;
    i = ci({'full_alpha'},D.mbursts.Properties.RowNames);
    ir = ci([D.info.target 'R'],D.mbursts.Properties.RowNames(i));
    il = ci([D.info.target 'L'],D.mbursts.Properties.RowNames(i));
    [~,imr] = nanmax(table2array(D.mbursts(i(ir),in)));
    [~,iml] = nanmax(table2array(D.mbursts(i(il),in)));
%     m(a,:) = [mspow(a) nanmean(table2array(D.mbursts(i([ir(imr) il(iml)]),:)))];
    m(a,:) = [mspow(a) nanmean(table2array(D.mbursts(i,:)))];
end
vars = ['mpow' D.mbursts.Properties.VariableNames];
for a = 1:length(vars)
	figure
    wjn_corr_plot(m(:,a),bdi);
%     wjn_corr_optimizer(m(:,a),bdi);
    title(vars{a});
end

fitlm(m,bdi)

stepwiselm(m,bdi)