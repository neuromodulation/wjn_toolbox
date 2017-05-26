function [fD]=averager_freq_extract(filename)



if ~exist('filename','var');
    [filename,pathname] = uigetfile('*.mat','averager file (*.mat)');
else
    pathname = [cd '\'];
end
holdquest = questdlg('hold on?');

load(fullfile(pathname,filename));
display(f);
display(t);
options = inputdlg({'Frequency range:','Time range:'},'options',1,{'8 12','-1000 3000'});
freqrange = str2num(options{1});
timerange = str2num(options{2});




D=squeeze(mcD);
flow = find(freqrange(1) == f);
fhigh = find(freqrange(2) == f);

tstart = find((timerange(1)/1000) == round(t*1000)/1000);
tend = find((timerange(2)/1000) == round(t*1000)/1000);





    fD = mean(D(flow:fhigh,tstart:tend),1);
    if length(holdquest) == 3;
        hold on;
    else    
    figure;
    end
    plot(t(tstart:tend),fD,'LineWidth',2,'LineSmoothing','on');
   
    if length(holdquest) ~= 3;
    xlim([t(tstart),t(tend)]);
    title([strrep(name,'_','\_') ' from ' num2str(freqrange(1)) ' Hz to ' num2str(freqrange(2)) ' Hz']);
    end


if ~exist([pathname '\freq_extract'],'dir');
    mkdir(pathname,'freq_extract');
end

cd([pathname 'freq_extract']);
saveas(gcf,['fe_' strrep(num2str(freqrange),'  ','_') 'Hz_' name],'fig');
print(gcf,['fe_' strrep(num2str(freqrange),'  ','_') 'Hz_' name],'-dpng','-r600');
save(['fe_' strrep(num2str(freqrange),'  ','_') 'Hz_' filename],'fD','t','name','freqrange','timerange');

cd('..');
