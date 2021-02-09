function wjn_nn_3D_plotter(cc)
%%
clear 
close all
ni = 6;
nh =[14 10 8];
no = 7;
%  inputs = {'\theta','\beta','\gamma' '\theta','\beta','\gamma' '\theta','\beta','\gamma' };
inputs={'LFP','ECOG','Accelerometry','Daytime','Stimulation History','Medication'};

%  inputs = [strcat('premotor ',inputs) strcat('motor  ',inputs) strcat('sensory  ',inputs)];
outputs = {'Eating','Writing','Speech','Gait','Sleep','Sports','Phone'};
% inputs=outputs;
% outputs={'Direction','Amplitude','Pulse Width','Frequency'}
 nah = [ni nh no];
mh = max(nah);
dx = 2*mh/length(nah);
if ~exist('cc','var')
    cc = [.8 .8 .8];
end
cc=repmat(cc,[30,1]);

[x,y,z] = sphere(50);
r = .35;
figure
% set(gcf,'color','k')
% set(gcf, 'InvertHardcopy', 'off')
for a = 1:length(nah)
        if a>1
            dd = dd+((nah(a-1)-nah(a))/2);
        else
            dd=0;
        end
     for b = 1:nah(a)
        xs(a)=dx*a;
        zs(a,b)=dd+b;
        s=surf(xs(a)+x.*r,y.*r,zs(a,b)+z.*r,'FaceColor',cc(a,:),'LineStyle','none');
%     s.FaceLighting = 'none';
%     s.FaceAlpha = .5;
        hold on
        if a>1
            for c = 1:nah(a-1)
                plot3([xs(a-1) xs(a)],[0 0],[zs(a-1,c) zs(a,b)],'color',[.5 .5 .5])
            end
        end
    
    end
end
set(gca,'color','k')

camlight
% light('Position',[0 0 0])
% shading interp
lighting('gouraud')
axis equal
axis off
xlim([min(xs)-1 xs(end)+1])
zlim([min(min(zs))-1 max(max(zs))+1])
grid off
box off
view(0,0)
% 
% for a = 1:length(fbands)
%     if a==1
%         fbands{a}='raw';
%     elseif a==2
%         fbands{a}='variance';
%     end
% end
for a = 1:length(inputs)
    text(2,0,zs(1,a),inputs{a},'color','k','HorizontalAlignment','right','FontSize',12)
end
% outputs = {'bradykinesia','tremor','dyskinesia','walking','freezing','dysarthria'};


for a = length(outputs):-1:1;
text(xs(end)+1,0,zs(end,a)+.5,outputs{a},'color','k','HorizontalAlignment','left','FontSize',12)
end
camlight
lighting('flat')
view(-35,-25)
figone(20,40)
% xlim([3.8 25])
% zlim([-2 11])
% myprint('nn_parameters')
