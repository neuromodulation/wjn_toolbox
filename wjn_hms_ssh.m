function wjn_hms_ssh(input,q,W)
HOSTNAME = 'orchestra.med.harvard.edu';
USERNAME = 'agh14';
PASSWORD = 'Skrebba$42';
addpath(fullfile(getsystem,'ssh2'))

if ~exist('q','var')
    q = 'short';
    W = '12:00';
end

% cmdstring=['cd ',folder,' && bsub -q ' q '-W ' W ' -R "rusage[mem=8000]" -o ',...
%     [folder,filesep,'job'],'.out -e ',[folder,filesep,'job'],'.err matlab -singleCompThread -nodisplay -r "' input '"'];
repfile =  strrep(strrep(strrep(input,' ' ,'_'),'.','_'),'/','_');
cmdstring=['bsub -q ' q ' -W ' W ' -R "rusage[mem=8000]" -o ' repfile '.out -e ' repfile '.err matlab -singleCompThread -nojvm -nodesktop -r "' input '"'];



% command_output = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,cmdstring,1);

 t=['plink.exe agh14@orchestra.med.harvard.edu -pw Skrebba$42 ' cmdstring];
 mf = getsystem;
 [s,r]=system(fullfile(mf,t))