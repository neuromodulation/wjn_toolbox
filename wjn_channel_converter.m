function [chanlabels,chantypes] = wjn_channel_converter(channel_list,standard,allow_ambiguity)
% function [chanlabels,chantypes] = wjn_channel_converter(channel_list,standard,allow_ambiguity)
% Input:
% standard = 'BIDS' for storing (default) or 'CHARITE' for Charité acquisition standard (max. 9 characters)
% allow_ambiguity = Allow ambiguous/uncertain assumptions based on
% predefined likelihoods. (default allow_ambiguity = 0)
%
% This function is designed to standardize channel names for invasive
% neurophysiology based on a set of channel names as input.
% e.g. channel_list = {'GPiR1','GPi_R2','GPi_LFPR3','LFP_R_GPi23'} gets
% plugged into chanlabels = wjn_channel_converter(channel_list,'BIDS')
% results in chanlabels =  {'LFP_1_R_GPi_MT'}    {'LFP_2_R_GPi_MT'}    {'LFP_3_L_GPi_MT'}    {'LFP_23_R_GPi_MT'}
% The channel naming convention used for ICN BIDS datasets is
% [Channeltype _ Number _ Side _ Location _ Manufacturer]

% set default output standard to BIDS:
if ~exist('standard','var') || isempty(standard)
    standard = 'BIDS';
end
if ~exist('allow_ambiguity','var')
    allow_ambiguity = 0;
end

%% CHECK for the output standard and assign abbreviations to channel types.
% The BIDS standard is based on the convention built in the Interventional and Cognitive Neuromodulation
% group as part of the TRR295 ReTune INF project. (add DOI to blogpost when available)
% The CHARITE standard is a convention for channel naming in the
% Neurophysiology laboratory at the Movement Disorder and Neuromodulation
% Unit at Charité - Universitätsmedizin Berlin. It is compatible with the
% TMSi SAGA system that only allows 9 characters.

switch standard
    case 'BIDS'
        outtypes = {'LFP','ECOG','EEG','EMG','ACC','ALG'};
        % Output of channel types in channel names:
        % LFP = Local Field Potential
        % ECOG = Electrocorticography
        % EEG = Electroencephalography
        % ACC = Accelerometer
        % ALG = Analog signals
        
        manufacturers = {{'BS','MT','AT'},{'AT','PMT'},{'AO','TM'},{'AO','TM'},{'AO','TM'},{'CH'}};
        % DBS/LFP Electrode manufacturers:
        % BS = Boston Scientific
        % MT = Medtronic
        % AT = Abbott
        
        % ECOG Electrode manufacturers:
        % AT = AdTech
        % PMT = PMT
        
        % EEG, EMG, ACC, ALG:
        % AO = Alpha Omega
        % TM = TMSi
        % CH = Charité
        
    case 'CHARITE'
        outtypes = {'LFP','CTX','EEG','EMG','ACC','ALG'};
        manufacturers = {{'B','M','A'},{'A','P'},{'A','T'},{'A','T'},{'A','T'},{'C'}};
        % Types as above, except for ECOG that is CTX and manufacturers
        % having only the first letter.
end

%% Check if the input channel_list is a character instead of a cell, e.g. if only one channel is converted, if yes convert to cell
if ischar(channel_list)
    channel_list = {channel_list};
end
%% LOOKUP table for channel identification
% This can be extended and is currently build on common uses at the
% the Interventional and Cognitive Neuromodulation group at Charité and
% collaborators.

% Input types are potential denominators of the channel type to be checked
% in the channel name. Often Channels in our laboratories have the type in
% the name, e.g. LFP_STNR1, or ecog_1. Note that multiple inputtypes can be
% mapped to the outputtypes defined above. E.g. SEEG, DBS and LFP all
% comprise LFP data.

inputtypes = {{'SEEG','LFP','DBS'},{'ECOG','CTX','ECO','ECX'},{'EEG'},{'EMG'},{'ACC'},{'ALG'}};
% see description of types above = {'LFP','ECoG','EEG','EMG','ACC','ALG'};

% The Locations lookup gives examples of potential strings that can help
% identify the recording location from a channel. E.g. for DBS targets, as
% mentioned above, we may have a channel name, such as GPiR12, which would
% 1) identify the channel as an LFP channel and
% 2) describe its recording location as GPi

locations = {{'GPi','STN','VIM'},...
    {'SM','IFG','STG'},...
    {'Cz','Fz','C3','C4'},...
    {'BR_','BB_','TB_','FDI','GCN'},...
    {'D2_','X','Y','Z'},...
    {'ROT','BTN'}};

% LFP locations:
% STN (Subthalamic nucleus)
% GPI (Globus pallidus internus)
% VIM (Ventral intermediate nucleus of thalamus)

