function i = wjn_cohfinder(chan1,chan2,cohcomb,exact)

if ~exist('exact','var')
    exact = 0;
end

i1 = unique([ci(chan1,cohcomb(:,1),exact) ci(chan1,cohcomb(:,2),exact)]);
i2 = unique([ci(chan2,cohcomb(:,1),exact) ci(chan2,cohcomb(:,2),exact)]);
i = intersect(i1,i2);