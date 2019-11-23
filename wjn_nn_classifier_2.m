function [L,Y,net] = wjn_nn_classifier_2(X,T,ica,H,tD,goal,lockindices,psig,nsubblocks)
% wjn_nn_classifier_2(X,T,ica,H,tD,goal,lockindices,psig,nsubblocks)
% X = feature table
% T = target variable
% ica = independent component analysis 0 = off (default), 1 = principal
% components explaining 95% of variability, ica>1 = number of independent
% components
% H = hidden layer architecture e.g. = [8 8 8] => 3 hidden layers with 8
% neurons
% tD = time delays (default = {0 10 20 40} in samples)
% goal = 0
% lockindices = use same hold out validation set 
% psig = only use significant predictors of linear model (default = 0)
% nsubblocks = number of subblocks 

if size(T,1)>size(T,2)
T=T';
end
if ~exist('nsubblocks','var')
    nsubblocks = 1;
end
if ~exist('lockindices','var')
    lockindices=0;
end

if ~exist('tD','var') || isempty(tD)
    tD ={80,80:40:200, 0:40:200};
elseif ~iscell(tD)
    tD={tD};
end

if ~exist('goal','var') || isempty(goal)
    goal =0.01;
end

oX = X;

Q = length(T);
if length(nsubblocks)==1
    trainRatio = 0.8;
    valRatio = .2;
    testRatio = 0;
    [trainInd,valInd,testInd] = wjn_ml_dividesubblocks(Q,nsubblocks,trainRatio,valRatio,testRatio);

elseif length(nsubblocks) == 4
    trainRatio = nsubblocks(2);
    valRatio = nsubblocks(3);
    testRatio = nusbblock(4);
    [trainInd,valInd,testInd] = wjn_ml_dividesubblocks(Q,nsubblocks,trainRatio,valRatio,testRatio);
elseif iscell(nsubblocks) && length(nsubblocks) == 3
    trainInd = nsubblocks{1};
    valInd = nsubblocks{2};
    testInd = nsubblocks{3};
end
% keyboard
ti = 1:Q;


if lockindices
    try
        d=load('nn_lockindices');
        try
        disp(max(ti(d.valInd)));
        valInd=d.valInd;
        trainInd = d.trainInd;
        testInd = d.testInd;
        warning('loaded old indices')
        catch
            warning('no index file found. storing new one')
               save('nn_lockindices','trainInd','valInd','testInd');
           
        end
    catch
        
            warning('no index file found. storing new one')
               save('nn_lockindices','trainInd','valInd','testInd');
           
    end
     
     
        
   
end

if isempty(testInd)
    valI = valInd;
else
    valI = testInd;
end

% keyboard
% figure


if ~exist('psig','var')
    psig = 0;
end

if ~exist('ica','var') || isempty(ica)
    ica = 0;
    
end

if size(T,2)<size(T,1)
    T=T';
