function ci = ci95(data)
% ci = ci95(data)
% data should be in format ntests x nsamples

for a = 1:size(data,1);
    ci(1,a) = 1.96*(std(data(a,:))/sqrt(length(data(a,:))));
end