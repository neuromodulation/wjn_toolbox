function D=wjn_ecog_rereference(filename)

D=wjn_sl(filename);

ech = ci('ECOG',D.chanlabels);

for a = 1:length(ech)
    chans{a}=D.chanlabels{ech(a)}(~isstrprop(D.chanlabels{ech(a)},'digit'));
    nums{a} = D.chanlabels{ech(a)}(isstrprop(D.chanlabels{ech(a)},'digit'))
end

strips = unique(chans);
allavgchans = {};
allbpchans={};
allavgdata=[];
allbpdata=[];
for ns = 1:length(strips)
    ech = ci(strips{ns},D.chanlabels);
    cavgchans= [strcat({'c_'},D.chanlabels(ech)),['cavg_' strips{ns}]];
    cavgdata=[];
    bpdata=[];
    bpchans={};
    s = D(ech,:,1);
    cavg = mean(s);
    cavgdata = [s - cavg;cavg];
    
    chs = D.chanlabels(ech);
    nbipolar = 0;
    d=[];
    for a = 1:length(ech)-1
        if str2num(chs{a}(end))<str2num(chs{a+1}(end))
            nbipolar=nbipolar+1;
            bpchans{nbipolar} = ['bip_' strips{ns} nums{a} '-' nums{a+1}];
            bpdata(nbipolar,:) = D(ech(a),:)-D(ech(a+1),:);
        end
    end
    allavgchans = [allavgchans cavgchans];
    allbpchans = [allbpchans bpchans];
    allavgdata = [allavgdata;cavgdata];
    allbpdata = [allbpdata;bpdata];
end
allchans = [allavgchans allbpchans];
D=wjn_add_channels(D.fullfile,[allavgdata;allbpdata],allchans);
D=chantype(D,ci(allchans,D.chanlabels),'LFP');
save(D)
