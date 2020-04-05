function wjn_recon_print_spw_raw(filename,SPW,fpath)
disp('PRINT EXEMPLAR WAVEFORM IDENTIFICATION.')
try
    D=spm_eeg_load(filename);
catch
    D=filename;
end

if ~exist('SPW','var')
    try 
       SPW = D.SPW;
    catch
        [D,SPW]=wjn_recon_spw(D.fullfile);
    end
end

fname = D.fname;fname =  fname(1:end-4);
if ~exist('fpath','var')
    fpath = wjn_recon_fpath(D.fullfile,'SPW');
end

ix = randi(round(D.time(end)-10)-1);
figint = 4;nfig = 1:figint:D.nchannels;

figure('visible','off')
for a = nfig
    for b = 0:figint-1
        if a+b <= D.nchannels
            subplot(figint,1,b+1)
            plot(D.time,D(a+b,:));hold on
            scatter(D.time(SPW.trough(a+b).i),D(a+b,SPW.trough(a+b).i))
            scatter(D.time(SPW.trough(a+b).ipre),D(a+b,SPW.trough(a+b).ipre))
            scatter(D.time(SPW.trough(a+b).ipost),D(a+b,SPW.trough(a+b).ipost)')
            xlim([ix ix+10]);hold off;title(strrep(D.chanlabels{a+b},'_',' '))
        end
    end
    ylabel('Amplitude [Z]');xlabel('Time [s]');figone(30,50);savefig(fullfile(fpath,['spw_raw_' num2str(a) '_' fname '.fig']))
    print(fullfile(fpath,['SPW_RAW_' num2str(a) '_' fname '.png']),'-dpng','-r90')
end
close