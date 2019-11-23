function nD=wjn_lfp_rereference(filename)



D=wjn_sl(filename);

ech = D.indchantype('LFP');

s=[];
d=[];
bpnames={};
s = D(ech,:,1);
cavg = mean(s);
s = s - cavg;
s=  [cavg - mean(s);s];
chs = [D.chanlabels{ech(1)}(1:end-1) D.chanlabels(ech)];
if isempty(str2num(chs{1}(end)))
    chs{1} = [chs{1} '1'];
end
nbipolar = 0;
for a = 1:size(s,1)-1
    if str2num(chs{a}(end))<str2num(chs{a+1}(end))
        nbipolar=nbipolar+1;
        bpnames{nbipolar} = [chs{a}(~isstrprop(chs{a},'digit')) chs{a}(end) chs{a+1}(end)];
        d(nbipolar,:) = s(a,:)-s(a+1,:);
    end
end

ichannels = 1:D.nchannels;
% ichannels(ech) = [];
nchannels = D.nchannels;

nD=clone(D,['rr' D.fname],[nchannels+size(s,1)+size(d,1) D.nsamples D.ntrials]);

nD(:,:,1) = [squeeze(D(ichannels,:,1));s;d];

for a = 1:nchannels
    if ismember(a,ech)
        nD = chanlabels(nD,a,['o' D.chanlabels{ichannels(a)}]);
    else
        nD = chanlabels(nD,a,[D.chanlabels{ichannels(a)}]);
    end
end


nD=chanlabels(nD,nchannels+1,D.chanlabels{ech(1)}(1:end-1));

for a = 1:size(s,1)-1
    if strcmp(D.chanlabels{ech(a)}(end-1),'1')
        nD=chanlabels(nD,nchannels+1+a,D.chanlabels{ech(a)}([1:end-2 end]));
    else
        nD=chanlabels(nD,nchannels+1+a,D.chanlabels{ech(a)});
    end
%     nD=chanlabels(nD,nchannels+size(s,1)+a,[nD.chanlabels{nchannels+a} nD.chanlabels{nchannels+a+1}(end)]);
end
nD=chanlabels(nD,nchannels+2+a:nD.nchannels,bpnames);
nD = chantype(nD,1:nchannels,D.chantype(ichannels));
nD = chantype(nD,nchannels+1:nD.nchannels,'LFP');
save(nD)