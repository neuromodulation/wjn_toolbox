function [out, label]	 = berlin_make_montage_bostsci_seg_ring(dir, initials, block)

% THIS IS FOR PLFP with Boston Scientific Segmented electrode
% set correct directory for file before


switch initials
    case 'PLFP41'
        
        hdr = ft_read_header([ dir '/' initials '/RAW/on/Raw/' lower(initials) block '.con']); % plfp41.0100.con

        label =hdr.label

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        % Boston Scientific segmented
        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            'LFP_R18',...
            'LFP_R23',...
            'LFP_R24',...
            'LFP_R25',...
            'LFP_R34',... 
            'LFP_R36',...   
            'LFP_R47',... 
            'LFP_R56',...
            'LFP_R57',...
            'LFP_R67',...
            'LFP_L18',...
            'LFP_L23',...
            'LFP_L24',...
            'LFP_L25',...
            'LFP_L34',... 
            'LFP_L36',...   
            'LFP_L47',... 
            'LFP_L56',...
            'LFP_L57',...
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];


        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side       
		indr = 125+[16+9 16+10 16+11 16+12 16+13 23-16 24-16 17-16];

        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(8)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(4)) = -1;

        % ri5 not present in plfp41, is trigger signal, remove differences with ri5. 
        % montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(2)) = 1;
        % montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(5)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(4)) = -1;

        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(4)) = 1;
        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(7)) = -1;

        % ri5 not present in plfp41, is trigger signal, emove differences with ri5.
        % montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(5)) = 1;
        % montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(6)) = -1;

        % montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(5)) = 1;
        % montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(6)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(7)) = -1;


        montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8) ) = 1; 

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = -1; 

        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = -1;

		% 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[2 15 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;
        
 case 'PLFP42'
        
        hdr = ft_read_header([ dir '/' initials '/RAW/on/Raw/' lower(initials) block '.con']); % plfp42.0100.con

        label =hdr.label

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        % Boston Scientific segmented
        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            'LFP_R18',...
            'LFP_R23',...
            'LFP_R24',...
            'LFP_R25',...
            'LFP_R34',... 
            'LFP_R36',...   
            'LFP_R47',... 
            'LFP_R56',...
            'LFP_R57',...
            'LFP_R67',...
            'LFP_L18',...
            'LFP_L23',...
            'LFP_L24',...
            'LFP_L25',...
            'LFP_L34',... 
            'LFP_L36',...   
            'LFP_L47',... 
            'LFP_L56',...
            'LFP_L57',...
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];


        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 22-16 23-16 24-16 17-16]; 

        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(8)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(2)) = 1;
        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(5)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(4)) = -1;

        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(4)) = 1;
        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(6)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(7)) = -1;


        montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8) ) = 1; 

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = -1; 

        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = -1;

		% 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[2 15 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;
        
    case 'PLFP43'
        
        hdr = ft_read_header([ dir '/' initials '/RAW/on/Raw/' lower(initials) block '.con']); % plfp43.0200.con / plfp43.0400.con
        % depending on block code different behavior
         label =hdr.label

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);
        
        % Boston Scientific segmented
        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            'LFP_R18',...
            'LFP_R23',...
            'LFP_R24',...
            'LFP_R25',...
            'LFP_R34',... 
            'LFP_R36',...   
            'LFP_R47',... 
            'LFP_R56',...
            'LFP_R57',...
            'LFP_R67',...
            'LFP_L18',...
            'LFP_L23',...
            'LFP_L24',...
            'LFP_L25',...
            'LFP_L34',... 
            'LFP_L36',...   
            'LFP_L47',... 
            'LFP_L56',...
            'LFP_L57',...
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];


        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 17-16 22-16 23-16 24-16]; 
		
        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(8)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(2)) = 1;
        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(5)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(4)) = -1;

        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(4)) = 1;
        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(6)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(7)) = -1;


        % montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8) ) = 1; 

        % montage.tra(strmatch('LFP_L23', montage.labelnew), indl(2)) = 1; 
        % montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = -1; 

        % montage.tra(strmatch('LFP_L24', montage.labelnew), indl(2)) = 1; 
        % montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = -1; 

        % montage.tra(strmatch('LFP_L25', montage.labelnew), indl(2)) = 1; 
        % montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = -1;
        
         % plfp43 block 0200 has reference left2 due to saturation
         if strcmp(block,'.0200')
            montage.tra(strmatch('LFP_L18', montage.labelnew), indl(1) ) = 1; 
            montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8)) = -1; 

            montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = 1; 

            montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = 1; 

            montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = 1; 
            
         end
         
         if strcmp(block,'.0400')
            montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8) ) = 1; 

            montage.tra(strmatch('LFP_L23', montage.labelnew), indl(2)) = 1; 
            montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = -1; 

            montage.tra(strmatch('LFP_L24', montage.labelnew), indl(2)) = 1; 
            montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = -1; 

            montage.tra(strmatch('LFP_L25', montage.labelnew), indl(2)) = 1; 
            montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = -1;
         end
         
        % 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[2 14 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;  
        
    case 'PLFP44'  
        
        hdr = ft_read_header([ dir '/' initials '/RAW/on/Raw/' lower(initials) block '.con']); % plfp44.0100.con

        label =hdr.label

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        % Boston Scientific segmented
        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            'LFP_R18',...
            'LFP_R23',...
            'LFP_R24',...
            'LFP_R25',...
            'LFP_R34',... 
            'LFP_R36',...   
            'LFP_R47',... 
            'LFP_R56',...
            'LFP_R57',...
            'LFP_R67',...
            'LFP_L18',...
            'LFP_L23',...
            'LFP_L24',...
            'LFP_L25',...
            'LFP_L34',... 
            'LFP_L36',...   
            'LFP_L47',... 
            'LFP_L56',...
            'LFP_L57',...
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];


        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 17-16 22-16 23-16 24-16]; 
		
        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R18', montage.labelnew), indr(8)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(2)) = 1;
        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(5)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(4)) = -1;

        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(4)) = 1;
        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(6)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(7)) = -1;


        montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8) ) = 1; 

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = -1; 

        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = -1;

		% 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[2 14 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;  
        
    case 'PLFP45'  
     hdr = ft_read_header([ dir '/' initials '/' lower(initials) block '.con']); % plfp45.0100.con

        label =hdr.label

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            'LFP_R01',...
            'LFP_R12',...
            'LFP_R23',...
            'LFP_R34',...
            'LFP_R45',... 
            'LFP_R56',...   
            'LFP_R67',... 
            'LFP_L01',...
            'LFP_L12',...
            'LFP_L23',...
            'LFP_L34',...
            'LFP_L45',... 
            'LFP_L56',...   
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];


        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 17-16 22-16 23-16 24-16]; 
		
        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;
        
        montage.tra(strmatch('LFP_R01', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R01', montage.labelnew), indr(2)) = -1;

        montage.tra(strmatch('LFP_R12', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R12', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew), indr(4)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew), indr(5)) = -1;

        montage.tra(strmatch('LFP_R45', montage.labelnew), indr(5)) = 1;
        montage.tra(strmatch('LFP_R45', montage.labelnew), indr(6)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew), indr(6)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew), indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew), indr(7)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew), indr(8)) = -1;


        montage.tra(strmatch('LFP_L01', montage.labelnew), indl(1)) = 1;

        montage.tra(strmatch('LFP_L12', montage.labelnew), indl(2)) = 1;
        montage.tra(strmatch('LFP_L12', montage.labelnew), indl(3)) = -1;

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = 1;
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(4)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L45', montage.labelnew), indl(5)) = 1;
        montage.tra(strmatch('LFP_L45', montage.labelnew), indl(6)) = -1;

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(7)) = -1;

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(8)) = -1;


		% 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[2 14 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;   
        
    case 'PLFP46'  
     hdr = ft_read_header([ dir '/' initials '/' lower(initials) block '.con']); % plfp45.0100.con

        label =hdr.label;

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        % Boston Scientific segmented
        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            % 'LFP_R18',... r8 missing due to signal problems
            'LFP_R23',...
            'LFP_R24',...
            'LFP_R25',...
            'LFP_R34',... 
            'LFP_R36',...   
            'LFP_R47',... 
            'LFP_R56',...
            'LFP_R57',...
            'LFP_R67',...
            'LFP_L18',...
            'LFP_L23',...
            'LFP_L24',...
            'LFP_L25',...
            'LFP_L34',... 
            'LFP_L36',...   
            'LFP_L47',... 
            'LFP_L56',...
            'LFP_L57',...
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];

        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 17-16 18-16 19-16]; % 24-16]; r8 missing due to signal problems
		
        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;

        % r8 missing due to signal problems
        % montage.tra(strmatch('LFP_R18', montage.labelnew), indr(1)) = 1;
        % montage.tra(strmatch('LFP_R18', montage.labelnew), indr(8)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R24', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(2)) = 1;
        montage.tra(strmatch('LFP_R25', montage.labelnew),  indr(5)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew),  indr(4)) = -1;

        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(3)) = 1;
        montage.tra(strmatch('LFP_R36', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(4)) = 1;
        montage.tra(strmatch('LFP_R47', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew),  indr(6)) = -1;

        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(5)) = 1;
        montage.tra(strmatch('LFP_R57', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(6)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew),  indr(7)) = -1;

        montage.tra(strmatch('LFP_L18', montage.labelnew), indl(1) ) = 1; 
        montage.tra(strmatch('LFP_L18', montage.labelnew), indl(8) ) = -1; 

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = -1; 

        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L24', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(2)) = 1; 
        montage.tra(strmatch('LFP_L25', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = -1; 

        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(3)) = 1; 
        montage.tra(strmatch('LFP_L36', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L47', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = -1; 

        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(5)) = 1; 
        montage.tra(strmatch('LFP_L57', montage.labelnew), indl(7)) = -1; 

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = -1;

		% 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[6 14 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;   
        
     case {'PLFP47', 'PLFP48', 'PLFP50', 'PLFP51'} % 'PLFP47', 'PLFP48' renamed from {'DYST06', 'DYST07'}
     hdr = ft_read_header([ dir '/' initials '/' lower(initials) block '.con']); % plfp45.0100.con

        label =hdr.label;

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
        montage.labelnew = [montage.labelnew;{...
            'LFP_R01',...
            'LFP_R12',...
            'LFP_R23',...
            'LFP_R34',...
            'LFP_R45',... 
            'LFP_R56',...   
            'LFP_R67',... 
            'LFP_L01',...
            'LFP_L12',...
            'LFP_L23',...
            'LFP_L34',...
            'LFP_L45',... 
            'LFP_L56',...   
            'LFP_L67',...
            'EMG_R',...
            'EMG_L',...
            'ECG',...
            'RESP'
            }'];


        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 17-16 18-16 19-16 20-16]; 
		
        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;
        
        montage.tra(strmatch('LFP_R01', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R01', montage.labelnew), indr(2)) = -1;

        montage.tra(strmatch('LFP_R12', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R12', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew), indr(4)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew), indr(5)) = -1;

        montage.tra(strmatch('LFP_R45', montage.labelnew), indr(5)) = 1;
        montage.tra(strmatch('LFP_R45', montage.labelnew), indr(6)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew), indr(6)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew), indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew), indr(7)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew), indr(8)) = -1;


        montage.tra(strmatch('LFP_L01', montage.labelnew), indl(1)) = 1;

        montage.tra(strmatch('LFP_L12', montage.labelnew), indl(2)) = 1;
        montage.tra(strmatch('LFP_L12', montage.labelnew), indl(3)) = -1;

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = 1;
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(4)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L45', montage.labelnew), indl(5)) = 1;
        montage.tra(strmatch('LFP_L45', montage.labelnew), indl(6)) = -1;

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(7)) = -1;

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(8)) = -1;


		% 'ECG','EMGl','EMGr','Resp',
		ind_per = 125+[6 14 16 5];

        montage.tra(strmatch('EMG_L', montage.labelnew), ind_per(2) ) = 1;
        montage.tra(strmatch('EMG_R', montage.labelnew),  ind_per(3) ) = 1;
        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(4) ) = 1;
        out.montage = montage;  
        
     case {'PLFP49'} % 
     hdr = ft_read_header([ dir '/' initials '/' lower(initials) block '.con']); % plfp45.0100.con

        label =hdr.label;

        % read all channels to avoid errors, use empty channel for event data

        label{126}='EEG129';

        label{127}='EEG130';
        label{128}='EEG131';
        label{129}='EEG132';
        label{130}='EEG133';
        label{131}='EEG134';
        label{132}='EEG135';
        label{133}='EEG136';
        label{134}='EEG137';
        label{135}='EEG138';
        label{136}='EEG139';

        label{137}='EEG140';
        label{138}='EEG141';
        label{139}='EEG142';
        label{140}='EEG143';
        label{141}='EEG144';
        label{142}='EEG145';
        label{143}='EEG146';
        label{144}='EEG147';
        label{145}='EEG148';
        label{146}='EEG149';

        label{147}='EEG150';
        label{148}='EEG151';
        label{149}='EEG152';
        label{150}='EEG153';
        label{151}='EEG154';
        label{152}='EEG155';
        label{153}='EEG156';
        label{154}='EEG157';
        label{155}='EEG158';
        label{156}='EEG159';

        label{157}='EEG160';
        label = label(1:157);

        montage = [];
        montage.labelorg = label;
        montage.labelnew = label(1:125);
      if strcmp(block,'.0100') || strcmp(block,'.0200')
        montage.labelnew = [montage.labelnew;{...
            'LFP_R01',...
            'LFP_R12',...
            'LFP_R23',...
            'LFP_R34',...
            'LFP_R45',... 
            'LFP_R56',...   
            'LFP_R67',... 
            'LFP_L01',...
            'LFP_L12',...
            'LFP_L23',...
            'LFP_L34',...
            'LFP_L45',... 
            'LFP_L56',...   
            'LFP_L67',...
            'LFP_VL23',...
            'LFP_VL34',...
            'LFP_VR01',...
            'LFP_VR12',...
            'LFP_VR23',...
            'LFP_VR34',...           
            'ECG',...
            'RESP'
            }'];
      else
        montage.labelnew = [montage.labelnew;{...
            'LFP_R01',...
            'LFP_R12',...
            'LFP_R23',...
            'LFP_R34',...
            'LFP_R45',... 
            'LFP_R56',...   
            'LFP_R67',... 
            'LFP_L01',...
            'LFP_L12',...
            'LFP_L23',...
            'LFP_L34',...
            'LFP_L45',... 
            'LFP_L56',...   
            'LFP_L67',...
            'LFP_VL56',...
            'LFP_VL67',...
            'LFP_VR34',...
            'LFP_VR45',...
            'LFP_VR56',...
            'LFP_VR67',...           
            'ECG',...
            'RESP'
            }'];
      end

        % difference index
		% ind_1 = [1, 2, 2, 2, 3, 3, 4, 5, 5, 6]
		% ind_2 = [8, 3, 4, 5, 4, 6, 7, 6, 7, 7]
        % NOTE special case l18= single channel, as reference was in channel 1

        % input socket index for left side 
        indl = 125+[17 18 19 20 21 22 23 24];
        % input socket for right side
		indr = 125+[16+9 16+10 16+11 16+12 17-16 18-16 19-16 20-16]; 
		
        montage.tra = eye(125);
        montage.tra(length(montage.labelnew), length(montage.labelorg)) = 0;
        
        montage.tra(strmatch('LFP_R01', montage.labelnew), indr(1)) = 1;
        montage.tra(strmatch('LFP_R01', montage.labelnew), indr(2)) = -1;

        montage.tra(strmatch('LFP_R12', montage.labelnew), indr(2)) = 1;
        montage.tra(strmatch('LFP_R12', montage.labelnew), indr(3)) = -1;

        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(3)) = 1;
        montage.tra(strmatch('LFP_R23', montage.labelnew), indr(4)) = -1;

        montage.tra(strmatch('LFP_R34', montage.labelnew), indr(4)) = 1;
        montage.tra(strmatch('LFP_R34', montage.labelnew), indr(5)) = -1;

        montage.tra(strmatch('LFP_R45', montage.labelnew), indr(5)) = 1;
        montage.tra(strmatch('LFP_R45', montage.labelnew), indr(6)) = -1;

        montage.tra(strmatch('LFP_R56', montage.labelnew), indr(6)) = 1;
        montage.tra(strmatch('LFP_R56', montage.labelnew), indr(7)) = -1;

        montage.tra(strmatch('LFP_R67', montage.labelnew), indr(7)) = 1;
        montage.tra(strmatch('LFP_R67', montage.labelnew), indr(8)) = -1;


        montage.tra(strmatch('LFP_L01', montage.labelnew), indl(1)) = 1;

        montage.tra(strmatch('LFP_L12', montage.labelnew), indl(2)) = 1;
        montage.tra(strmatch('LFP_L12', montage.labelnew), indl(3)) = -1;

        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(3)) = 1;
        montage.tra(strmatch('LFP_L23', montage.labelnew), indl(4)) = -1;

        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(4)) = 1;
        montage.tra(strmatch('LFP_L34', montage.labelnew), indl(5)) = -1;

        montage.tra(strmatch('LFP_L45', montage.labelnew), indl(5)) = 1;
        montage.tra(strmatch('LFP_L45', montage.labelnew), indl(6)) = -1;

        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(6)) = 1;
        montage.tra(strmatch('LFP_L56', montage.labelnew), indl(7)) = -1;

        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(7)) = 1;
        montage.tra(strmatch('LFP_L67', montage.labelnew), indl(8)) = -1;


		% 'ECG','Resp',
		ind_per = 125+[12 14];

        montage.tra(strmatch('ECG', montage.labelnew), ind_per(1) ) = 1;
        montage.tra(strmatch('RESP', montage.labelnew), ind_per(2) ) = 1;
        
        % vl3 vle4 vle5 vr1 vr2 vr3 vr4 vr5 
		ind_per = 125+[30 5 6 7 8 9 10 11 ];
         % 
         if strcmp(block,'.0100') || strcmp(block,'.0200')
            montage.tra(strmatch('LFP_VL23', montage.labelnew), indl(1) ) = 1; 
            montage.tra(strmatch('LFP_VL23', montage.labelnew), indl(2)) = -1; 
            
            montage.tra(strmatch('LFP_VL34', montage.labelnew), indl(2) ) = 1; 
            montage.tra(strmatch('LFP_VL34', montage.labelnew), indl(3)) = -1; 
            
            montage.tra(strmatch('LFP_VR01', montage.labelnew), indl(4) ) = 1; 
            montage.tra(strmatch('LFP_VR01', montage.labelnew), indl(5)) = -1; 
            
            montage.tra(strmatch('LFP_VR12', montage.labelnew), indl(5) ) = 1; 
            montage.tra(strmatch('LFP_VR12', montage.labelnew), indl(6)) = -1; 
             
            montage.tra(strmatch('LFP_VR23', montage.labelnew), indl(6) ) = 1; 
            montage.tra(strmatch('LFP_VR23', montage.labelnew), indl(7)) = -1; 
            
            montage.tra(strmatch('LFP_VR34', montage.labelnew), indl(7) ) = 1; 
            montage.tra(strmatch('LFP_VR34', montage.labelnew), indl(8)) = -1;      
         end
         
         if strcmp(block,'.0300')             
            montage.tra(strmatch('LFP_VL56', montage.labelnew), indl(1) ) = 1; 
            montage.tra(strmatch('LFP_VL56', montage.labelnew), indl(2)) = -1; 
            
            montage.tra(strmatch('LFP_VL67', montage.labelnew), indl(2) ) = 1; 
            montage.tra(strmatch('LFP_VL67', montage.labelnew), indl(3)) = -1; 
            
            montage.tra(strmatch('LFP_VR34', montage.labelnew), indl(4) ) = 1; 
            montage.tra(strmatch('LFP_VR34', montage.labelnew), indl(5)) = -1; 
            
            montage.tra(strmatch('LFP_VR45', montage.labelnew), indl(5) ) = 1; 
            montage.tra(strmatch('LFP_VR45', montage.labelnew), indl(6)) = -1; 
             
            montage.tra(strmatch('LFP_VR56', montage.labelnew), indl(6) ) = 1; 
            montage.tra(strmatch('LFP_VR56', montage.labelnew), indl(7)) = -1; 
            
            montage.tra(strmatch('LFP_VR67', montage.labelnew), indl(7) ) = 1; 
            montage.tra(strmatch('LFP_VR67', montage.labelnew), indl(8)) = -1;    
         end
         
         out.montage = montage; 
        
end           

 