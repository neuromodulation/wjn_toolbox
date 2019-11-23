function [pcs,fn] = wjn_peak_centered_spectra(pow,f,peakf,freqrange)

if ~exist('freqrange','var')
    freqrange = [-3 5];
end

if size(pow,2) == length(peakf) 
    pow = pow';
end

for a = 1:size(pow,1)
    fi = wjn_sc(f,peakf+freqrange(1)):wjn_sc(f,peakf+freqrange(2));
    pcs(a,:) = pow(a,fi);
end

fn = linspace(freqrange(1),freqrange(2),length(fi));