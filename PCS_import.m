clear
root = fullfile(mdf,'PC+S','SensingProgrammerFiles','PatientFiles');
cd(root);
[files,dir] = uigetfile('*MR*.txt','Select Data File','MultiSelect','on');
files = cellstr(files);
cd(dir)


% fname = spm_input('Filename :');
disp(files')
tc = []; mc = [];
for b = 1:length(files);
    clear ndata
    [dir,fname,ext] =fileparts(fullfile(dir,files{b}));
    data = load(fullfile(dir,[fname ext]));
    
    xml = parseXML(fullfile(dir,[fname '.xml']));
    xml = xml.Children;
    SPTimeStamp = xml(10).Children.Data;
    INSTimeStamp = xml(8).Children.Data;
    Duration = xml(12).Children.Data;
    Fs = str2num(xml(18).Children(20).Children.Data(1:end-3));
    if Fs == 422
        Fs = 421.9409283
    end
    
%     cutx = 3*Fs;
%     data = data(cutx:end,:);
    disp(fname);
    disp(['SPT Time : ' SPTimeStamp])
    disp(['Recording Length: ' Duration])
    time = linspace(0,length(data)/Fs,length(data));
    splitquest = spm_input('Split this file into different conditions? ',[],'Yes|No');
    if strcmp(splitquest,'Yes')
            ctime{1} = datestr(SPTimeStamp,'HH:MM:SS');
            xtime(1) = 0;
            for a = 2:max(time)/60+1
                ctime{a} = ctime{1};
                ctime{a}(4:5) = num2str(str2num(ctime{a-1}(4:5))+1);
                xtime(a) = xtime(a-1)+60;
            end
            n=0;nzone=1;
            while nzone
                figure;
                subplot(2,1,1);
                plot(time,data(:,1));
                xlabel('Time from start [s]');
                subplot(2,1,2);
                plot(time,data(:,1));
                set(gca,'XTick',xtime,'XTickLabel',ctime)
                xlabel('Clock Time [hh:mm:ss]');
                figone(16,20)
                xsplit = ginput;
                xs = round(xsplit(end,1)*Fs);
                
                figure;
                subplot(2,1,1);
                plot(time,data(:,1));hold on;
                scatter(time(xs),data(xs,1),1000,'r','+')
                xlabel('Time from start [s]');
                subplot(2,1,2);
                plot(time,data(:,1));hold on;
                set(gca,'XTick',xtime,'XTickLabel',ctime)
                xlabel('Clock Time [hh:mm:ss]');
                scatter(time(xs),data(xs,1),1000,'r','+')
                n=n+1;
%                 close all
%                 msquest = spm_input('Split this file into more conditions? ',[],'Yes|No')
%                 if strcmp(msquest,'No');
%                   spoint(n) = xs;
%                   nzone =0;
%                 else
%                     spoint(n) = xs;
%                 end
            end
            
            for ns = 1:n
                if ns == 1; 
                ndata{ns}.data = data(1:spoint(ns),:);
                ndata{ns}.time = linspace(0,spoint(ns)/Fs,spoint(ns));
                else
                    ndata{ns}.data = data(spoint(ns-1):spoint(ns),:);
                    ndata{ns}.time = linspace(0,(spoint(ns)-spoint(ns-1))/Fs,length(ndata{ns}.data));
                end
            end
            ndata{ns+1}.data = data(spoint(ns):end,:);
            ndata{ns}.time = linspace(0,(length(ndata{ns}.data)-spoint(ns))/Fs,length(ndata{ns}.data));
    else 
        ndata{1}.data = data;
        ndata{1}.time = time;
            
    end
      
    for nd = 1:numel(ndata);    
    if ~(isempty(tc) || isempty(mc))
    condquest = spm_input('Keep condition for next recording? ',[],'Yes|No');
     if strcmp(condquest,'No');tc=[];mc=[];end
    end
   
    while (isempty(tc) || isempty(mc))
        c=PCS_conditions;
        if strcmp(splitquest,'Yes')
               disp(fname);
                disp(['SPT Time : ' SPTimeStamp])
                disp(['INS Time : ' INSTimeStamp])
                disp(['Recording Length: ' Duration])
               [tc,i] = listdlg('ListString',[c{1} 'ADD NEW'],'PromptString',['Choose task for split-file ' num2str(nd) ':'],'ListSize',[250 300]);
                
        else
                  disp(fname);
                disp(['SPT Time : ' SPTimeStamp])
                disp(['INS Time : ' INSTimeStamp])
                disp(['Recording Length: ' Duration])
              [tc,i] = listdlg('ListString',[c{1} 'ADD NEW'],'PromptString',['Choose task :'],'ListSize',[250 300]);
        end
        if tc == numel(c{1})+1;
            new_cond = spm_input('Name of new condition: ',[],'s');
            c = PCS_addconditions(new_cond);
        end
        if ~i 
            warning('Cancelled')
            return
        end
        if strcmp(splitquest,'Yes')
               [mc,i] = listdlg('ListString',c{2},'PromptString',['Choose condition for split-file ' num2str(nd) ':'],'ListSize',[250 300]);
     
        else
              [mc,i] = listdlg('ListString',c{2},'PromptString','Choose condition:','ListSize',[250 300]);
     
        end
       if ~i 
        warning('Cancelled')
        return
        end
    end
    cond = [c{1}{tc} '_' c{2}{mc}];
    outputfolder = fullfile(mdf,'PC+S','output',cond);
    mkdir(outputfolder);

    ID = xml(6).Children.Data;
    RecConfig = xml(22).Children ;
    ChnConfig = xml(18).Children;

    chntype{1} = ChnConfig(30).Children(2).Children.Data;
    chntype{2} = ChnConfig(32).Children(2).Children.Data;
    chntype{3} = ChnConfig(34).Children(2).Children.Data;
    chntype{4} = ChnConfig(36).Children(2).Children.Data;
    chnlabel{1} = [ChnConfig(30).Children(12).Children.Data ChnConfig(30).Children(14).Children.Data];
    chnlabel{2} = [ChnConfig(32).Children(12).Children.Data ChnConfig(32).Children(14).Children.Data];
    chnlabel{3} = [ChnConfig(34).Children(12).Children.Data ChnConfig(34).Children(14).Children.Data];
    chnlabel{4} = [ChnConfig(36).Children(12).Children.Data ChnConfig(36).Children(14).Children.Data];
    time = linspace(0,length(data)/Fs,length(data));
    save(fullfile(dir,[fname '.mat']))
    
    xdata = ndata{nd}.data;
    
    clear data 
  
    for cl = 1:length(chnlabel);   
%         if ~strcmp(chntype{cl},'Disabled')
  
            data.label{cl} = [chnlabel{cl} '_' chntype{cl}]; 
%         end
    end
    data.fsample = Fs;
    data.trial{1} = xdata(:,1:4)';
    data.time{1} =time;
channame = unique(data.label);
outname = [];
for l=1:length(channame);
    outname = [outname  channame{l} '_'];
end
D=spm_eeg_ft2spm(data,[ID '_' cond '_' outname '_' strrep(strrep(datestr(SPTimeStamp),':','-'),' ','_')]);
D=chantype(D,1:length(D.chanlabels),chntype);
D=chantype(D,D.indchantype('TD'),'LFP');
D=conditions(D,1,cond);
D.ID=ID;
D.PCS_xml = xml;
D.PCS_file = fullfile(dir,[fname ext]);
D.SPTimeStamp = SPTimeStamp;
D.INSTimeStamp = INSTimeStamp;
save(D);

S.D = fullfile(D.path,D.fname);
S.outfile = fullfile(outputfolder,D.fname);
D=spm_eeg_copy(S);

    end
end
    
cd(root);
