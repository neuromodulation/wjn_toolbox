function  [cont,tStat,repdiff] = permTest_paired(ni,d1,d2)

clear repdiff*
%permutation Test between two vectorial distributions, for matched pairs (x1--y1; x2--y2; etc)
% d1 = 1x ns1
% d2 = 1x ns2
% ni = is the total number of permutations (in your case 2^ns= 2^5)
ns1=length(d1);
ns2=length(d2);

ns1==ns2; %must be the same, for paired samples

%joint distribution
      b=[-1,-1,-1,-1,-1,1,1,1,1,1]; %we will resample the sign of the pairs (x1-y1; x2-y2; etc); size 1x 2ns
     
%d1, d2 size of ensemble: ns1, ns2 subjects

%diference between means of the original values:
  mean1=mean(d1);   mean2=mean(d2); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now we REPLICATE the 2 ensembles of size 20, via RANDOM PERMUTATIONS from the JOINT DISTRIBUTION b, we make 200/alpha replications (alpha=0.05 -> 4000 iterations)
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%%% NOT FINISHED
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
for it=1:ni

%repbS=zeros(nf, nSamples, 9);
%repbT=zeros(nf, nSamples, 9);

ind=randperm(2*ns); %permuted index
%  ind2=randperm(ns2);

for k=1:ns1 %first ns indexes for first distribution
repb1(k)=b(ind(k)); %replicas
end
for k=(ns1+1):ns1+ns2 %next 9 indexes for the Tonic
repb2(k-ns1)=b(ind(k));
end
%Now we calculate the difference between the mean of the REPLICA distributions repbS, repbT (for each t-f point)
repdiff(it)=mean(repb1(:))-mean(repb2(:));

end %iterations

   %test statistic: difference between means of both conditions for each time-frequency point
   % uses the original data!!!!
     tStat=(mean1-mean2);


%Now we calculate the values of the differences in the replicas BIGGER than the experimental statistic of differences. In ABSOLUTE VALUES
   %for alpha=0.05; 4000 iterations, only 4000*0.05 values could be bigger

 % ni number of iterations
cont=0;
for it=1:ni
if abs(repdiff(it))>abs(tStat)
cont=cont+1;
end
end
cont=cont/ni; %number of iterations

%cont gives the probability that the differences of the replicas are bigger than the current statistic. This probability should be smaller or equal than 0.05

