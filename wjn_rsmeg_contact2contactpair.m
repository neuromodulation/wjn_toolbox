function ncoords = wjn_rsmeg_contact2contactpair(coords)

for a = 1:size(coords,1)-1;
    ncoords(a,:) = nanmean([coords(a,:);coords(a+1,:)]);
end