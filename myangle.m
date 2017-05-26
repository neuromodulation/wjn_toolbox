   function angle=myangle(v1,v2)
   %%
   
   
   
   p1 = [v1(1,1) v1(1,2)];
   p2 = [v1(end,1) v1(end,2)];
   p3 = [v2(end,1) v2(end,2)];
   clear v1 v2
%    figure
%    plot(v1(:,1),v1(:,2),v2(:,1),v2(:,2))
%    xlim([-5 5]),ylim([-5 5])
   
 v1 = p1 - p2;
x1 = v1(1);
y1 = v1(2);
v2 = p1 - p3;
x2 = v2(1);
y2 = v2(2);
angle = abs(atan2d(y1,x1) - atan2d(y2,x2));


vx = v2(1); vy= v2(2); ux = v1(1); uy = v1(2);
va = -atan2d(vy,vx);         % angle of v relative to x-axis (clockwise = +ve)
ua = -atan2d(uy,ux);         % angle of u relative to x-axis (clockwise = +ve)
angle = abs(va - ua);                             % angle va relative to ua
% angle = A - 360*(A > 180) + 360*(A < -180)   % correction put in [-180,180]
if abs(angle)>180
    angle = 360-abs(angle);
end
% title(num2str(angle))
   
    end