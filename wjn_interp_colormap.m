function nc=wjn_interp_colormap(cc,n)

if size(cc,1)<9
    for a = 1:3
     nc(:,a) = linspace(cc(1,a),cc(end,a),9);
    end
    cc=nc;
    clear nc;
end

if ~exist('n','var')
    n=100;
else
    n=round(n/length(cc(:,1)))+1;
end

nc(:,1) = interp(cc(:,1),n);
nc(:,2) = interp(cc(:,2),n);
nc(:,3) = interp(cc(:,3),n);

nc(nc>1) = 1;
nc(nc<0) = 0;