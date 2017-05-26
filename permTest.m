function  [cont,tStat,repdiff] = permTest(ni,d1,d2,mode)
% [cont,tStat,repdiff] = permTest(ni,d1,d2,mode)
% permutation Test between two vectorial distributions, using mean or median as test statistic
% INPUT
% ni = number of permutations (use 5000)
% d1 = 1x ns1  or ns1 x nsampl, vector 1  
% d2 = 1x ns2  or ns1 x nsampl, vector 2
% ns is the number of subjects, nsamp is the number of samples, can also be number of freqs or whatever
% mode = 'avg' or 'med'
% OUTPUT
% cont = p-values after permutation test. In format 1xns or nsxnsampl 

d=ndims(d1); dtotal=d; for i=1:d, if size(d1,i)==1, dtotal=d-1; end,end
% dtotal ; %total number of dimensions

if nargin<4
mode='avg';
end

clear repdiff*

if dtotal==1  ; %1Dimensional vector for 2 conditions, 
% 	disp(['data should be in format 1 x ns']);
	ns1=length(d1);
	ns2=length(d2);

%joint distribution
      b=cat(2,d1,d2);  %1x(ns1+ns2)


%d1, d2 size of ensemble: ns1, ns2 subjects

%diference between means of the original values:
   if mode=='avg'
   mean1=mean(d1);   mean2=mean(d2); 
   elseif mode=='med'
   mean1=median(d1);   mean2=median(d2);
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now we REPLICATE the 2 ensembles of size 20, via RANDOM PERMUTATIONS from the JOINT DISTRIBUTION b, we make 200/alpha replications (alpha=0.05 -> 4000 iterations)


for it=1:ni

%repbS=zeros(nf, nSamples, 9);
%repbT=zeros(nf, nSamples, 9);

ind=randperm(ns1+ns2); %permuted index
%  ind2=randperm(ns2);

for k=1:ns1 %first ns indexes for first distribution
repb1(k)=b(ind(k)); %replicas
end
for k=(ns1+1):ns1+ns2 %next 9 indexes for the Tonic
repb2(k-ns1)=b(ind(k));
end
%Now we calculate the difference between the mean of the REPLICA distributions repbS, repbT (for each t-f point)
 if mode=='avg'
 repdiff(it)=mean(repb1(:))-mean(repb2(:));
 elseif mode=='med'
 repdiff(it)=median(repb1(:))-median(repb2(:));
 end


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


elseif dtotal==2 
        disp(['data should have ns < nsamp and be in format ns x nsamp'])
        ns=min(size(d1)); %balanced design
        ns1=ns; ns2=ns;
        order=find(size(d1)==min(size(d1)));; %order of dimension with number of subjects
	%joint distribution
	% FOR THOMAS: here new sample distribution 
	nsamp = size(d1,setdiff(1:dtotal,order)); 
	if mode=='avg'
	%diference between means of the original values:
 	mean1=mean(d1,order);   mean2=mean(d2,order); 
	elseif mode=='med'
	mean1=median(d1,order);   mean2=median(d2,order);
	end

	%joint distribution
        b=cat(order,d1,d2);  %(ns1+ns2) x nsamp


	for it=1:ni

	ind=randperm(ns1+ns2); %permuted index

        for t=1:nsamp
	for k=1:ns1 %first ns indexes for first distribution
	repb1(k,t)=b(ind(k),t); %replicas
	end
	for k=(ns1+1):ns1+ns2 %next 9 indexes for the Tonic
	repb2(k-ns1,t)=b(ind(k),t);
	end
        end%t
	%Now we calculate the difference between the mean of the REPLICA distributions repbS, repbT 	(for each t-f point)
	if mode=='avg'
 	repdiff(it,:)=(mean(repb1,order)-mean(repb2,order)); %mean across subj
        elseif mode=='med'
        repdiff(it,:)=(median(repb1,order)-median(repb2,order));
 	end
	end %iterations


     %test statistic: difference between means of both conditions for each time-frequency point
 	% uses the original data!!!!
  	if mode=='avg', tStat=(mean1-mean2);elseif mode=='med', tStat=(median1-median2);end

 	% ni number of iterations
	cont=zeros(1,nsamp);
	for it=1:ni
          for t=1:nsamp
	  if abs(repdiff(it,t))>abs(tStat(t))
	  cont(1,t)=cont(1,t)+1;
	  end
	  end
        end
	
        cont=cont/ni; %numb


end

