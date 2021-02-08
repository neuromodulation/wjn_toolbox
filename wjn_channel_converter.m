function [chanlabels,chantypes] = wjn_channel_converter(channel_list,standard)
% function [chanlabels,chantypes] = wjn_channel_converter(channel_list)
% standard 'BIDS' for storing (default) or 'CHARITE' for Charité acquisition standard (max. 9 digits)

if ~exist('standard','var')
    standard = 'BIDS';
end

switch standard
    case 'BIDS'
        outtypes = {'LFP','ECOG','EEG','EMG','ACC','ALG'};
        manufacturers = {{'BS','MT','AT'},{'AT','PMT'},{'AO','TM'},{'AO','TM'},{'AO','TM'},{'CH'}};
        
    case 'CHARITE'
        outtypes = {'LFP','CTX','EEG','EMG','ACC','ALG'};
        manufacturers = {{'B','M','A'},{'A','P'},{'A','T'},{'A','T'},{'A','T'},{'C'}};

end
            

types = {{'SEEG','LFP'},{'ECOG','CTX','ECO','ECX'},{'EEG'},{'EMG'},{'ACC'},{'ALG'}};
        locations = {{'GPI','STN','VIM'},...
            {'SM','IFG','STG'},...
            {'Cz','Fz','C3','C4'},...
            {'BR_','BB_','TB_','FDI','GCN'},...
            {'D2_','X','Y','Z'},...
            {'ROT','BTN'}};
spmtypes = {'LFP','LFP','EEG','EMG','Other','Other'};

sides = {'R','L'};
chanlabels={};
chantypes = repmat({'Other'},[length(channel_list) 1]);
itypes=[];

if ischar(channel_list)
    channel_list = {channel_list};
end

for a = 1:length(channel_list)  
    for b = 1:length(types)   
        itypes(a,:) = zeros(1,length(outtypes));
        i = ci([types{b} locations{b}],channel_list(a));
        if ~isempty(i)
                 itypes(a,b) = i;
            for c=1:length(locations{b})
                loc = ci(locations{b}(c),channel_list(a));
                if ~isempty(loc)
                    location = locations{b}{c};      
                    break
                end
            end
            if isempty(loc)
                location = 'UNK';
            end
            
            iside = [ci({[location '_R'],[location 'R']},channel_list(a)), ...           
                    2*ci({[location '_L'],[location 'L']},channel_list(a))];
            if isempty(iside)
                for c = 1:length(types{b})
                    iside = [ci({[types{b}{c} '_R'],[types{b}{c} 'R']},channel_list(a)), ...           
                    2*ci({[types{b}{c} '_L'],[types{b}{c} 'L']},channel_list(a))];
                    if ~isempty(iside)
                        break
                    end
                end
            end
            if ~isempty(iside)
                side = sides{iside};
            else
                side = 'U';
            end
            if length(location) == 2
                location = [location '_'];
            end
             N = regexp(channel_list{a},'\d*','Match');
             if strcmp(outtypes{b},'EEG')
                 n=[];   
             elseif isempty(N)
                 n=0;
             elseif length(N{end})>1 && N{end}(1) == 0
                 n = num2str(str2double(N{end}),'%02.f');
             else
                  n = num2str(str2double(N{end}));
             end
             
            
             manufacturer = 'U';
              
             if strcmp(outtypes{b},'LFP') && length(ci([types{b} locations{b}],channel_list)) < 9
                 manufacturer = manufacturers{1}{2};
             elseif strcmp(outtypes{b},'CTX') && length(ci([types{b} locations{b}],channel_list)) < 9
                 manufacturer =  manufacturers{2}{1};
             elseif strcmp(outtypes{b},'EEG') 
                 if ~isempty(ci({'Cz','Fz','FCz','Pz'},channel_list(a)))
                    side = 'C';
                 elseif iseven(str2double(N{end}))
                     side = 'R';
                elseif ~iseven(str2double(N{end}))
                    side = 'L';
                 end
             end
             
             switch standard
                    case 'BIDS'
                        chanlabels{a} = strrep([outtypes{b} '_' n  '_' side '_' location '_' manufacturer],'__','_');
                    case 'CHARITE'
                        chanlabels{a} = [outtypes{b} side n(2) location manufacturer];
             end
             chantypes{a} = spmtypes{b};
             break
        end
    end
    if ~sum(itypes(a,:))
        chanlabels{a} = channel_list{a};
    end
end