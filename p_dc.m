
function [output,p]=p_dc(n,input)

p{1}.id = 'DYST01';
p{1}.n = 1;




if exist('n','var')
        
    if ~exist('input','var') && n >=1;
        output = p{n};
    elseif n >=1 && ismember(input,fieldnames(p{n}))
        output = p{n}.(input);
    end
    if n>= 1
        [files, sequence, root, details] =dbs_subjects_berlin(p{n}.id, 1);
    end

        switch input
            case 'sequence'
                output = sequence;
            case 'root'
                output = fullfile(mdf,'MEG_dystcon','data');
            case 'outroot'
                output = details.outroot;
            case 'orestfile'
                output = details.orestfile;
            case 'otaskfile'
                output = details.otaskfiles;
            case 'mvl_trigger'
                output = details.left_trigger;
            case 'mvr_trigger'
                output = details.right_trigger;
            case 'source_location'
                output{1} = {'M1PDL','M1ALL','M1REF','CBPDL','CBPDALL'};
                output{2} = [28 -26 56; 24 -22 38; 37 -18 53;3.6429  -58.9643  -40.8571; 5.0310  -59.2712  -41.2288];
            case 'source_name'
                output = {'cM1_beta','gmax_beta','pM1_beta','M1','cM1lowfreq','gmax_lowfreq'};
            case 'conditions'
                output = {'rest','tremor'};
            case 'freqranges'
                output = [4 10;7 13; 13 30];
                if ~isnan(p{n}.tf)
                    output(end+1,1:2) = [p{n}.tf-2 p{n}.tf+2];
                    output(end+1,1:2) = [p{n}.tf*2-2 p{n}.tf*2+2];
                end
            case 'fulltf'
                output = [p{n}.tf-2 p{n}.tf+2];
            case 'fullid'
                output = ['redcm', p{n}.id, '_' p{n}.med ];
            case 'fullfile' 
                output = fullfile(mdf,'\MEG_VIM\final files',['redcm', p{n}.id, '_' p{n}.med '_' p{n}.side '.mat' ]);
                 case 'file' 
                output = ['redcm', p{n}.id, '_' p{n}.med '_' p{n}.side '.mat' ];
            case 'outname'
                output = ['redcm', p{n}.id, '_' p{n}.med '_' p{n}.side ];
            case 'sensorfolder'
                output = ['sensor_redcm', p{n}.id, '_' p{n}.med '_' p{n}.side ];
            case 'extractionfolder'
                output = ['extraction_redcm', p{n}.id, '_' p{n}.med '_' p{n}.side ];
            case 'imagename'
                output = ['dics_refcoh_cond_all_' vim_patients(n,'outname') '.nii'];
            case 'smoothflipimage'
                if strcmp(vim_patients(n,'side'),'left')
                    output = ['flip_s1dics_refcoh_cond_all_' vim_patients(n,'outname') '.nii'];
                else
                    output = ['s1dics_refcoh_cond_all_' vim_patients(n,'outname') '.nii'];
                end
               
            case 'list'
                for a=1:length(p)
                    output{a,2} = p{a}.id;
                    output{a,1} = a;
                    output{a,3} = p{a}.side;
%                     output = output';
                end
            case 'LONlist'
                output = [1 4:16]
            case 'PDlist'
                in=0;
                for a=1:length(p)
                    
                    if isequal(p{a}.diagnosis,'PD')
                        in=in+1;
%                     output{in,2} = p{a}.id;
                    output(in,1) = a;
%                     output{in,3} = p{a}.side;
                    end
%                     output = output';
                end
           case 'ETlist'
                in=0;
                for a=1:length(p)
                    
                    if isequal(p{a}.diagnosis,'ET')
                        in=in+1;
%                     output{in,2} = p{a}.id;
                    output(in,1) = a;
%                     output{in,3} = p{a}.side;
                    end
%                     output = output';
                end
            case 'beta'
                sources = p{n}.s05k100;
                for a = 1:length(sources);
                    if ~isempty(sources{a}) && max(sources{a}(:,1))>=13;
                        output(a) = 1;
                    else
                        output(a) = 0;
                    end
                end
             case 'lowfreq'
                sources = p{n}.s05k100;
                for a = 1:length(sources);
                    if ~isempty(sources{a}) && min(sources{a}(:,2))<=12;
                        output(a) = 1;
                    else
                        output(a) = 0;
                    end
                end
            case 'root'
                output = fullfile(mdf,'\MEG_VIM\final files');

        
          
                    
        end
        if ~exist('output','var')
            output = 0;
            warning('output not assigned')
        end
else
    output = p;
end
