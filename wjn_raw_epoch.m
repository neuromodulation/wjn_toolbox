function epochs = wjn_raw_epoch(data,trl)

if ~size(trl,2)==3
    keyboard
end



n=0;
for a = 1:size(trl,1)    
    if trl(a,1)>0 && trl(a,end)<length(data)
        n=n+1;
        epochs(n,:) = data(:,trl(a,:));
    end
end
    