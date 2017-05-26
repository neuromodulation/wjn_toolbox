function  [cont,tStat,repdiff] = permTestzero(ni, data1)

clear repdiff*
% permutation Test between a vectorial distributions and zero (baseline)
% data1 = 1x ns1  or ns1 x nsampl
% ni = is the total number of permutations (in your case 2^ns= 25)
% Null hypotheses: data1 are not different from zero. Then they must be symmetric around zero. 
% therefore, we can exchange sign (+/- data1(j) makes no difference)
d=ndims(data1); dtotal=d; for i=1:d, if size(data1,i)==1, dtotal=d-1; end,end

data2=zeros(size(data1));



clear vectni repdiff
if dtotal==1 ;
% 	disp(['data should be in format 1 x ns'])
	ns=length(data1);
	%joint distribution
	b=data1;  %1x(ns1+ns2)
	% FOR THOMAS: here new sample distribution 
	ds = size(data1);  %1 x ns
	b = [repmat(0,1,ds(2))];

	%data1, data2 size of ensemble: ns1, ns2 subjects
	% nd(k)
	%diference between means of the original values:
 	mean1=mean(data1);
        mean2=mean(data2);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%now we REPLICATE the ensembles of size 10, via RANDOM PERMUTATIONS from the sign, we make 200/alpha replications (alpha=0.05 -> 4000 iterations)
	
	dcount = 2^ns;  
        if dcount<ni, vectni=1:dcount; 
        else 
           for l=1:ni  %if dcount too big, keep only 5000 replicas, resample with random permutations from 2^ns possible decimal arrays.
           ind=round(dcount*rand); %we need 1 random value taken from [·1 dcount]         
           vectni(l)=ind;
           end
        end 
  	
%          repdiff(1:dcount)=0;

	for it=1:length(vectni)  %full range [1:2^ns] or random selection of 5000 values out of [1:2^ns]
	%pick ni values out of 2^ns posibilities
%  	it2=round(dcount*rand);
	it2=vectni(it);

	msel=repmat(0,1,ns); disno = dec2bin (it2-1); dns = size(disno); mns=size(msel);

   	 for u=1:dns(2)
   	     msel((mns(2)-dns(2))+u) = disno(u)-48;
   	 end;
%         msel
%        Why does the '-48' create an array out of '100000' binary?
%  > dec2bin(32)-48
%  > ans = 1 0 0 0 0 0
%  
%  dec2bin returns a array of class char, or '100000' in this case.
%  subtracting a double from a char gives a double, and the ascii
%  value for '0' is 48. You're doing the same thing as this
%  dec2bin(32) - '0' or this  double('100000') - 48
%  http://www.mathworks.com/matlabcentral/newsreader/view_thread/40505

   	 %create replicas
   	
  	 for k=1:mns(2)
     	   if msel(k) == 0
      	     repb1(k)  = data1(k);repb2(k) = data2(k);
      	    % 'case0'
      	   end
       	 if msel(k) == 1
          repb1(k)  = data2(k);repb2(k) = data1(k);
       	  %  'case1'
       	 end   
         end

	%Now we calculate the difference between the mean of the REPLICA distributions repbS, repbT (for each t-f point)
	repdiff(it)=mean(repb1(:))-mean(repb2(:));
	%[repb1 repb2]
	
	end %iterations

 	  %test statistic: difference between means of both conditions for each time-frequency point
 	  % uses the original data!!!!
  	   tStat=(mean1-mean2);

	%Now we calculate the values of the differences in the replicas BIGGER than the experimental statistic of differences. In ABSOLUTE VALUES
	   %for alpha=0.05; 4000 iterations, only 4000*0.05 values could be bigger

 	% ni number of iterations
	cont=0;
	for it=1:length(vectni)
	if abs(repdiff(it))>abs(tStat)
	cont=cont+1;
	end
	end
	cont=cont/length(vectni); %number of iterations

elseif dtotal==2 
        disp(['data should have ns < nsamp and be in format ns x nsamp'])
        ns=min(size(data1)); %balanced design for paired test
        order=find(size(data1)==min(size(data1))); %order of dimension with number of subjects
	%joint distribution
	% FOR THOMAS: here new sample distribution 
	nsamp = size(data1,setdiff(1:dtotal,order));  %number of samples
	b = [repmat(0,1,ns) repmat(1,1,ns)];

	%data1, data2 size of ensemble: ns1, ns2 subjects
	% nd(k)
	%diference between means of the original values:
 	mean1=mean(data1,order);   mean2=mean(data2,order); 
	

	dcount = 2^ns;  
        if dcount<ni, vectni=1:dcount; 
        else 
           for l=1:ni  %if dcount too big, keep only 5000 replicas, resample with random permutations from 2^ns possible decimal arrays.
           ind=round(dcount*rand); %we need 1 random value taken from [·1 dcount]         
           vectni(l)=ind;
           end
        end 
