a=[1,2,3,4,5];
b=[6,7,8,9,10];
jd=cat(2,a,b);

% Take all possible combinations from elements in jd in groups of 5
C=combnk(jd,5)

% This would give the replicas of distirbution "a". Then, replicas of distribution "b" would be setdiff(jd,"a").