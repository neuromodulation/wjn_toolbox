function D=wjn_eeg_epoch_autoreject(filename,timewin,trl,conds)

D=spm_eeg_load(filename);
disp('AUTOREJECT!')
fname = D.fname;
outname = strrep(fullfile(D.path,[fname(1:end-4) '_raw.fif']),'\','/');
chans = D.indchantype('eeg');
data = D.ftraw(chans);fieldtrip2fiff(outname,data);f=fopen(fullfile(getsystem,'autoreject.txt'),'w+');fprintf(f,outname);fclose(f);


if ~exist('trl','var')
   ev = D.events(:);   
   i = ci('Stimulus',{ev(:).type});
   [conds,~,event_id] = unique({ev(i).value});
   disp(conds);
   conds = conds(event_id)';
   trl = [ev(i).time]';
   ii = ci('DC',{ev(:).type});
   iit = [ev(ii).time]';
   
   for a=1:length(trl)
       bt(a)=any(iit>(trl(a)+timewin(1)-.5)&iit<(trl(a)+timewin(2)+.5));
   end
   
   ni = setdiff(1:length(trl),find(bt));
   trl = trl(ni);
   conds = conds(ni);
   event_id = event_id(ni);
end


ntrl = D.indsample(trl+timewin(1))';
T=table;
T.trl = [ntrl ones(size(ntrl)).*(timewin(2)-timewin(1)) event_id];
writetable(T,fullfile(D.path,'autoreject_trl.csv'));

command = ['python "' strrep(getsystem,'\','/') 'wjn_py_autoreject_events.py"'];
system(command) 
De=wjn_epoch(D.fullfile,timewin,conds,trl);
%De=spm_eeg_load(fullfile(D.path,['e' D.fname]));
ar = load(fullfile(D.path,'autoreject.mat'));

De=badchannels(De,chans(sum(ar.rejection_matrix(~ar.bad_epochs,:)==1)./sum(~ar.bad_epochs)>0.2),1);
De(chans,:,:) = shiftdim(ar.rdata,1);
n=0;
for a = 1:De.ntrials
    if ar.bad_epochs(a)
        De=badtrials(De,a,1);
    else
        n=n+1;
        De(chans,:,a) = squeeze(ar.cdata(n,:,:));
    end
end

ar = rmfield(ar,{'cdata','rdata'});
De.autoreject = ar;
De.autoreject.nbadchannels = numel(De.badchannels);
De.autoreject.nbadtrials = numel(find(De.autoreject.bad_epochs));
save(De);

D=wjn_remove_bad_trials(De.fullfile);
    






