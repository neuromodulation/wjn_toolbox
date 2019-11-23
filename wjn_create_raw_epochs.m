function [i,iall,trl]=wjn_create_raw_epochs(samples,interval)
n=0;
for a = 1:length(samples)
    if (samples(a)+interval(1)>1) 
        n=n+1;
        i(n,:) = samples(a)+interval(1)+1:samples(a)+interval(2);
        trl(n,:) = [samples(a)+interval(1)+1 samples(a)+interval(2) interval(1)];
    end
end
iall=sort(unique(i(:)));