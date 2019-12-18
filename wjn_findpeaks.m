function [pk,fpk,pkchan,pks,fpks]=wjn_findpeaks(f,pow,freqrange)

i=wjn_sc(f,freqrange(1)):wjn_sc(f,freqrange(end));

for a = 1:size(pow,1)
    [p,fi]=findpeaks(pow(i),'sortstr','descend','Npeaks',1);
    if isempty(p)
        pks(a)=nan;
        fpks(a)=nan;
    else
        pks(a)=p;
        fpks(a)=f(i(fi));
    end
end


    [pk,pkchan]=nanmax(pks);
    fpk=fpks(pkchan);

if isnan(pk)
    [pk,fpk,pkchan,pks,fpks]=wjn_findpeaks(f,pow,[freqrange(1)-.1 freqrange(2)+.1]);
end
% 
