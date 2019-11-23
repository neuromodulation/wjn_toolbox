function D = wjn_eeg_vm_conditions(filename)

D = wjn_sl(filename);

if isempty(ci('S 16',D.condlist)) && ~isempty(ci('S 17',D.condlist))
    oconds = {'S  1','S  2','S  3','S  9','S 10','S 11','S 17','S 18','S 19', 'S 24','S 25','S 26'};
else
    oconds = {'S  1','S  2','S  3','S 16','S 17','S 18', 'S  9','S 10','S 11','S 24','S 25','S 26'};
end
    nconds  = {'go_aut','move_aut','stop_aut','go_aut','move_aut','stop_aut'...
            'go_con','move_con','stop_con','go_con','move_con','stop_con'};
   
        D.oldconditions = D.conditions;
        

for a = 1:length(oconds)
    D=conditions(D,D.indtrial(oconds{a}),nconds{a});
end

fullconds = D.conditions;
[~,conds]=strtok(fullconds,'_');
cc = {'_aut','_con','_aut'};
D.blockorder = ci(conds{1},cc(1:2));
i=find(mydiff(strcmp(conds,cc{D.blockorder+1}))==-1);
i=i-1;
i(end+1)=D.ntrials;
n=1;
for a = 1:length(i)
    for b = n:i(a)
        nnconds{b} = [fullconds{b} '_b' num2str(a)];
%         D=conditions(D,b,);
    end
    D.blocks{a} = n:b;
    n=b+1;
    
end
% keyboard
% D=conditions(D,':',nnconds);
D.nnconds=nnconds;
D=condlist(D,{'go_aut','move_aut','stop_aut','go_con','move_con','stop_con'})
save(D)