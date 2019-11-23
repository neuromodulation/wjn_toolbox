% setpref('Internet','SMTP_Server','www.fil.ion.ucl.ac.uk');
% setpref('Internet','E_mail','litvak.vladimir@gmail.com');
spm('defaults', 'eeg');
% 38 nochmal
% 31 rest nochmal
bands = {[8 12], [13 20], [20 35]};%
% emo=[29 31 32 33 34 37 38 41 42 43 44 ]
missing = [35 36 39]
ntrl = nan(26, 2);


for s = missing
    ind = num2str(s);
    if length(ind) == 1
        ind = ['0' ind];
    end
    initials = ['PLFP' ind];
    for on = 0:1
        try
            D = dbs_meg_rest_prepare_spm12(initials, on);
            
            %             if ~isempty(D)
            %                 ntrl(s, on+1) = D.ntrials;
            
            %             for b = 1:numel(bands)
            %                 dbs_meg_dics_bootstrap(initials, on, bands{b});
            %             end
            %             end
%             D = dbs_meg_extraction_prepare_spm12(initials, on, 'EMOT');
%             if ~isempty(D)
%                 dbs_meg_task_source(initials, on)
%             end
%             
%             for b = 1:numel(bands)
%                 dbs_meg_dics_bootstrap(initials, on, bands{b});
%             end
%             
            %
            fclose all;
        catch
            disp([num2str(s) ' crashed.'])
            %   sendmail('litvak.vladimir@gmail.com', ['Crashed subject ' subjects{s}], lasterr);
        end
    end
%     try
%         %  sendmail('litvak.vladimir@gmail.com', ['Completed subject ' subjects{s}]);
%     end
end

% sendmail('litvak.vladimir@gmail.com', 'Done');
