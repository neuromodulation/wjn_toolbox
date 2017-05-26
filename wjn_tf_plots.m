function wjn_tf_plots(filename,clim,xl,yl,p)

if ~exist('p','var')
    p=0;
end

D=spm_eeg_load(filename);
fname = D.fname;

for a = 1:D.nchannels
    figure
    for b = 1:D.ntrials
        subplot(ceil(sqrt(D.ntrials)),ceil(sqrt(D.ntrials)),b)
        imagesc(D.time,D.frequencies,squeeze(D(a,:,:,b)))
        axis xy
        title(strrep([D.chanlabels{a} ' - ' D.conditions{b}],'_',' '))
        if exist('clim','var') && ~isempty(clim)
            caxis(clim)
        end
        if exist('xl','var') && ~isempty(xl)
            xlim(xl),
        end
        if exist('yl','var') && ~isempty(yl)
            ylim(yl);
        end
        colorbar
    end
    if p
        if a==1
            wjn_toppt(fname(1:end-4),'M',a,gcf,0,1)
            pause(2)
            close
        elseif a==D.nchannels
            wjn_toppt(fname(1:end-4),'M',a,gcf,1,0)
            pause(2)
            close
        else
            wjn_toppt(fname(1:end-4),'M',a,gcf,0,0)
            pause(2)
            close
        end
    end
end
