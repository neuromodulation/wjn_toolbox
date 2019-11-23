clear all
close all


root = fullfile(mdf,'colleen','data');
cd(root);

files = ffind('COH*.mat');

for a = 1:length(files)
    d = load(files{a});
    fname = [d.COH.name(4:end) '.mat'];
    id = stringsplit(fname,'_');
    id = id{2}(1:end-4);
%     D=wjn_sl(fname);
%     D.info = d.COH;
%     save(D)
%     GPch = ci({'GPR','GPL'},D.chanlabels);
%     if ~isempty(GPch)
%         for b = 1:length(GPch)
%             D=chanlabels(D,GPch(b),['GPi' D.chanlabels{GPch(b)}(3:end)]);
%         end
%         D=chantype(D,GPch,'LFP');
%         save(D)
%     end
%     D=wjn_filter(D.fullfile,[48 52],'stop');
%     D=wjn_filter(D.fullfile,1,'high');
%     D=wjn_tf_wavelet(D.fullfile,1:100,15);
%     D=wjn_tf_smooth(D.fullfile,0,300);
%     D=wjn_tf_normalization(D.fullfile);
    D=wjn_sl(['bnstf*' fname]);
%     D.info.id = id;
%     D=wjn_keep_channels(D.fullfile,'GPi');
    D=wjn_tf_full_bursts(D.fullfile,'P',50);

    if ~isempty(D.info.twstrs)
        res.twstrs(a,1) = D.info.twstrs;
    else
        res.twstrs(a,1) = nan;
    end
    if ~isempty(D.info.bfmdrs)
        res.bfmdrs(a,1) = D.info.twstrs;
    else
        res.bfmdrs(a,1) = nan;
    end   
    if ~isempty(D.info.age)
        res.age(a,1) = D.info.age;
    else
        res.age(a,1) = nan;
    end

    res.diagnosis{a} = D.info.disease;
    res.electrode{a} = D.info.electrode;
    
    mbursts = D.bursts.mmbursts;
    maxbursts = D.bursts.mmaxbursts;
    for b = 1:size(mbursts,1)
            res.(['m_' mbursts.Properties.RowNames{b}])(a,:) = table2array(mbursts(b,:));
            res.(['max_' maxbursts.Properties.RowNames{b}])(a,:) = table2array(maxbursts(b,:));
    end
%     save results res
end

%% linear model

diagnosis = nan(size(res.diagnosis));
% diagnosis(ci({'cervical','segm.'},res.diagnosis))=0;
diagnosis(ci({'cervical'},res.diagnosis))=0;
diagnosis(ci({'segm.'},res.diagnosis))=1;
diagnosis(ci({'general'},res.diagnosis))=2;
in = ~isnan(diagnosis);
T=diagnosis(in);
i=[9 10 14 15];
% i=1:15
X=[res.m_full_theta(in,i) res.m_theta_beta(in,i) res.m_full_gamma(in,i)];
vars = D.bursts.mbursts.Properties.VariableNames(i);
vars = [strcat('theta_',vars) strcat('beta_',vars) strcat('gamma_',vars)];
slm = stepwiselm(X,T','linear','PredictorVars',vars)

% blm = fitglm(X,T','Distribution','binomial','PredictorVars',vars)

% lm = fitlm(X,T','PredictorVars',vars)