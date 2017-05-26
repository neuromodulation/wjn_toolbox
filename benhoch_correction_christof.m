function newalpha=benhoch_correction(cont,alpha)
%  function benhoch_correction(cont)

	if ndims(cont)==1
ind=1:length(cont);  %original order
m=length(cont); %total number of hypotheses to be tested
scont=sort(cont);  %increasing order p(1), sorted cont

%%%%%%%%%%%%%%%%%%%%%%%% means: index values 1:10 in scont correspond to index values inds(1:10) in cont
i=[1:m];level=i.*alpha/m;
%  figure;plot(scont,'ch'); hold on; plot(level,'m'); legend('sorted pvalues','step-up thresholds')

indcomp=find(scont<=level);  %compare sorted p-values p(i)<= i*alpha/m, find maximum i for which that holds (increasing p-values)
ind1=max(indcomp);

newalpha=scont(ind1); % all hypotheses with p-values in cont, such that p(i)<=newalpha , are rejected

	elseif ndims(cont)==2

[s1,s2]=size(cont);  m=s1*s2; %total number of hypotheses to be tested
matrixpvalue=reshape(cont,1,s1*s2);  %s1 was rows, s2 was columns. Order in matrixpvalue is 1:s1, s1+1:2*s2, etc. Rows concatenated
scont=sort(matrixpvalue);

i=[1:m];level=i.*alpha/m;
%  figure;plot(scont,'ch'); hold on; plot(level,'m'); legend('sorted pvalues','step-up thresholds')

indcomp=find(scont<=level);  %compare sorted p-values p(i)<= i*alpha/m, find maximum i for which that holds (increasing p-values)
ind1=max(indcomp);

newalpha=scont(ind1); % all hypotheses with p-values in cont, such that p(i)<=newalpha , are rejected

	end


