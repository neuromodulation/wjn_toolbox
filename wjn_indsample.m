function [i,cv]=wjn_indsample(i,t)

T=t;
t=i;
res = NaN(1,length(t));

    for i = 1:length(t)

            [m,res(i)] = min(abs(T-t(i)));
            if m > (1/diff(T(1:2)))
                warning('Could not find an index matching the requested time %d sec', t(i));
                res(i) = NaN;
            end

    end
    
    i = res;
    cv=T(i);