% ECOG locations:
% SM_ (Straight Sensorimotor)
% IFG (Inferior frontal gyrus)
% STG (Trajectory for speech traversing M1 to superior temporal gyrus)
%
% EEG locations:
% Cz, Fz, C3, C4
% Named according to 10-20 system
%
% EMG locations:
% BR_ (M. brachioradialis; forearm)
% BB_ (M. biceps brachii; forearm)
% TB_ (M. triceps brachii; forearm)
% FDI (First dorsal interosseus; hand)
% GCN (gastrocnemius; calf)

% Accelerometer locations (directions):
% X, Y, Z
%
% Analog signal locations (devices):
% ROT (Rotameter)
% BTN (Button)

%% Channel type definitions for further software toolboxes
% Many toolboxes expect a decisive description of the channel type.
% This is the channel type defintion for
% 'LFP','ECOG','EEG','EMG','ACC','ALG'
% in spm:
spmtypes = {'LFP','LFP','EEG','EMG','Other','Other'};
% other format e.g. for MNE can be added here.
% We can initialize our output chantypes list with some default, e.g. Other
chantypes = repmat({'Other'},[length(channel_list) 1]);
% So whenever we can infer the channeltype from the channel_list
%% Channel recording side.
% In many cases the recording side (hemisphere, body side) is important.
% We define R(ight), L(eft) and C(entral)
sides = {'R','L','C'};

%% Initialize chanlabels output variable as a cell
chanlabels={};
% initialize a chanel type helper variable
itypes=[];

