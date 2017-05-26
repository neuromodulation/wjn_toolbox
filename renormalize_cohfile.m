function COH = renormalize_cohfile(file,freqrange)

if isstruct(file)
    COH = file;
else
    load(file)
end
mpow = COH.mpow;
pow = COH.pow; 
f=COH.f;
if freqrange(2) >=53;
    pow(:,:,searchclosest(f,47):searchclosest(f,53)) = 0;
end

sump = sum(mpow(:,searchclosest(f,freqrange(1)):searchclosest(f,freqrange(2))),2);
stdp = std(mpow(:,searchclosest(f,freqrange(1)):searchclosest(f,freqrange(2))),[],2);
% for a = 1:size(mpow,1);
%     entp(a) = my_entropy(mpow(a,searchclosest(f,S.freq(1)):searchclosest(f,S.freq(2))));
% end


for a=1:size(mpow,1);
    COH.rpow(a,:) = (mpow(a,:)./sump(a)).*100;
    COH.spow(a,:) = (mpow(a,:)./stdp(a));
%     epow(a,:) = (mpow(a,:)./entp(a)).*100;
%     for b = 1:size(pow,1);
%         for c = 1:size(pow,3);
%             COH.srpow(a,c) = pow(b,a,c)/sum(pow(b,a,searchclosest(f,freqrange(1)):searchclosest(f,freqrange(2))))*100; 
%         end
%     end
end
end