
x1 = rand(10000,1);
x2 = rand(10000,1)*3;
x3 = x1+x2;


 t = [0:1/30000:0.2];
 A = 1;
 f =10000;
 y = A*sin(2*pi*f*t);
 plot(t(1:100),y(1:100))

a==0
while a == 0
    
%  player = audioplayer(y.*rand(1,1),100,16)
% stop(player)
player = audioplayer(y(1:50).*rand(1,50),100,16)
% pause(player)
play(player)
% stop(player)
end