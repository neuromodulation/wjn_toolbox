function [s,ss]=wjn_ipsi_contra(side1,side2)

if ischar(side2)
    side2 = {side2};
end
    
for a =1:length(side2)
    if strcmp(side1(1),side2{a}(1))
        s(a) = 2;
        ss{a}='ipsilateral';
    else
        s(a) = 1;
        ss{a} = 'contralateral';
    end
end