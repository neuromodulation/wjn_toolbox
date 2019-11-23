function [net,Y,L] = wjn_nn_timedelay(X,T,par,ica)

if ~exist('ica','var')
    ica = 0;
elseif ica == 1
    ica = 10;
end




if ~iscell(X)
    if istable(X)
        if ica
            x = table2array(X)';
%             X = array2table(fastica(x,'NumOfIC',ica)');
              X = array2table(pca(x,'NumComponents',ica));
        end
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

lm=fitlm(tX.Variables,cell2mat(seq2con(T))','PredictorVars',tX.Properties.VariableNames);
labels = tX.Properties.VariableNames;
nrows = 1;
ncols = 0;
for a = 1:length(labels)
    if ~ica
    nlabel = stringsplit(labels{a},'_');
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
    cf{nrows} = nlabel{2};
    C(nrows,ncols) = lm.Coefficients.tStat(a+1);
    
    P(nrows,ncols) = lm.Coefficients.pValue(a+1);
end



figure
imagesc(C),set(gca,'XTick',1:length(cel),'XTickLabels',cel,'YTick',1:length(cf),'YTickLabels',cf,'XTickLabelRotation',45,'YTickLabelRotation',45)
axis xy
c=colorbar;
title(['R� = ' num2str(lm.Rsquared.Ordinary,2)])
c=colorbar;
ylabel(c,'TStat')
figone(7)



Q = length(T);
trainRatio = 0.7;
valRatio = .15;
testRatio = .15;
[trainInd,valInd,testInd] = wjn_ml_dividesubblocks(Q,10,trainRatio,valRatio,testRatio);
net = timedelaynet([0 40],[length(X{1})  3]) ; 
net.divideFcn = 'divideind';
net.divideParam.testInd=testInd;
net.divideParam.trainInd=trainInd;
net.divideParam.valInd = valInd;
net.trainFcn = 'trainbr';
net.trainFcn = 'trainlm';
net.trainParam.epochs = 5000;
[Xs,Xi,Ai,Ts] = preparets(net,X,T); 

if exist('par','var')
    try 
        par.NumWorkers;
        pool = 1;
    catch
        try 
            par.Connected;
            pool = 2;
        catch
            pool = 0;
        end
    end
else
    pool = 0;
end
    
    
% PARALLEL
if pool == 1
% pool = parpool;
% pool.NumWorkers = 4;
    net = train(net,Xs,Ts,Xi,Ai,'useParallel','yes','showResources','yes');
% GPU
elseif pool == 2
% gpu1 = gpuDevice(1)
    net = train(net,Xs,Ts,Xi,Ai,'useGPU','yes','showResources','yes');
else
    net = train(net,Xs,Ts,Xi,Ai);  
end

% net = train(net,Xs,Ts,Xi,Ai);
Y = cell2mat(seq2con(net(X)))';



L.lm = lm;
L.Tstat = C;
L.Pstat = P;
[L.maxTstat,L.maxTstat_contact] = max(sum(abs(C)));
[L.mC,L.bC] = max(sum(abs(C)));
L.electrodes = cel;
L.frequencies = cf;
L.R = sqrt(lm.Rsquared.Ordinary);
L.X = tX;
L.T = cell2mat(seq2con(T))';
L.Y = Y;
L.nnlm = fitlm(L.T,Y);
L.nnR = sqrt(L.nnlm.Rsquared.Ordinary);


