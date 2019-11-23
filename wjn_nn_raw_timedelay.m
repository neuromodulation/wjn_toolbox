function [mdl,net]=wjn_nn_raw_timedelay(X,T,delays,nodes,nsubblocks,trainRatio)


if ~exist('delays','var') || isempty(delays)
    delays = 1:5;
end

if ~exist('nodes','var')
    nodes = [10 10];
end

if ~exist('nsubblocks','var')
    nsubblocks = 5;
end

if ~exist('trainRatio','var')
    trainRatio = 0.7;
    valRatio = .15;
    testRatio = .15;
else
    valRatio = (1-trainRatio)/2;
    testRatio = (1-trainRatio)/2;
end


[trainInd,valInd,testInd] = wjn_ml_dividesubblocks(length(T),nsubblocks,trainRatio,valRatio,testRatio);

mdl.trainInd = trainInd;
mdl.valInd = valInd;
mdl.testInd = testInd;

figure
plot(1:length(T),T);
hold on
b(1)=sigbar(trainInd,ones(size(trainInd)),'g');
hold on
b(2)=sigbar(valInd,ones(size(valInd)),'y');
b(3)=sigbar(testInd,ones(size(testInd)),'r');
plot(1:length(T),T,'color','k');

legend(b,{'training','validation','test'});
figone(7)
ylabel('T')
xlabel('samples [n]')

if iscell(delays)
net = distdelaynet(delays,nodes);
else
net = timedelaynet(delays,nodes) ; 
end

% 
% for a =1:length(net.layers)-1
%     net.layers{a}.transferFcn = 'poslin';
% end
%net.layers{end}.transferFcn = 'tansig';


net.divideFcn = 'divideind';
net.divideParam.testInd=testInd;
net.divideParam.trainInd=trainInd;
net.divideParam.valInd = valInd;
net.trainFcn = 'trainlm';
net.trainParam.showCommandLine = true;
net.trainParam.showWindow = 1;
net.trainParam.max_fail = 10;
% 
% 
% net = patternnet(nodes,'trainscg','crossentropy');
% net=train(net,con2seq(X'),con2seq(T'>0.05))
% net.trainFcn = 'trainbr';
% net=train(net,con2seq(X'),con2seq(T'>0.05))



[Xs,Xi,Ai,Ts] = preparets(net,con2seq(X'),con2seq(T'));
mdl.Xs = Xs;
mdl.Xi = Xi;
mdl.Ai = Ai;
mdl.Ts = Ts;
mdl.X=X;
mdl.T=T;
mdl.preparets='preparets(net,con2seq(X''),con2seq(T''))';
net.performFcn = 'mse';
net = train(net,Xs,Ts,Xi,Ai,'useParallel','yes','showResources','yes');
net.trainFcn = 'trainbr';
net.trainParam.time = 600;
net.trainParam.epochs = 10000;
net.performFcn = 'mse';
%net.trainParam.max_fail = 10;
net = train(net,Xs,Ts,Xi,Ai,'useParallel','yes','showResources','yes');

mdl.net = net;
mdl.train = 'train(net,Xs,Ts,Xi,Ai,''useParallel'',''yes'',''showResources'',''yes'')';
mdl.predict = net(X')';
