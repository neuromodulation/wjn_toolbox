function [outname,chans] = wjn_spm2mne(filename)

D=spm_eeg_load(filename);

if strcmp(filename(end-3:end),'.mat')
    filename = filename(1:end-4);
end


if strcmp(D.type,'continuous')
    outname = strrep([filename '_raw.fif'],'\','/');
    chans = D.indchantype('eeg');
    data = D.ftraw(chans);
    fieldtrip2fiff(outname,data)
    
    if ~isempty(D.events)
        events = D.events;
        i = ci('Stimulus',{events(:).type});
        conds = {events(i).value}';
        trl = D.indsample([events(i).time])';
        T=table;
%         T.conds = conds;
        [~,~,inds]=unique(conds);
        T.trl = [trl zeros(size(trl)) inds];
        writetable(T,fullfile(D.path,'trl.csv'));
    end
    

elseif strcmp(D.type,'single')
    error('not implemented')
    outname = strrep(fullfile(D.path,['ftdata_' D.fname]),'\','/');
    chans = D.indchantype('eeg');
    data = D.fttimelock(chans);
    
    save(outname,'data')
    ndata = data;
    ndata.trial=data.trial(1);
    ndata.time = data.time(1);
    ndata = rmfield(ndata,'trialinfo');
    fieldtrip2fiff([outname(1:end-4) '.fif'],ndata)
end