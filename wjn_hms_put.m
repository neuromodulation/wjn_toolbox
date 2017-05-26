function command_output = wjn_hms_put(FILE,PATH)

addpath(fullfile(getsystem,'ssh2'))



HOSTNAME = 'orchestra.med.harvard.edu';
USERNAME = 'agh14';
PASSWORD = 'Skrebba$42';


if isdir(FILE)
    command_output = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,['mkdir ' wjn_hms_dirs('scratch') FILE] ,1);
    cd(FILE)
    files=ffind(['*.*']);
    for a = 1:length(files)
        
        if ~ismember(files{a},{'.','..','.dropbox'}) && ~isdir(files{a})
            try
             ssh2_conn = sftp_simple_put(HOSTNAME,USERNAME,PASSWORD,files{a},[PATH,FILE]);
             disp([num2str(a) ' ... ' files{a} ' copied!']);
            catch
                disp([files{a} ' did not copy!']);
            end
        end
    end
    command_output = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,['ls ' PATH FILE] ,1);
    cd('..')
else
        
        
ssh2_conn = sftp_simple_put(HOSTNAME,USERNAME,PASSWORD,FILE,PATH);
command_output = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,['ls ' PATH] ,1);
end
