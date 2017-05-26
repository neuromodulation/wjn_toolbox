function [newalpha,r1,m]=benhoch_correction(cont,alpha)
%  function benhoch_correction(cont)
% OUTPUT
% newalpha = pvalue corrected by means of the standard linear step-up procedure (Benjamin-Hoch Correction). This value is conservative by a factor m0/m when controlling the %		FDR. m0 is the number of true hypotheses. m is the number of total hypotheses.
%  r1 = ind1; number of rejected hypotheses
%  Author: Maria Herrojo Ruiz, 2011
%  Affiliation:  Charité-Universitäts Medizin Berlin
%  Email: maria.herrojo-ruiz@charite.de
%  
%  1st Version March 2011
%  2nd Version 21.April 2011
%% 3nd Version 10.Mai 2011
%  Based on: 
% "The control of the False Discovery Rate in Multiple testing under Dependency". Benjamini, Yekuteli. 2001. The Annals of Statistics.
% "Adaptive Linear Step-up Procedures that control the False Discovery Rate". Benjamini, Krieger, Yekuteli, 2006 Biometrika.




	if ndims(cont)==1
ind=1:length(cont);  %original order
m=length(cont); %total number of hypotheses to be tested
scont=sort(cont);  %increasing order p(1), sorted cont

%%%%%%%%%%%%%%%%%%%%%%%% means: index values 1:10 in scont correspond to index values inds(1:10) in cont
i=[1:m];level=i.*alpha/m;
%  figure;plot(scont,'ch'); hold on; plot(level,'m'); legend('sorted pvalues','step-up thresholds')

indcomp=find(scont<=level);  %compare sorted p-values p(i)<= i*alpha/m, find maximum i for which that holds (increasing p-values)
r1=max(indcomp);%number of rejected hypotheses
newalpha=scont(r1); % all hypotheses with p-values in cont, such that p(i)<=newalpha , are rejected

	elseif ndims(cont)==2

[s1,s2]=size(cont);  m=s1*s2; %total number of hypotheses to be tested
matrixpvalue=reshape(cont,1,s1*s2);  %s1 was rows, s2 was columns. Order in matrixpvalue is 1:s1, s1+1:2*s2, etc. Rows concatenated
scont=sort(matrixpvalue);

i=[1:m];level=i.*alpha/m;
%  figure;plot(scont,'ch'); hold on; plot(level,'m'); legend('sorted pvalues','step-up thresholds')

indcomp=find(scont<=level);  %compare sorted p-values p(i)<= i*alpha/m, find maximum i for which that holds (increasing p-values)
r1=max(indcomp);
newalpha=scont(r1); % all hypotheses with p-values in cont, such that p(i)<=newalpha , are rejected

	end


