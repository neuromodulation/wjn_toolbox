function results = wjn_recon_spw_results(filename)

T=readtable(filename);

channels = unique(T.Channel);
phases = {'trough','peak'};
measures = T.Properties.VariableNames(3:end);

results.channels = channels;
for a = 1:length(measures)
    for b = 1:length(phases)
        for c = 1:length(channels)
             ic = find(ismember(T.Channel,channels{c}));
            ip = find(ismember(T.Phase,phases{b}));
            i = intersect(ic,ip);
            results.raw.(measures{a}){c,b} = T.(measures{a})(i);
            results.(measures{a})(c,b) = nanmean(T.(measures{a})(i));
      end
    end
 
end
for a = 1:length(channels)
   results.Vsharpnessratio(a,1) = log(nanmax([results.Vsharpness(a,1)./results.Vsharpness(a,2),results.Vsharpness(a,2)./results.Vsharpness(a,1)]));
   results.Ifanofactor(a,:)=[std(results.raw.Imean{a,1}.^2)/nanmean(results.raw.Imean{a,1}) std(results.raw.Imean{a,2}.^2)/nanmean(results.raw.Imean{a,2})];
     
end