end
t=T;
% keyboard
if ~iscell(X)
    if istable(X)
        
        if ~ica
            if numel(unique(T))==2
                lm = fitglm(table2array(X(trainInd,:)),t(1,trainInd)','Distribution','binomial','PredictorVars',X.Properties.VariableNames);
                binom = 1;
            else
                binom = 0;
                lm = fitglm(table2array(X(trainInd,:)),t(1,trainInd)','PredictorVars',X.Properties.VariableNames);
            end
            
        else
            x = table2array(X)';
            %             if size(X,2)<30
            nX = X;
            
            if numel(unique(t))==2
                binom = 1;
                nlm = fitglm(table2array(nX(trainInd,:)),t(1,trainInd)','Distribution','binomial','PredictorVars',nX.Properties.VariableNames);
            else
                binom = 0;
                nlm = fitglm(table2array(nX(trainInd,:)),t(1,trainInd)','PredictorVars',nX.Properties.VariableNames);
            end
            
            if psig
                psig = nlm.Coefficients.pValue(2:end)<0.05;
                %
            end
            if ica >1
                if psig
                    X = array2table(fastica(x(psig,:),'NumOfIC',ica)');
                else
                    X = array2table(fastica(x,'NumOfIC',ica)');
                end
            else
                if psig
                [coeff,score,latent,tsquared,explained]=pca(x(psig,:));
                else
                  [coeff,score,latent,tsquared,explained]=pca(x);
                end
                
                for a =1:length(explained)
                    e(a) =sum(explained(1:a));
                end
                ie=wjn_sc(e,95);
                X = array2table(coeff(:,1:ie));
                
            end
            
            if numel(unique(t))==2
                lm = fitglm(table2array(X(trainInd,:)),t(1,trainInd)','Distribution','binomial','PredictorVars',X.Properties.VariableNames);
            else
                
                lm = fitglm(table2array(X(trainInd,:)),t(1,trainInd)','PredictorVars',X.Properties.VariableNames);
            end
            
            
        end
        lm_full_mse = wjn_mse(t',lm.predict(table2array(X)));
        lm_val_mse = wjn_mse(t(valI)',lm.predict(table2array(X(valI,:))));
        
        labels = X.Properties.VariableNames;
        if psig
            psig = lm.Coefficients.pValue(2:end)<0.05;
            X = X(:,psig);
        end
        %         keyboard
        
        X = con2seq(table2array(X)');
    else
        if size(X,1)>size(X,2)
            X = con2seq(X');
        else
            X=con2seq(X);
        end
    end
end

% keyboard

% nT=size(t,1);
if istable(T)
    T = con2seq(table2array(T)');
else
    if size(T,1)>size(T,2)
        T = con2seq(T');
    else
        T=con2seq(T);
    end
end


% keyboard

if ~exist('H','var') || isempty(H)
%     if length(X{1}) < 10
%         H ={length(X{1})*2,[length(X{1})*3 length(X{1})*3 length(X{1})*3]};
%     else
%         
        H = {[length(X{1}) length(X{1}) length(X{1})]};
%     end
elseif ~iscell(H)
    H={H};
end


nrows = 1;
ncols = 0;
for a = 1:length(labels)
    if ~ica
        nlabel = stringsplit(labels{a},'_');
        if length(nlabel)==1
            nlabel={'channel' nlabel{1}};
        end
    else
        nlabel = {'Component' labels{a}(4:end)};
    end
    if a>1 && ~strcmp(nlabel{2},cf{nrows})
        nrows = nrows+1;
        ncols = 1;
    else
        ncols = ncols+1;
    end
    cel{ncols} = nlabel{1};
    if length(nlabel)>=2
        
        cf{nrows} = nlabel{2};
    else
        cf{nrows} =nlabel{1};
    end
    C(nrows,ncols) = lm.Coefficients.tStat(a+1);
    P(nrows,ncols) = lm.Coefficients.pValue(a+1);
end

if exist('nX','var')
    
    
    labels = nX.Properties.VariableNames;
    nnrows = 1;
    nncols = 0;
    for a = 1:length(labels)
        
        nnlabel = stringsplit(labels{a},'_');
        if a>1 && ~strcmp(nnlabel{2},ncf{nnrows})
            nnrows = nnrows+1;
            nncols = 1;
        else
            nncols = nncols+1;
        end
        ncel{nncols} = nnlabel{1};
        ncf{nnrows} = nnlabel{2};
        nC(nnrows,nncols) = nlm.Coefficients.tStat(a+1);
        nP(nnrows,nncols) = nlm.Coefficients.pValue(a+1);
    end
end






%%

% trainInd =trainInd(1:10:end);

% keyboard



% keyboard
clear net
n=0;
goal_met=0;
for ni =1:length(H)
    for nD = 1:length(tD)
        for Ntrials =1
            clear net
            n=n+1;
            input_params{n} ={tD(nD) H(ni)};
            % net = patternnet([length(X{1})+ni ]) ;
%             net = timedelaynet(tD{nD},H{ni}) ;
              net = distdelaynet(repmat(tD(nD),[1 size(H{ni},2)+1]),H{ni});
%             net = layrecnet(tD{nD},H{ni}) ;
%             nl = numel(net.layers);
%             for nls = 1:nl-1
%                 net.layers{nls}.transferFcn = 'poslin';
%             end
            %             if binom
            %                 net.layers{nls}.transferFcn = 'softmax';
            %             end
            net.trainFcn ='trainbr';
            %             net.trainFcn = 'trainlm';
            net.divideFcn = 'divideind';
            net.performFcn ='mse';
            [Xs,Xi,Ai,Ts] = preparets(net,X,T);
            
            %             net.divideFcn ='divideblock';
            net.divideParam.testInd=testInd;
            net.divideParam.trainInd=trainInd;
            net.divideParam.valInd = valInd;
            net.trainParam.showWindow =1;
            % net.trainFcn = 'trainbr';
            %             net.trainParam.time =5*60;
            %             net.trainParam.
            
            % net.trainParam.epochs = 1000;
            net.trainParam.max_fail=3;
            %             net.trainParam.min_grad=10^-4;
            net.trainParam.goal =goal;
            
            % net.performFcn = 'crossentropy';
            % net.performParam.regularization =0.1;
            
            % PARALLEL
            %             if pool == 1
%             keyboard
            try
                net = train(net,Xs,Ts,Xi,Ai,'useParallel','yes');
            catch
                net = train(net,Xs,Ts,Xi,Ai,'useParallel','no');
            end
            %                 %     net = train(net,X,T,'useParallel','yes');
            %                 % GPU
            %             elseif pool == 2
            %                 net = train(net,X,T,'useGPU','yes');
            %             else
            %                 net = train(net,X,T);
            %             end
            %
            % Yv =perform(net,X,T)
            
            Y=net(X);
            
            [tpr,fpr,thrs]=roc(T(valI),Y(valI));
            [m,i]=max((1-fpr)+tpr);
            thr =thrs(i);
            i99 = wjn_sc(tpr,.99);
%             keyboard
     
            nn_fpr = fpr(i);
            nn_fpr99 = fpr(i99);
            nn_tpr = tpr(i);
            
            c=wjn_mse(t(valI)',cell2mat(seq2con(Y(valI)))'>thr);
            nacc(n) = sum(1-c);
            nn_mse(n)=nanmean(c);
            disp(nn_mse)
            nets{n}=net;
            
            % keyboard
            if nacc(n) > 1-goal
                goal_met =1;
                break
            end
        end
        if goal_met
            break
        end
    end
    if goal_met
        break
    end
end



% keyboard

[nn_accuracy,inet]=max(nacc);
net =nets{inet};

L.inputs_tested =input_params;
L.nn_tpr = tpr;
L.nn_fpr = fpr;
L.nn_mse=nn_mse;
L.trainInd=trainInd;
L.valInd =valInd;
L.testInd =testInd;
%%
Y=net(X);

[tpr,fpr,thrs]=roc(T,Y);
[m,i]=max((1-fpr)+tpr);
thr =thrs(i);
            
c=wjn_mse(cell2mat(seq2con(T)),cell2mat(seq2con(Y))>thr);
nn_full_accuracy = 1-c;
nn_val_accuracy = nn_accuracy;
% thr =0.5;

Y=cell2mat(seq2con(Y));
% keyboard
figure
if ica
    subplot(1,4,1)
else
    subplot(1,3,1)
end
% keyboard
imagesc(ti,0,t)
hold on
imagesc(ti,-1,Y)

ylabels(1:2) = {'Predicted','Target'};
for a = 1:size(oX,2)
    imagesc(ti,a,table2array(oX(:,a))')
    ylabels{a+2} = strrep(labels{a},'_',' ');
end
set(gca,'YTick',[-1:a],'YTickLabel',ylabels,'YTickLabelRotation',45)
ylim([-1.5 a+.5])
hold on
if ~isempty(valInd);
    sigbar(ti(valInd),ones(size(valInd)),'r')
end
if ~isempty(testInd);
    sigbar(ti(testInd),ones(size(testInd)),'b')
end
% figone(7)
xlim([ti(1) ti(end)])

if ica
    subplot(1,4,2)
else
    subplot(1,3,2)
end


% keyboard
if numel(unique(cell2mat(seq2con(T))))==2
    
    nnlmval = fitglm(Y(valI),t(valI)','Distribution','binomial');
     nnlmfull = fitglm(Y,t','Distribution','binomial');
    plot(fpr,tpr,'LineWidth',2)
    hold on
    title({['FULL Accuracy: ' num2str(nn_full_accuracy,4)];['VAL Accuracy: ' num2str(nn_val_accuracy,4)]})
    ylabel('True positive rate')
    xlabel('False positive rate')
    
else
    nnlmfull = fitglm(Y,t');
    
    nnlmval = fitglm(Y(valI),t(valI)');
    scatter(Y,t)
    hold on
    title({['NN FULL R^2: ' num2str(nnlmfull.Rsquared.Ordinary,4)];['NN VAL R^2: ' num2str(nnlmval.Rsquared.Ordinary,4)]})
    
end

if ica
    subplot(1,4,3)
else
    subplot(1,3,3)
end
imagesc(C),set(gca,'XTick',1:length(cel),'XTickLabels',cel,'YTick',1:length(cf),'YTickLabels',cf,'XTickLabelRotation',45,'YTickLabelRotation',45)
axis xy
c=colorbar;
% keyboard
if binom
title({['LM FULL MSE: ' num2str(lm_full_mse,4)],['LM VAL MSE: ' num2str(lm_val_mse,4)]})
else
    
title(['R^2 = ' num2str(lm.Rsquared.Ordinary,2)])
end
ylabel(c,'TStat')
figone(8,30)
%%

if ica
    subplot(1,4,4)
    imagesc(nC),set(gca,'XTick',1:length(ncel),'XTickLabels',ncel,'YTick',1:length(ncf),'YTickLabels',ncf,'XTickLabelRotation',45,'YTickLabelRotation',45)
    axis xy
    c=colorbar;
    % keyboard
    nlm_mse = wjn_mse(t',nlm.predict(nX));
    title(['LM MSE: ' num2str(nlm_mse,4)])
    % title(['R� = ' num2str(lm.Rsquared.Ordinary,2)])
    ylabel(c,'TStat')
    
    L.non_ica_lm =nlm;
    L.nlm_mse=nlm_mse;
    L.non_ica_Tstat =nC;
    L.non_ica_Pstat=nP;
    figone(8,40)
end


L.lm = lm;
L.nn_full_accuracy = nn_full_accuracy;
L.nn_val_accuracy = nn_val_accuracy;
L.lm_full_mse = lm_full_mse;
L.lm_val_mse = lm_val_mse;
L.lm_full_accuracy = 1-lm_full_mse;
L.lm_val_accuracy = 1-lm_val_mse;
L.Tstat = C;
L.Pstat = P;
[L.maxTstat,L.maxTstat_contact] = max(sum(abs(C)));
L.electrodes = cel;
L.frequencies = cf;
L.lmR = lm.Rsquared.Ordinary;
% L.X = tX;
L.T = cell2mat(seq2con(T))';
L.Y = Y;
L.nn_tpr = nn_tpr;
L.nn_fpr = nn_fpr;
L.nn_fpr99 = nn_fpr99;
L.valI = valI;
L.net = net;
L.nnlmfull = nnlmfull;
L.nnlmval = nnlmval;
L.nnRfull = L.nnlmfull.Rsquared.Ordinary;
L.nnRval = L.nnlmval.Rsquared.Ordinary;
L.thr = thr;

