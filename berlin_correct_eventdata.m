function trig = berlin_correct_eventdata(trig,initials,task)

if nargin<2
    initials = 'NOTUSED';
end
if nargin<3
    task = 'NOTUSED';
end

ntrig = size(trig, 1);

% glitch in button electronics
if isequal(initials(1:6),'DYST04') && isequal(task(1:3),'MVL')
    trig(2,:) = -1.0*trig(2,:);
end
    
trig  = reshape(trig', 1, []);
trigall = trig;

control_plots = 0;
% control
% if control_plots
%     figure
%     plot( trig )
% end

% correct sign
[pdf, xout] = hist(trig);
if sum(pdf(1:2)) < sum(pdf(9:10))
    trig = -1.0*trig;
end

% correct offset
[pdf, xout] = hist(trig);
if xout(1) > xout(2)-xout(1)
    trig = trig-xout(1);
end

if control_plots
    xout
    figure
    plot( trig )
end

% get levels in steps of 10
[pdf, xout] = hist(trig);

% dystonia 
if isequal(initials(1:4),'DYST') 
    trig = fix(105*trig  / 10) * 10; 
    ind = find(trig < 15); 
    trig(ind) = 0; 
elseif isequal(task(1:4),'EMOT') 
    trig = fix(105*trig  / 10) * 10; 
    ind = find(trig < 15); 
    trig(ind) = 0; 
else 
    % stop paradigm normal case 
    % trig = fix(100*trig/xout(10)  / 10) * 10;   
    trig = fix(105*trig  / 10) * 10; 
    % comment out if motor events are needed 
    % ind = find(trig < 15); 
    % trig(ind) = 0; 
end 

trig = reshape(trig, [], ntrig)';