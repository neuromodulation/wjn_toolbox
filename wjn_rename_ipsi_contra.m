function D=wjn_rename_ipsi_contra(filename,side)

sides = {'L','R'};

if strcmpi(side,'L')
    s = 1;
    cs = 2;
    ic = ['IC'];
elseif strcmpi(side,'R')
    s=2;
    cs = 1;  
    ic = ['CI'];
end

D=spm_eeg_load(filename);

D=wjn_spm_copy(D.fname,['rc' side D.fname]);

D.ochans = D.chanlabels;
ct = D.chantype;
chs = D.chanlabels;
nchs = [];
for a = 1:length(D.chanlabels)
    try
        x = ci(chs{a}(end-2),sides);
    catch
        x=[];
    end
    if ~isempty(x)
        nchs{a} = [chs{a}(1:end-3) ic(x) chs{a}(end-1:end)];
    else
        nchs{a} = chs{a};
    end
end

D=chanlabels(D,':',nchs);
save(D);
        