%% Loop through all channels (a)
for a = 1:length(channel_list)
    % Loop through inputtypes (b)
    % defined above, note that this
    % prioritizes the identification in the order defined in inputtypes.
    % That means an ambiguous channel name such as ECOG_LFP_GPiR2 will be
    % identified as LFP and not ECOG channel, because LFP is the first entry in the
    % inputtypes variable above.
    for b = 1:length(inputtypes)
        % initialize itypes helper var with zeros
        itypes(a,:) = zeros(1,length(outtypes));
       
        %% 1) Identify the inputtype
        % Check (similar to regexp) for any occurence of any string defined
        % in either inputtypes or locations as defined for the
        % inputtype{b}.
        % E.g. for LFP it looks for occurrence of the strings LFP, STN,
        % GPi or VIM ...
        i = ci([inputtypes{b} locations{b}],channel_list(a));
        % ... and only proceeds if an occurence was identified:
        if ~isempty(i)
            % This locks the channel type (b) into the itypes helper variable.
            itypes(a,b) = i;
            
            %% 2) Identify the recording / channel location
            % Now another loop runs through the locations and checks again,
            % whether there is a location to be read in from the channel name.
            for c=1:length(locations{b})
                loc = ci(locations{b}(c),channel_list(a));
                % ... if yes, store it in location, break and stop the loop.
                if ~isempty(loc)
                    location = locations{b}{c};
                    break
                end
            end
            % ... if not, location is stored as UNK(known).
            if isempty(loc)
                location = 'UNK';
            end
            % Some locations have a length of 2 instead of 3 characters.
            % For those some standards may want to plug in a '_' to have the
            % same length. E.g. LFP_STN vs. EEG_Cz_
            if length(location) == 2
                location = [location '_'];
            end
            
            %% 3) Identify the recording side
            % Next the following section tries to identify the side of the
            % recording.
            % Often recording side is following the channel location
            % description. Therefore, this script checks for variations of
            % such occurences. E.g. GPiR (location side), or STN_R (type _
            % location _ side) will index the correct location as right.
            % An additional assumption is that a _R_ or _L_ and 'right' and
            % 'left' strings also likely indicate side:
            iside = [ci({[location '_R'],[location 'R'],'_R_','right'},channel_list(a)), ...
                2*ci({[location '_L'],[location 'L'],'_L_','left'},channel_list(a))];
            % if this did not yield any match, there is a chance that the side
            % is followed by the channel type, e.g. as in ECOG_R or lfp_r.
            % Since inputtypes have multiple potential inputs this requires a
            % loop:
            if isempty(iside)
                for c = 1:length(inputtypes{b})
                    iside = [ci({[inputtypes{b}{c} '_R'],[inputtypes{b}{c} 'R']},channel_list(a)), ...
                        2*ci({[inputtypes{b}{c} '_L'],[inputtypes{b}{c} 'L']},channel_list(a))];
                    if ~isempty(iside)
                        break
                    end
                end
            end
            
            % A special case can be made for the EEG 10-20 system, where sides
            % can be inferred from the location digit (e.g. C3 = left, Cz = central, C4 = right):
            N = regexp(channel_list{a},'\d*','Match');
            if ~isempty(ci(inputtypes{b},'EEG')) && ~isempty(ci({'Cz','Fz','FCz','Pz'},channel_list(a)))
                iside = 3;
            elseif ~isempty(N) && ~isempty(ci(inputtypes{b},'EEG'))
                iside = 1+~iseven(str2double(N{end}));
            end
            % Now plugin the side as index to the sides description defined above ( sides = {'R','L','C'} )
            if ~isempty(iside)
                side = sides{iside}; % iside = 1 = R ; iside = 2 = L; iside = 3 = C;
            else
                side = 'U'; % if after all it could not be inferred, side is U(nknown)
            end
            
            %% 4) Find channel number.
            % Search the channel name for digits.
            % Usually the channel number is the last number in channel names.
            % That is because in a hierarchy of hardware setup parts, the
            % channel is the smallest element. E.g. you can have multiple
            % headstages with 32 channel inputs which could lead to the
            % following channel naming: HS_01_LFP_1, HS_01_LFP_2 HS_02_LFP3
            % Here the last number identifies the channel number.
            N = regexp(channel_list{a},'\d*','Match');
            % But before assigning that number we should acknowledge that the
            % EEG 10-20 System could be misinterpreted, so we will ignore this
            % rule for EEG and deal with it below.
            if strcmp(outtypes{b},'EEG')
                n=[];
            elseif isempty(N)
                % If no number is to be found in the string, we plugin a 0 as a
                % placeholder for manual adaptation.
                n=0;
            elseif allow_ambiguity && length(N{end})>1 && strcmp(N{end}(1),'0')
                % !ambiguuos/uncertain choice:
                % Another thing to keep in mind is that two adjacent numbers can
                % depict either the channel number or a derivation of two bipolar
                % channels. E.g. EMG_Ch23 which could be an EMG channel number 23
                % whereas LFP_STN_R_23 could mean it is a bipolar derivation of
                % LFP channels LFP_STN_R_3 and LFP_STN_R2. Now this only matter for
                % one occasion, which is the depiction of bipolar derivation 01
                % that would translate to '1' if not carefully handled. Therefore,
                % in this script in case the combination 01 is explicitly written
                % out as that. Unfortunately, this is ambiguous as mentioned above.
                n = num2str(str2double(N{end}),'%02.f');
            else
                % This is the part defined first here. It takes the last digit string,
                % gets rid of additional zeros preceding the number and converts it
                % back to a string.
                n = num2str(str2double(N{end}));
            end
            
            
            %% 5) Try to identify the electrode manufacturer
            % This is almost always impossible except for specific cases at Charité.
            % Therefore, we initialize with U(known).
            manufacturer = 'U';
            
            if allow_ambiguity && ~isempty(ci(inputtypes{b},'LFP')) && length(ci([inputtypes{b} locations{b}],channel_list)) < 9
                % !ambiguuos/uncertain choice:
                % Boston Scientific and Abbott do not produce electrodes with less
                % than 8 contacts. Medtronic only produces electrodes with 4 contacts.
                % Most of the times we record LFP from both
                % hemispheres, leading to 14-16 channels per dataset for Boston Scientific and Abbott.
                % Therefore, we can infer that if in the overall
                % channel list, there are fewer than 9 LFP contacts, it is likely
                % Medtronic. This is ambiguous because it could be a Boston
                % Scientific or Abbott electrode not fully connected or only
                % recorded in one hemisphere.
                manufacturer = manufacturers{1}{2}; % Note that this definition is dependent on the standard (BIDS vs CHARITE)
            elseif allow_ambiguity && ~isempty(ci(inputtypes{b},'LFP'))
                % !ambiguuos/uncertain choice:
                % Most LFP recordings that do not fall in the category
                % above in our center are recorded with Boston Scientific
                % electrodes.
                manufacturer = manufacturers{1}{1};
            elseif allow_ambiguity && ~isempty(ci(inputtypes{b},'ECOG')) && length(ci([inputtypes{b} locations{b}],channel_list)) < 9
                % !ambiguuos/uncertain choice:
                % Currently in Europe almost anyone is using AdTech ECoG strips. So
                % generally there is high likelihood that AdTech is the correct
                % manufacturer. However, when working with higher channel count
                % (>8) recordings are likely coming from international
                % collaborators and the manufacturer is often PMT. This is
                % ambiguous.
                manufacturer =  manufacturers{2}{1};
            elseif allow_ambiguity && ~isempty(ci(inputtypes{b},'ECOG')) && length(ci([inputtypes{b} locations{b}],channel_list)) > 8
                % !ambiguuos/uncertain choice:
                % Consequently from above high channel count electrodes are
                % likely PMT in our setting at Charité.
                manufacturer =  manufacturers{2}{2};
            end
            
            %% Finally the channel string is created based on all the inferred information
            % The standards can be extended here:
            switch standard
                case 'BIDS'
                    chanlabels{a} = strrep([outtypes{b} '_' n  '_' side '_' location '_' manufacturer],'__','_');
                case 'CHARITE'
                    chanlabels{a} = [outtypes{b} side n location manufacturer];
            end
            %
            chantypes{a} = spmtypes{b};
            break
        end
    end
    %% If no channel type can be automatically detected through the steps above itypes will be all zeros.
    % Then tthe original channel name will be forwarded to the new channel
    % list.
    if ~sum(itypes(a,:))
        chanlabels{a} = channel_list{a};
    end
end