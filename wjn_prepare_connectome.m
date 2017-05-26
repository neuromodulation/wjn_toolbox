function wjn_prepare_connectome(filename,fname)
disp(['...load ' filename '...'])
load(filename,'fibers')
disp('...create kdt...')
kdt = KDTreeSearcher(fibers(:,1:3),'Distance','Chebychev');
disp(['...save kdt_' fname])
save(['kdt_' fname],'kdt')
ni=[];
roi = [-17  -9 0;17 -9 0]; % Basal Ganglia crop
tt=tic;
for a = 1:size(roi,1) 
    disp(['...search ' num2str(a) '. side...'])
    i = rangesearch(kdt,roi(a,:),20,'Distance','Chebychev');
    ni = [ni, i{1}];
end 
toc(tt)
disp('...crop fibers...');
bgcrop= fibers(unique(ni),1:4);
disp('...create kdtree for crop...')
kdbg = KDTreeSearcher(bgcrop(:,1:3),'Distance','Chebychev');
disp(['...save bgcrop_' fname '...'])
save(['bgcrop_' fname],'bgcrop','kdbg')
clear a ni i 
