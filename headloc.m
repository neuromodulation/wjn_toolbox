function [Dh,hr]=headloc(file,new_file)
    if new_file
    D= spm_eeg_load(file);
    S=[];
    S.D = fullfile(D.path,D.fname);
    S.outfile = fullfile(D.path,['h' D.fname]);
    Dh=spm_eeg_copy(S);
    else 
        Dh = spm_eeg_load(file);
    end
    bt =[];
    if ~isfield(Dh.origheader,'hc')
        if isfield(Dh,'origheader') && length(Dh.origheader) > 1;
            Dh.origheader = Dh.origheader{1};
%         elseif isfield(Dh,'origheader') && numel(Dh.origheader) == 1
        else
            warning('No Head Location data');
            hr ='no_hc'
            return
        end
      
    end
    if isfield(Dh,'fileind')  
        for a = 1:max(Dh.fileind);
            ind = find(Dh.fileind == a);
            S = [];
            S.D = Dh;
            S.save = 1;
            S.rejectbetween = 1;
            S.threshold = 0.01;
            S.rejectwithin = 1;
            S.trialthresh = 0.01;
            S.correctsens = 1;
            S.toplot = 1;
            S.losttrack = 'reject';
            S.trialind = ind;
            Dh = spm_eeg_megheadloc(S);
            hr{a}.bt = find(Dh.badtrials(ind));
            Dh = badtrials(Dh,'(:)',0);
            if sum(hr{a}.bt)>=1;
                bt = [bt ind(hr{a}.bt)];
                disp(['Trials ' num2str(ind(hr{a}.bt)) ' rejected.'])
            else
                disp('No trials rejected.')
            end
                       
        end
        Dh = badtrials(Dh,bt,1);
        disp(['Trials ' num2str(bt) ' rejected.'])
        save(Dh);
    else
        for a = 1:length(Dh.conditions);
            ind = D.indtrial(Dh.condlist{a});
                   S = [];
            S.D = Dh;
            S.save = 1;
            S.rejectbetween = 1;
            S.threshold = 0.01;
            S.rejectwithin = 1;
            S.trialthresh = 0.01;
            S.correctsens = 1;
            S.toplot = 1;
            S.losttrack = 'reject';
            S.trialind = ind;
            Dh = spm_eeg_megheadloc(S);
            hr{a}.bt = find(Dh.badtrials(ind));
            Dh = badtrials(Dh,'(:)',0);
            if sum(hr{a}.bt)>=1;
                bt = [bt ind(hr{a}.bt)];
                disp(['Trials ' num2str(ind(hr{a}.bt)) ' rejected.'])
            else
                disp('No trials rejected.')
            end
                       
        end
        Dh = badtrials(Dh,bt,1);
        disp(['Trials ' num2str(bt) ' rejected.'])
        save(Dh);
    end
            
%     if ~isempty(bt)
%             S=[];
%             S.D = fullfile(Dh.path,Dh.fname);
%             D=spm_eeg_remove_bad_trials(S)
%     else disp('Head location correction did not remove any trials.');
%     
%     end