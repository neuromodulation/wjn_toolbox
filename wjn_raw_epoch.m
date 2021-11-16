function [epochs,x] = wjn_raw_epoch(data,i,s)

if length(s) ==1
    s(2) = s(1);
end
n=0;
for a = 1:length(i)  
        n=n+1;
        try
            epochs(n,:) = data(:,[i(a)-s:i(a)+s]);
        end
    end
end
    