%    	figure;hist(vectni,100)
%          repdiff(1:length(vectni),:)=0;

	for it=1:length(vectni)  %full range [1:2^ns] or random selection of 5000 values out of [1:2^ns]
	%pick ni values out of 2^ns posibilities
%  	it2=round(dcount*rand);
	it2=vectni(it);

	msel=repmat(0,1,ns); disno = dec2bin (it2-1); dns = size(disno); mns=size(msel);
    	for u=1:dns(2)
        	msel((mns(2)-dns(2))+u) = disno(u)-48;
    	end;
    
         for k=1:mns(2)  %ns
         for t=1:nsamp
         if msel(k) == 0 %no change switch  
         repb1(k,t)  = data1(k,t);repb2(k,t) = data2(k,t);
         elseif msel(k) == 1  %change switch
         repb1(k,t)  = data2(k,t);repb2(k,t) = data1(k,t);
         end

         end
         end
        
        repdiff(it,:)=(mean(repb1,order)-mean(repb2,order)); %mean across subj
        end %it

        %test statistic: difference between means of both conditions for each time-frequency point
 	% uses the original data!!!!
  	tStat=(mean1-mean2);


 	% ni number of iterations
	cont=zeros(1,nsamp);
	for it=1:length(vectni)
          for t=1:nsamp
	  if abs(repdiff(it,t))>abs(tStat(t))
	  cont(1,t)=cont(1,t)+1;
	  end
	  end
        end
	
        cont=cont/length(vectni); %numb

   %cont gives the probability that the differences of the replicas are bigger than the current statistic. This probability should be smaller or equal than 0.05

elseif dtotal==3 
        disp(['data should have ns < nf < nsamp and be in format nsamp x nfreq x ns'])
        ns=min(size(data1)); %balanced design for paired test
        order=find(size(data1)==min(size(data1))); %order of dimension with number of subjects
	%joint distribution
	% FOR THOMAS: here new sample distribution 
        dim= setdiff(1:dtotal,order); % dimensions-orders which are not the subject dimension
        s1=size(data1,dim(1)); s2=size(data1,dim(2));  
        indfreq=find([s1,s2]==min([s1,s2])); indsamp=find([s1,s2]==max([s1,s2])); 
        eval(['nfreq=s' num2str(indfreq) ';']) 
        eval(['nsamp=s' num2str(indsamp) ';']) %number of samples
	b = [repmat(0,1,ns) repmat(1,1,ns)];

	%data1, data2 size of ensemble: ns1, ns2 subjects
	% nd(k)
	%diference between means of the original values:
 	mean1=mean(data1,order);   mean2=mean(data2,order); 
	
	
	dcount = 2^ns;  
        if dcount<ni, vectni=1:dcount; 
        else 
           for l=1:ni  %if dcount too big, keep only 5000 replicas, resample with random permutations from 2^ns possible decimal arrays.
           ind=round(dcount*rand); %we need 1 random value taken from [·1 dcount]         
           vectni(l)=ind;
           end
        end 

	for it=1:length(vectni)  %full range [1:2^ns] or random selection of 5000 values out of [1:2^ns]
	%pick ni values out of 2^ns posibilities
%      it2=round(dcount*rand);
	it2=vectni(it);

	msel=repmat(0,1,ns); disno = dec2bin (it2-1); dns = size(disno); mns=size(msel);
    	for u=1:dns(2)
        	msel((mns(2)-dns(2))+u) = disno(u)-48;
    	end;
    
         for k=1:mns(2)  %ns
         for t=1:nsamp
         for r=1:nfreq
         if msel(k) == 0 %no change switch  
         repb1(t,r,k)  = data1(t,r,k);repb2(t,r,k) = data2(t,r,k);
         elseif msel(k) == 1  %change switch
         repb1(t,r,k)  = data2(t,r,k);repb2(t,r,k) = data1(t,r,k);
         end

         end
         end
         end
        
        repdiff(:,:,it)=(mean(repb1,order)-mean(repb2,order)); %mean across subj
      end %it

        %test statistic: difference between means of both conditions for each time-frequency point
 	% uses the original data!!!!
  	tStat=(mean1-mean2);


 	% ni number of iterations
	cont=zeros(nsamp,nfreq);
	for it=1:length(vectni)
          for t=1:nsamp
 		for r=1:nfreq
	  if abs(repdiff(t,r,it))>abs(tStat(t,r))
	  cont(t,r)=cont(t,r)+1; end
          	end
	  end
        end
	
        cont=cont/length(vectni); %num

end %dtotal
