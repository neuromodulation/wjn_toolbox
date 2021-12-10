function epochs = wjn_raw_epoch(data,i,w)

n=0;
for a = 1:length(i) 
    if i(a)>-w(1) && i(a)<length(data)-w(2)
        n=n+1;
        epochs(n,:) = data(:,i(a)+w(1):i(a)+w(2));
    end
end
    