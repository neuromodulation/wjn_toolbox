function f=wjn_fibersphere(fname)


if ischar(mni)
    mname = mni;
    mni=[];
    nii=wjn_read_nii(mname);
    i=find(nii.img>0);
    for a = 1:length(i)
        [x,y,z] = ind2sub(nii.dim,i(a));
        nmni = [x y z 1]*nii.mat';
        mni(a,:) = nmni(1:3);
    end
end    

if ~exist('mm','var')
    mm = 2;
end
    
ix = fibers(:,4);
istart = find(mydiff(ix));
istop = istart+idx-1;  
if ~cont
    iss = [istart;istop];
    cmni = fibers(iss,:);
else
    cmni = fibers;
end
ni=[];
for a = 1:size(mni,1)
    nmni= mni(a,:);
    i = find(cmni(:,1)<=(nmni(1)+mm) & cmni(:,1)>=(nmni(1)-mm) & ...
    cmni(:,2)<=(nmni(2)+mm) & cmni(:,2)>=(nmni(2)-mm) & ...
    cmni(:,3)<=(nmni(3)+mm) & cmni(:,3)>=(nmni(3)-mm) );
    if ~isempty(i)
        ni = [ni; i];
    end
end

ni = unique(ni);
nn= cmni(ni,4);
fs =[];
fc={};
% for a = 1:length(nn)
%     fs = [fs;[fibers(find(ix==nn(a)),1:3) ones(length(find(ix==nn(a))),1).*a]];
%     fc{a} = [fibers(find(ix==nn(a)),1:3) ones(length(find(ix==nn(a))),1).*a];
% end

for a = 1:length(nn)
    
    fs = [fs;fibers(find(fibers(:,4)==nn(a)),:)];
    fc{a} = [fibers(find(fibers(:,4)==nn(a)),1:3) ones(length(find(ix==nn(a))),1).*a];
end

d.fc = fc;

d.fibers = fs;
d.fourindex = fourindex;

ix = fs(:,4);
nix=unique(ix);

for  a=1:length(nix)
    inix = find(ix==nix(a));
    d.fibers(inix,4) = ones(numel(inix),1).*a;
end
[~,irs]=sort(d.fibers(:,4));
d.fibers = d.fibers(irs,:);
for a = 1:length(nix)
    inix = find(ix==nix(a));
    d.idx(a)=numel(inix);
end


d.ea_fibformat = ea_fibformat;
try
d.voxmm = voxmm;
catch
end

save(fname,'-struct','d');

wjn_ftr2trk(fname);

% [X,Y,Z]=sphere(20);
% 

% 
% figure
% plot3(mni(:,1),mni(:,2),mni(:,3),'k.');
% hold on
% if size(mni,1) == 2
%     surf(X*mm+mni(1,1),Y*mm+mni(1,2),Z*mm+mni(1,3))
%     surf(X*mm+mni(2,1),Y*mm+mni(2,2),Z*mm+mni(2,3))
% end
% for a = 1:length(fc)
%     plot3(fc{a}(:,1),fc{a}(:,2),fc{a}(:,3),'b-');
% end

