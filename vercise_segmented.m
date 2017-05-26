function [i,s,ic]=vercise_segmented(side,channels)


if strcmpi(side,'L')
    s = {'antero-lateral','posterior','antero-medial','anterior','postero-lateral','postero-medial','antero-lateral','posterior','antero-medial'};
    i = {'56','67','57','25','36','47','23','34','24'};
elseif strcmpi(side,'R')
    s = {'antero-lateral','posterior','antero-medial','anterior','postero-lateral','postero-medial','antero-lateral','posterior','antero-medial'};
    i = {'56','57','67','25','47','36','24','34','23'};
end



if exist('channels','var')
    
    for a = 1:length(channels);
        ch{a} = channels{a}(end-2:end);
    end
    for a = 1:length(i);
        ic(a) = ci([side i{a}],ch);
    end
else
    ic =[];
end
        