function [srho_x,sr_x,brho,bprho,br,bp]=wjn_corr_optimizer(x,y)



[orho,oprho]=corr(x,y,'type','spearman','rows','pairwise');
oorho = orho;
ooprho = oprho;
[or,op]=corr(x,y,'rows','pairwise');
oor = or;
oop = op;
ox = x;
oy=y;
rho_x = [];
rhorun = 1;
n=0;
srho_x=[];
brho = [];
br = [];
while rhorun
    x(rho_x) = nan;
    
    for a = 1:size(x,1)
        nx = x;
        nx(a) = nan;
        [rho(a),prho(a)]=corr(nx,y,'rows','pairwise','type','spearman');
    end

    [mrho,i]=max(rho);

    if abs(mrho)>abs(orho) && prho(i) <= oprho
        rhorun = 1;
        rho_x = [rho_x i];
        orho = rho(i);
        oprho = prho(i);
        n=n+1;
        srho_x(n) = i;
        brho(n) = rho(i);
        bprho(n) = prho(i);
    else
%         brho = [];
        rhorun = 0;
%         srho_x = ;
        
    end
end

r_x = [];
rrun = 1;
n=0;
x=ox;
sr_x=[];
while rrun
    x(r_x) = nan;
    
    for a = 1:size(x,1)
        nx = x;
        nx(a) = nan;
        [r(a),p(a)]=corr(nx,y,'rows','pairwise');
    end

    [mr,i]=max(r);

    if mr>or && p(i) <= op
        rrun = 1;
        r_x = [r_x i];
        or = r(i);
        op = p(i);
        n=n+1;
        sr_x(n) = i;
        br(n) = r(i);
        bp(n) = p(i);
    else
        rrun = 0;
%         br = [];
%         sr_x=[];
    end
end

if ~isempty(brho)
figure
subplot(1,2,1)

for a=1:length(ox)
    scatter(ox(a),oy(a))
    hold on
    text(ox(a),oy(a),num2str(a));
end
ylabel('Y')
xlabel('X')

subplot(1,2,2)
nrho = 1:length(brho);
nr = 1:length(br);
plot([0 nrho],[oorho brho],[0 nr],[oor br]);
legend('Rho','R','location','SouthEast')
hold on

plot([0 nrho],[ooprho bprho],[0 nr],[oop bp],'LineStyle','--')
hold on
plot([0 nrho],ones(1,length(nrho)+1).*.05,'LineStyle','-.')
for a = 1:length(brho)
    text(a,brho(a),num2str(srho_x(a)))
end
for a = 1:length(br)
    text(a,br(a),num2str(sr_x(a)))
end
xlabel('step')
figone(7)
end
    