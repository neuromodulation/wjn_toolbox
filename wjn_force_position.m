function [p,force]=wjn_force_position(j,pos,force)

if ~exist('force','var')
    force = .75;
end

p = axis(j);
x=p(1);

if x>pos
    while p(1) > pos
%         p=read(j,1*abs(diff([p(1) pos])));
            p=read(j,force);
    end
    p=read(j,-force);
%     p=read(j,-force);
%     p=read(j,-force);
    p=read(j,0);
elseif x<pos
    while p(1) < pos
%         p=read(j,-1*abs(diff([p(1),pos])));
        p=read(j,-force);
    end
    p=read(j,force);
%     p=read(j,force);
%     p=read(j,force);
    p=read(j,0);
    p=read(j,0);
end
p = p(1);