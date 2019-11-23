function nn=wjn_nn_feedforward(X,T,H,testInd)
%%

if size(T,2)<size(T,1)
    T=T';
end

if size(X,2)<size(X,1)
    X=X';
end


inan=find(nansum([isnan(X);isnan(T)]));
% keyboard
tl = length(T);
T(inan)=[];
X(:,inan)=[];



if ~exist('testInd','var')
rI = randperm(length(T));
tI=1:floor(length(T).*0.8);
vI=max(tI)+1:length(T);
trainInd = rI(tI);
valInd = rI(vI);
testInd = valInd;
else
%     keyboard
    tl=zeros(1,tl);
    tl(testInd)=1;
    tl(inan) = [];
    testInd = find(tl);
    trainInd = setdiff(1:length(T),testInd);
    valInd = testInd;
end


figure
subplot(1,4,1)
nn.mlm = fitlm(X',T');
mybar(nn.mlm.Coefficients.tStat(2:end)')
subplot(1,4,2)
wjn_corr_plot(nn.mlm.predict(X'),T','r',0)

% [trainInd,valInd,testInd]=wjn_ml_dividesubblocks(length(T),10,0.6,0.4,0);

net = feedforwardnet(H,'trainbr');

            net.performFcn ='mse';
            net.divideFcn = 'divideind';
%             net.divideParam.testInd=valInd;
%                      nl = numel(net.layers);
%             for nls = 1:nl-1
%                 net.layers{nls}.transferFcn = 'poslin';
%             end
            net.divideParam.trainInd=trainInd;
            net.divideParam.testInd =valInd;
%             net.divideParam.valInd =valInd;
            net.trainParam.showWindow =1;
            net.trainParam.max_fail=0;
            net.trainParam.goal =0;
            net.trainParam.epochs = 5000;
            net = train(net,X,T,'useParallel','yes');
            pY=net(X);
            

            subplot(1,4,3)
            nn.nnlm = fitlm(pY',T');
            wjn_corr_plot(nn.nnlm.predict(pY'),T','r',0)
            title(['N = ' num2str(length(pY))])
            
            subplot(1,4,4)
            nn.nnvlm = fitlm(pY(valInd),T(valInd));
            wjn_corr_plot(nn.nnvlm.predict(pY(valInd)'),T(valInd)','r',0)
            title(['N = ' num2str(length(valInd))])
            figone(10,30)
            nn.valInd = valInd;
            nn.trainInd = trainInd;
            nn.pY=pY;
            nn.T=T;
            nn.X=X;
            nn.net = net;
            nn.H=H;
%             set(gca,'XLabel','Target','YLabel','Prediction')
%             figure
%             scatter(T(valInd),pY(valInd))
            
            