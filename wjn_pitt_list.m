function [output,p]=wjn_pitt_list(n,input,options,name)

fs = 25;
timewindow = [-5 5];
freqwindow = [2 5 7 10 13] ;
robust = 1;
fsmooth = 3;
tsmooth = 100;
artefact_threshold = 200;

root = 'H:\';

drug = {'off','on'};
stim = {'off','on'};
%%

p{1}.n = 1;
p{1}.new_id = 'DBS4017';
p{1}.old_id = 'JD021815';
p{1}.rawdata = fullfile(root,'preproc','JD05_RT.mat');
p{1}.group = 'LFP-ECOG';
p{1}.diagnosis = 'PD';
p{1}.age = 60;
p{1}.MMSE = 30;
p{1}.ecog_hemisphere = 'right';
p{1}.mni_ecogR = [37.318174	-48.61012664	61.79765474
                40.1598943	-37.31592983	64.31171618
                40.94303578	-27.21778456	64.09518408
                39.78395522	-17.00523081	63.86618136
                39.68813641	-5.528024572	61.68254254
                37.51915924	4.304913414	    60.54126355];
p{1}.mni_STNR = [   11.8281  -15.1597   -7.7691
                   12.3908  -14.2925   -5.9368
                   12.9308  -13.4128   -4.0917
                   13.4446  -12.5267   -2.2426];
p{1}.mni_STNL = [  -12.1688  -14.6031   -8.9576
                  -12.6636  -13.5181   -7.1735
                  -13.1422  -12.4594   -5.3876
                  -13.6026  -11.4016   -3.6090];


for a =1:length(p)
    ids{a} = p{a}.new_id;
end

if exist('n','var') && ischar(n)
    i = ci(n,ids);
    if ~isempty(i)
        output = i;
        return
    end
end



pfields={};
for a =1:length(p)
    pfields = [pfields;fieldnames(p{a})];
end


% keyboard
allfields = unique(pfields);
if exist('n','var') 
    if isnumeric(n) && ~exist('input','var') && n >=1
        output = p{n};
        return
    elseif isnumeric(n) && n >=1 && ismember(input,fieldnames(p{n}))
        output = p{n}.(input);
        return
    elseif isnumeric(n) && n >=1 && isfield(p{n},'drug') && ismember(input,fieldnames(p{n}.('drug')))
        output = p{n}.(drug).(input);
        return
    elseif isnumeric(n) && n >=1 && ismember(input,allfields) && ~ismember(input,fieldnames(p{n}))
        output = 0;
        return
    elseif isstruct(n) && exist('input','var')
        n = ci(n.id,ids);
    elseif ~isnumeric(n)
        input = n;
    end
        switch input
           
            case 'list'
                nn=0;
                for a=1:length(p)
                    if p{a}.n>0
                        nn=nn+1;
                        output{nn,3} = p{a}.id;
                        output{nn,1} = a;
                        output{nn,2} = nn;
                    end
                end
            case 'root'
                output = root;         
            case 'dataroot'
                output = fullfile(p{n}.root,p{n}.id,'data');
            case 'savefile'
%                 output = fullfile(mdf,folder,'options',[p{n}.id '_' drug '_options.mat']);
            case 'addscript'
%                 edit(fullfile(mdf,folder,'scripts',options));
            case 'save'
                eval([name '=options'])
                save(bi(n,'savefile'),name,'-append')
            case 'load'
                load(bi(n,'savefile'),options)  
            case 'raw'
%                 output = ['r_' p{n}.id '_' drug '_cme.mat'];
            case 'folder'
                output = fullfile(mdf,folder);
            case 'figures'
                output = fullfile(mdf,folder,'figures');
            case 'options'
                output = fullfile(mdf,folder,'options');
            case 'fs'
                output = fs;
            case 'timewindow'
                output = timewindow;
            case 'freqwindow'
                output = freqwindow;
            case 'spmfile'
                    output = ['rraespmeeg_' p{n}.task_eeg(1:end-4) '.mat'];
            case 'fullspmfile'
                
                output = fullfile(p{n}.root,p{n}.id,'Preprocessed',['rraespmeeg_' p{n}.task_eeg(1:end-4) '.mat']);
            case 'fullfile'
                if ~exist('options','var')
                    options = [];
                end
%                 keyboard
                     output = fullfile(p{n}.root,p{n}.id,'data',[options wjn_vm_list(n,'spmfile')]);
            case 'fullid'
                output = [p{n}.id];
            case 'group_figure_folder'
                output = fullfile(eegfolder,'group_figures');
            case 'artefact_threshold'
                    output = artefact_threshold;
            case 'fsmooth'
                output = fsmooth;
            case 'tsmooth'
                output = tsmooth;
            case 'robust'
                output = robust;      
            case 'baseline_method'
                output = 'mean';
            case 'update'
                copyfile(fullfile(getsystem,'wjn_vm_list.m'),fullfile(getsystem,'wjn_toolbox'),'f');
                disp('copied to wjn_toolbox')
        end
        if ~exist('output','var')
            output = [];
            warning('output not assigned')
        end
else
    output = p;
end



