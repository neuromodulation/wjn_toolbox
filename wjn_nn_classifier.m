function [net,Y,L] = wjn_nn_classifier(X,T,ica,H,tD,goal,lockindices)
% [net,Y,thr] = wjn_nn_classifier(X,T,parallel,trainfcn)


if ~exist('lockindices','var')
    lockindices=0;
end

if ~exist('ica','var') || isempty(ica)
    ica = 0;

end


if ~iscell(X)
    if istable(X)
        if ica
            x = table2array(X)';
%             if size(X,2)<30
            nX = X;
%             end
            if ica >1
                  X = array2table(fastica(x,'NumOfIC',ica)');
            else
               
            
            [coeff,score,latent,tsquared,explained]=pca(x);
            
            for a =1:length(explained)
                e(a) =sum(explained(1:a));
            end
            ie=wjn_sc(e,95);
            X = array2table(coeff(:,1:ie));
            
            end
            
        end
%         keyboard
        tX = X;
        X = con2seq(table2array(X)');
    else
        if size(X,1)>size(X,2)
            X = con2seq(X');
        else
            X=con2seq(X);
        end
    end
end
if size(T,2)<size(T,1)
    T=T';
end
t=T;
nT=size(t,1);
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
if numel(unique(cell2mat(seq2con(T))))==2
    lm = fitglm(tX.Variables,t(1,:)','Distribution','binomial','PredictorVars',tX.Properties.VariableNames);
else
    
    lm = fitglm(tX.Variables,t(1,:)','PredictorVars',tX.Properties.VariableNames);
end

labels = tX.Properties.VariableNames;
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
    
    if numel(unique(cell2mat(seq2con(T))))==2
        nlm = fitglm(nX.Variables,cell2mat(seq2con(T))','Distribution','binomial','PredictorVars',nX.Properties.VariableNames);
    else
        nlm = fitglm(nX.Variables,cell2mat(seq2con(T))','PredictorVars',nX.Properties.VariableNames);
    end
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


Q = length(T);
trainRatio = 0.8;
valRatio = .2;
testRatio = 0;
[trainInd,valInd,testInd] = wjn_ml_dividesubblocks(Q,2,trainRatio,valRatio,testRatio);
if lockindices
    try
        load nn_lockindices
    catch
        warning('no index file found. storing new one')
        save('nn_lockindices','trainInd','valInd','testInd');
        
    end
end
% trainInd =trainInd(1:10:end);

% keyboard


if ~exist('H','var') || isempty(tD)
    if length(X{1}) < 10
        H ={length(X{1})*2,[length(X{1})*3 length(X{1})*3 length(X{1})*3]};
    else

        H = {[length(X{1})]};
    end
elseif ~iscell(H)
            H={H};
end

if ~exist('tD','var') || isempty(tD)
    tD ={80,80:40:200, 0:40:200};
elseif ~iscell(tD)
    tD={tD};
end

if ~exist('goal','var') || isempty(goal)
    goal =0.01;
end


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
            net = timedelaynet(tD{nD},H{ni}) ;
            net.trainFcn ='trainbr';
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
            net.trainParam.max_fail=6;
            net.trainParam.min_grad=10^-4;
            net.trainParam.goal =goal;
            
            % net.performFcn = 'crossentropy';
            % net.performParam.regularization =0.1;
            
            % PARALLEL
            %             if pool == 1
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
            [tpr,fpr,thrs]=roc(T,Y);
            % [m,i]=max(min(1-tpr,fpr))
            % thr =thrs(i);
            
            
            c=wjn_mse(t',cell2mat(seq2con(Y))');
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

L.inputs_tested =input_params;
L.nn_acc = nacc;
L.nn_mse=nn_mse;
L.trainInd=trainInd;
L.valInd =valInd;
L.testInd =testInd;

% keyboard

[nn_accuracy,inet]=max(nacc);
net =nets{inet};
%%
Y=net(X);

[tpr,fpr,thrs]=roc(T,Y);
c=wjn_mse(cell2mat(seq2con(T)),cell2mat(seq2con(Y)));
nn_accuracy = 1-c
thr =0.5;

Y=cell2mat(seq2con(Y));
% keyboard
figure
if ica
    subplot(1,3,1)
else
    subplot(1,2,1)
end

if numel(unique(cell2mat(seq2con(T))))==2
    nnlm = fitglm(Y,t','Distribution','binomial');
    plot(fpr,tpr,'LineWidth',2)
    hold on
    title(['NN Accuracy: ' num2str(nn_accuracy,4)])
    ylabel('True positive rate')
    xlabel('False positive rate')
    
else
    nnlm = fitglm(Y,t');
    scatter(Y,t)
    hold on
    title(['NN MSE: ' num2str(nn_mse,4)])
    
end

if ica
    subplot(1,3,2)
else
    subplot(1,2,2)
end
imagesc(C),set(gca,'XTick',1:length(cel),'XTickLabels',cel,'YTick',1:length(cf),'YTickLabels',cf,'XTickLabelRotation',45,'YTickLabelRotation',45)
axis xy
c=colorbar;
% keyboard
lm_mse = wjn_mse(t',lm.predict(tX));
title(['LM MSE: ' num2str(lm_mse,4)])
% title(['R� = ' num2str(lm.Rsquared.Ordinary,2)])
ylabel(c,'TStat')
%%

if ica
    subplot(1,3,3)
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
end


L.lm = lm;
L.nn_accuracy = nn_accuracy;
L.lm_mse = lm_mse;
L.Tstat = C;
L.Pstat = P;
[L.maxTstat,L.maxTstat_contact] = max(sum(abs(C)));
L.electrodes = cel;
L.frequencies = cf;
L.R = sqrt(lm.Rsquared.Ordinary);
% L.X = tX;
L.T = cell2mat(seq2con(T))';
L.Y = Y;
L.nnlm = nnlm;
L.nnR = sqrt(L.nnlm.Rsquared.Ordinary);
L.thr = thr;

