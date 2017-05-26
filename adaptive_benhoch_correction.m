function [p_thresh_adapt, p_thresh]=adaptive_benhoch_correction(cont,alpha,mode)
%  
% Adaptive Linear Step-up Procedures that control the False Discovery Rate
% 
% function [p_thresh_adapt, p_thresh]=adaptive_benhoch_correction(cont,alpha,mode)
%
%  INPUT
%  cont  = matrix (1D or 2D) containing the pvalues.
%  alpha = 0.05 is in this case not the significance level but the FALSE DISCOVERY RATE (FDR) to be controlled: the probability of detecting a H0 hypothesis as false, when it is true. 
%          0.05 is a good FDR value. 
%  mode = 'TST', 'LSU' (TST:default) type of adaptive procedure to be used: recommended: TST (two-stage linear step-up procedure)
%                            TST = "two-stage linear step-up procedure"; LSU--> MED-LSU = "median adaptive lienar step-up procedure"
%
% OUTPUT
%  p_thresh  = threshold-pvalue corrected by means of the standard linear step-up procedure (Benjamin-Hoch Correction). This value is conservative by a factor m0/m when controlling the %		FDR. m0 is the number of true hypotheses. m is the number of total hypotheses.
% p_thresh_adapt = threshold-pvalue corrected by means of an adaptive prodedure: (1) m0 is estimated; (2) the linear step-up procedure is used with a corrected alpha value (alpha*m/m0). 
%                  The TST adaptive procedure controls the FDR exactly at level alpha.

%  uses:  benhoch_correction.m
% 
%  Author: Maria Herrojo Ruiz, 2011
%  Affiliation:  Charité-Universitäts Medizin Berlin
%  Email: maria.herrojo-ruiz@charite.de
%  
%  1st Version March 2011
%  2nd Version 21.April 2011
%  3nd Version 10.Mai 2011
%  Based on: 
% "The control of the False Discovery Rate in Multiple testing under Dependency". Benjamini, Yekuteli. 2001. The Annals of Statistics.
% "Adaptive Linear Step-up Procedures that control the False Discovery Rate". Benjamini, Krieger, Yekuteli, 2006 Biometrika.

if nargin<3
mode='TST'
end
 
%_format sorted data
  if ndims(cont)==1
  ind=1:length(cont);  %original order
  m=length(cont); %total number of hypotheses to be tested
  sortpvalue=sort(cont);  %increasing order p(1), sorted cont

  elseif ndims(cont)==2

  [s1,s2]=size(cont);  m=s1*s2; %total number of hypotheses to be tested
  matrixpvalue=reshape(cont,1,s1*s2);  %s1 was rows, s2 was columns. Order in matrixpvalue is 1:s1, s1+1:2*s2, etc. Rows concatenated
  sortpvalue=sort(matrixpvalue);
  end

%__________LINEAR STEP_UP PROCEDURE
[p_thresh]=benhoch_correction(cont,alpha);


%__________ ADAPTIVE PROCEDURES 
                 
                %%%%%%%%% Median ADAPTIVE linear step-up procedure (MED-LSU)
                %%%%%%%%%%    Uses the median of the p-values %%%%%%%%
                switch mode
                case 'LSU' 
                 clear m0;  m0=[];
                 m0=(m-m/2)/(1-median(sortpvalue)); %from sorted pvalues
                case 'TST'
                 m0=[];
                [newalpha,r1]=benhoch_correction(cont,alpha/(1+alpha));
                     if r1==0, p_thresh_adapt=0; elseif r1==m, p_thresh_adapt=1; else        %if r1=0, reject no hypotheses; r1=m, reject ALL hypotheses
                     m0=m-r1;  end
                end




%%%%%%%%%%% now use the linear step up procedure with qadap=alpha*m/m0 instead of alpha
         if ~isempty(m0)
         qadapt=(alpha/(1+alpha))*m/m0 ;
	 [p_thresh_adapt,r1]=benhoch_correction(cont,qadapt);
         else  
         p_thresh_adapt=0;
         end



