function [output,p]=p_cme(n,input,options,name)
%% continuous motor error options
fs = 20;
timewindow = 1;
freqwindow = 1:100;
robust = 1;
fsmooth = 5;
tsmooth = 200;
artefact_threshold = 3;

%%
folder = 'c_motor_error';
ffolder = fullfile(mdf,folder);

if ~any(strcmpi(fullfile(mdf,folder,'scripts'), regexp(path, pathsep, 'split')))
    addpath(fullfile(mdf,folder,'scripts'))
    addpath(fullfile(mf,'fastica'))
end

subfolders = {'options','data','scripts','raw','figures'};
for a = 1:length(subfolders)
    if ~exist(fullfile(ffolder,subfolders{a}),'dir')
        mkdir(fullfile(ffolder,subfolders{a}));
    end
end

if exist('options','var') 
    if (isnumeric(options) && ~options) || strcmp(options,'off')
        drug = 'off';
    elseif  ~isnumeric(options) || options == 1
        drug = 'on';
    end
elseif ~exist('options','var') 
    drug = 'on';
end

p{1}.id = '382EI54';
p{1}.on.best = {'STNL18'};
p{1}.on.rtf = 1;
p{1}.off.rtf = 1;
p{1}.off.bc = {'STNR16'};
p{1}.off.best = {'STNL18'};

p{2}.id = '383EÜ43';
p{2}.on.rtf = 1;
p{2}.on.best = {'STNL18'};
p{2}.off.rtf = 1;
p{2}.off.best = {'STNL18'};
p{2}.off.exbehav = [312 457];
p{2}.off.bc = {'STNR16'};

p{3}.id = '384AC54';
p{3}.on.artefacts = [190 239; 455 475];
p{3}.medtronic = 1;
p{3}.on.best = {'STNL03'};

p{4}.id = '385AC46';
p{4}.on.bc = 'STNR17';
p{4}.on.artefacts = [375 382];
p{4}.on.best = {'STNL18'};

p{5}.id = '389IC47';
p{5}.on.bc = {'STNR18'};
p{5}.on.best = {'STNL18'};
p{5}.off.bc = {'STNR18'};
p{5}.off.exbehav = [204.11109 248.86951;306.40471 460.79745];
p{5}.off.artefact_threshold = 2;

for a =1:length(p)
    ids{a} = p{a}.id;
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
allfields = unique(pfields);
if exist('n','var') 
    if isnumeric(n) && ~exist('input','var') && n >=1
        output = p{n};
        return
    elseif isnumeric(n) && n >=1 && ismember(input,fieldnames(p{n}))
        output = p{n}.(input);
        return
    elseif isnumeric(n) && n >=1 && isfield(p{n},drug) && ismember(input,fieldnames(p{n}.(drug)))
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
                for a=1:length(p)
                    output{a,2} = p{a}.id;
                    output{a,1} = a;
                end
            case 'root'
                output = fullfile(mdf,folder,'data');              
            case 'savefile'
                output = fullfile(mdf,folder,'options',[p{n}.id '_' drug '_options.mat']);
            case 'addscript'
                edit(fullfile(mdf,folder,'scripts',options));
            case 'save'
                eval([name '=options'])
                save(bi(n,'savefile'),name,'-append')
            case 'load'
                load(bi(n,'savefile'),options)  
            case 'raw'
                output = ['r_' p{n}.id '_' drug '_cme.mat'];
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
                output = ['bspmeeg_r_' p{n}.id '_' drug '_cme.mat'];
            case 'fullid'
                output = [p{n}.id '_' drug '_cme'];
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
