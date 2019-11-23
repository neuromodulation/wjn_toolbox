function [rsc,pairs]=wjn_rs_find_connectivity(pairs,matrix,names)


try
matrix = load(matrix,'X','mat');
try
matrix = matrix.X;
catch
    matrix = matrix.mat;
end
catch
end

if ~iscell(names)
    names = table2cell(readtable(names,'Delimiter',' '));
end



rsc=[];
np=0;
for a = 1:length(pairs) 
    xi=find(strncmp(pairs{a,1},names,length(pairs{a,1})));
    yi=find(strncmp(pairs{a,2},names,length(pairs{a,1})));
%     if isempty(xi) || isempty(yi)
%         xi=ci(pairs{a,1},names);
%         yi=ci(pairs{a,2},names);
        if isempty(xi) || isempty(yi)
%             keyboard
        warning('no pair found...')
        np=np+1;
        rsc(a,1)=nan;
%         else
%             rsc(a,1) = matrix(xi(1),yi(1));
%         end
    else
    rsc(a,1) = matrix(xi(1),yi(1));
    end
end
disp([num2str(np) ' pairs not found'])