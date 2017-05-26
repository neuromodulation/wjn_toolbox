
function [] = spiralplotter(n,accu)
%Plots a spiral of n-quarter turns and a specified accuracy (points between
%each quarter-turn). Uses a fibonacci sequence generator (fibonacci.m) and
%a square generator (plot_square.m)
close all
n=4
accu = 100
hold all
k = fibonacci(n);
pos = [0 0];
m = [0;0];
for i=1:n
    acc = accu/(1.618^i);
    switch i > 0
        case i == 1
            j = plot_square(k(i), pos(1), pos(2));
            plot(j(1:5,1),j(1:5,2),'g')
            m = fliplr(circle_plot(k(i).^2,pos(1),pos(2)-k(i),acc,1));
        case mod(i,4) == 1
            pos(1) = pos(1) - k(i-2);
            pos(2) = pos(2) + k(i);
            j = plot_square(k(i), pos(1), pos(2));
            plot(j(1:5,1),j(1:5,2),'g')
            p = fliplr(circle_plot(k(i).^2,pos(1),pos(2)-k(i),acc,1));
            m = cat(2,m,p);
        case mod(i,4) == 2
            pos(1) = pos(1) - k(i);
            pos(2) = pos(2);
            j = plot_square(k(i), pos(1), pos(2));
            plot(j(1:5,1),j(1:5,2),'g')
            q = circle_plot(k(i).^2,pos(1)+k(i),pos(2)-k(i),acc,2);
            m = cat(2,m,q);
        case mod(i,4) == 3
            pos(1) = pos(1);
            pos(2) = pos(2) - k(i-1);
            j = plot_square(k(i), pos(1), pos(2));
            plot(j(1:5,1),j(1:5,2),'g')
            r = fliplr(circle_plot(k(i).^2,pos(1)+k(i),pos(2),acc,3));
            m = cat(2,m,r);
        case mod(i,4) == 0
            pos(1) = pos(1) + k(i-1);
            pos(2) = pos(2) + k(i-2);
            j = plot_square(k(i), pos(1), pos(2));
            plot(j(1:5,1),j(1:5,2),'g')
            s = circle_plot(k(i).^2,pos(1),pos(2),acc,4);
            m = cat(2,m,s);
    end
end
plot(m(1,1:length(m)),m(2,1:length(m)),'r')