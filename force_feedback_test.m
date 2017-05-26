% 
% 

clear
j = vrjoystick(1,'forcefeedback');

t=[0:1:1000000];
A=1;
f=.01;
y=A*sin(f*t);

j = vrjoystick(1,'forcefeedback');

for a = -1:.05:1
    wjn_force_position(j,a,.1)
end

%%
read(j,0);
% 

% read(j,0)
x=0;
f = -.5;
figure
while x==0
    
    p = read(j,f);
%     p=wjn_force_position(j,.95);
    bar(p(1))
    ylim([-1 1])
    title(num2str(f))
        drawnow
    if p(1) <=0
        wjn_force_position(j,.98,1);
        f=-rand(1,1);
    end

end
    


