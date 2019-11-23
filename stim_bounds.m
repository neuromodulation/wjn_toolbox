function [t1, t2] = stim_bounds(stim, fs, freq)

margin = 20;%s

ostim = ft_preproc_highpassfilter(stim, fs, 1, 4,  'but', 'twopass'); 

spm_figure('GetWin','Graphics');clf;

%%
if freq >0
    isi = fs/freq;
       
    for s = [1 -1]
        clf;
        stim = s*ostim;
        
        stim = stim./spm_percentile(abs(stim), 99);
        
        stim(stim<0.2) = 0;
        
        plot(stim)
        hold on
        
        [jnk, ind] = findpeaks(stim);
        
        ind(find(diff(ind)<(0.4*min(isi)))+1) = [];
        
        plot(ind, stim(ind), 'ro');
        
        ind1 = find(abs(diff(ind) - isi)./isi<=0.05);
        
        if length(ind1)>100
            break;
        end
    end
    
    ind2 = find(diff(ind1)>(length(ind1))/10);
    ind2 = [ind2 ind2+1];
    ind2 = unique([1 ind2 length(ind1)]);
    ind3 = ind1(ind2);
    
    ind4 = [];
    for i = 1:(length(ind3)-1)
        cind = ind3(i):ind3(i+1);
        if (sum(abs(diff(ind(cind)) - isi)./isi<=0.05)/length(cind))>0.5
            ind4 = [ind4; ind3(i) ind3(i+1)];
        end
    end
    
    
    [jnk, ind5] = max(diff(ind4, [], 2));
      
    b1 = ind4(ind5, 1);
    b2 = ind4(ind5, 2);
    
    plot(ind(b1:b2), stim(ind(b1:b2)), 'go');       
    %%
    ind = ind(b1:b2);
    ind(ind>(ind(end)-margin*fs)) =   [];
    ind(ind<(ind(1)+margin*fs)) = [];
    
    plot(ind([1 end]), stim(ind([1 end])), 'k.', 'MarkerSize', 30);
    
    t1 = ind(1);
    t2 = ind(end);
else
    stim = abs(stim);
    stim = stim./max(stim);
    
    plot(stim)
    hold on
    
    ind = [1 find(diff(stim<0.1)) length(stim)];
    
    ind1 = ind;
    ind1(find(diff(ind)<fs)+1) = [];
    
    ind(find(diff(ind)<fs)) = [];
    
    ind = unique([ind ind1]);
    
    ind2 = [];
    for i = 1:(length(ind)-1)
        cind = ind(i):ind(i+1);
        if (sum(stim(cind)<0.1)/length(cind))>0.9
            ind2 = [ind2; ind(i) ind(i+1)];
        end
    end
    
    [jnk, ind3] = max(diff(ind2, [], 2));
    
    
    t1 = ind2(ind3, 1)+margin*fs;
    t2 = ind2(ind3, 2)-margin*fs;    
        
    plot([t1 t2], stim([t1 t2]), 'k.', 'MarkerSize', 30);       
end