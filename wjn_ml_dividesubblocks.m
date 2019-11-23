function [trainInd,valInd,testInd] = wjn_ml_dividesubblocks(Q,nblocks,trainRatio,valRatio,testRatio)

if ~exist('trainRatio','var')
    trainRatio = .7;
    valRatio = .15;
    testRatio = .15;
end

if ~exist('nblocks','var')
    nblocks = 10;
end

sQ = floor(Q/(2*nblocks));
sV = floor(sQ.*valRatio);
sT = floor(sQ*testRatio);
trainInd = [];
valInd = [];
testInd = [];

for a = 1:(nblocks*2)
    nsq = 1:sQ;
    if ~iseven(a)
        isV = randi(sQ-2*sV-1,1)+(a-1)*sQ;     
        valInd = [valInd isV:isV+sV-1];
    else
        isT = randi(sQ-2*sT-1,1)+(a-1)*sQ;     
        testInd = [testInd isT:isT+sT-1];
    end
end

dummy = ones(1,Q);
dummy([valInd,testInd]) = 0;
trainInd = find(dummy);
