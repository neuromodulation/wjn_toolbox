function sv = wjn_mesh_smooth(mesh,v,sk)

if ~exist('sk','var')
    sk=5;
end

for a = 1:size(v,2)
    sv(:,a)=spm_mesh_smooth(mesh,v(:,a),sk);
    fprintf(['\n' num2str(a) ' / ' num2str(size(v,2)) ])
end