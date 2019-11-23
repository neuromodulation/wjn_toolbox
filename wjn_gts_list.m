function [output,p]=wjn_gts_list(n,input,options,name)
%% continuous motor error options
fs = 25;
timewindow = [-5 5];
freqwindow = 1:100;
robust = 1;
fsmooth = 3;
tsmooth = 100;
artefact_threshold = 200;
try
    eegfolder = fullfile(mdf,'gts_imaging');
%     megfolder = fullfile(mdf,'vm_meg');
catch
    eegfolder = 'D:\Users\bpostigo\Documents\CHARITE EEG\';
    megfolder = 'D:\Users\bpostigo\Documents\CHARITE EEG\';
end
%%

p{1}.n = 0;
p{1}.id = 'CR';
p{1}.rest_lfp = 'spmeeg_r_cr_rest_150.mat'; %it was like 'N01HC_BA07062017_rest2.eeg' but since I did again the BA_exported the name is the former 
p{1}.root = eegfolder;
p{1}.age = 31;
p{1}.dd = 9;
p{1}.mygtss = 21;
p{1}.total_tic_score = 44;
p{1}.ybocs = 0;




for a =1:length(p)
    ids{a} = p{a}.id;
end

if exist('n','var') && ischar(n)
    i = ci(n,ids);
    if ~isempty(i)
        output = i;
        return
    end
elseif exist('n','var') && isstruct(n)
    n = ci(n.id,ids);
end

pfields={};
for a =1:length(p)
    pfields = [pfields;fieldnames(p{a})];
end
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
            case 'eegroot'
                output = eegfolder;  
            case 'contact_pairs'
                output = {'GPiR01','GPiR12','GPiR23','GPiL01','GPiL12','GPiL23','CMPfR01','CMPfR12','CMPfR23','CMPfL01','CMPfL12','CMPfL23'};
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



%% prepare 
% root = bi('root')
% cd(root)
% mkdir ../options
% 

% folder = 'vm_eeg';
% ffolder = fullfile(mdf,folder);
% 
% if ~any(strcmpi(fullfile(mdf,folder,'scripts'), regexp(path, pathsep, 'split')))
%     addpath(fullfile(mdf,folder,'scripts'))
%     addpath(fullfile(mf,'fastica'))
% end
% 
% subfolders = {'options','data','scripts','raw','figures'};
% for a = 1:length(subfolders)
%     if ~exist(fullfile(ffolder,subfolders{a}),'dir')
%         mkdir(fullfile(ffolder,subfolders{a}));
%     end
% end
% 
% if exist('options','var') 
%     if (isnumeric(options) && ~options) || strcmp(options,'off')
%         drug = 'off';
%     elseif  ~isnumeric(options) || options == 1
%         drug = 'on';
%     end
% elseif ~exist('options','var') 
%     drug = 'on';
% end
% 
