function event = berlin_motor_to_event(event,initials,task)

% T. Sander, PTB, 2015
% event decoding for the go / no go (stop) paradigm for Parkinson/Dystonia

if nargin<2
    initials = 'NOTUSED';
end
if nargin<3
    task = 'NOTUSED';
end

trigind  = strmatch('EEG157', {event.type});
motLind  = strmatch('EEG159', {event.type});
motRind  = strmatch('EEG160', {event.type});
trigtime = cell2mat( {event(trigind).time} );
motLtime = cell2mat( {event(motLind).time} )  ;
motRtime = cell2mat( {event(motRind).time} )  ;

% for each motor event find related stimulus trigger and define event
for i = 1:numel(motRtime)
    % VALID RESPONSE TIME 0.1 - 2.0 POST GO CUE
    ind = find(motRtime(i) - trigtime < 2.0 & motRtime(i) - trigtime  > 0.1);
    % motind(i)
    % ind
    if numel(ind)>0 && event(ind(1)).value == 60
       % GO RIGHT WITH MOTOR RIGHT: CORRECT RESPONSE
       event(motRind(i)).type = 'MOTOR_RIGHT_GO_RIGHT';  
       event(ind(1)).type = 'GO_RIGHT_CORRECT';
    end
    if numel(ind)>0 && event(ind(1)).value == 70
       % NO GO RIGHT WITH MOTOR RIGHT: FALSE RESPONSE
       event(motRind(i)).type = 'MOTOR_RIGHT_NO_GO_RIGHT';          
       event(ind(1)).type = 'NO_GO_RIGHT_FALSE_RIGHT';
   end
    if numel(ind)>0 && event(ind(1)).value == 80
        % GO LEFT WITH MOTOR RIGHT: FALSE RESPONSE
        event(motRind(i)).type = 'MOTOR_RIGHT_GO_LEFT'; 
        event(ind(1)).type = 'GO_LEFT_FALSE_RIGHT';     
    end
    if numel(ind)>0 && event(ind(1)).value == 90
        % NO GO LEFT WITH MOTOR RIGHT: FALSE RESPONSE
        event(ind(1)).type = 'MOTOR_RIGHT_NO_GO_LEFT';     
        event(motRind(i)).type = 'NO_GO_LEFT_FALSE_RIGHT';          
    end
end

for i = 1:numel(motLtime)
    % VALID RESPONSE TIME 0.1 - 2.0 POST GO CUE
    ind = find(motLtime(i) - trigtime < 2.0 & motLtime(i) - trigtime  > 0.1);
    % motind(i)
    % ind   
    if numel(ind)>0 && event(ind(1)).value == 60
       % GO RIGHT WITH MOTOR LEFT: FALSE RESPONSE
       event(motLind(i)).type = 'MOTOR_LEFT_GO_RIGHT';          
       event(ind(1)).type = 'GO_RIGHT_FALSE_LEFT';
    end
    if numel(ind)>0 && event(ind(1)).value == 70
       % NO GO RIGHT WITH MOTOR LEFT: FALSE RESPONSE
       event(motLind(i)).type = 'MOTOR_LEFT_NO_GO_RIGHT';          
       event(ind(1)).type = 'NO_GO_RIGHT_FALSE_LEFT';
    end
    if numel(ind)>0 && event(ind(1)).value == 80
       % GO LEFT WITH MOTOR LEFT: CORRECT RESPONSE
       event(motLind(i)).type = 'MOTOR_LEFT_GO_LEFT';          
       event(ind(1)).type = 'GO_LEFT_CORRECT';
    end
    if numel(ind)>0 && event(ind(1)).value == 90
       % NO GO LEFT WITH MOTOR LEFT: FALSE RESPONSE
       event(motLind(i)).type = 'MOTOR_LEFT_NO_GO_LEFT';          
       event(ind(1)).type = 'NO_GO_LEFT_FALSE_LEFT';
    end
end

display(sprintf('MOTOR EVENTS RIGHT HAND'))
display(sprintf('Number of trials: %d', numel(trigind)))
display(sprintf('MOTOR_RIGHT_GO_RIGHT %d', numel(strmatch('MOTOR_RIGHT_GO_RIGHT', {event.type}))))
display(sprintf('MOTOR_RIGHT_NO_GO_RIGHT %d', numel(strmatch('MOTOR_RIGHT_NO_GO_RIGHT', {event.type}))))
display(sprintf('MOTOR_RIGHT_GO_LEFT %d', numel(strmatch('MOTOR_RIGHT_GO_LEFT', {event.type})) ))
display(sprintf('MOTOR_RIGHT_NO_GO_LEFT %d', numel(strmatch('OTOR_RIGHT', {event.type})) ))

display(sprintf('MOTOR EVENTS LEFT HAND'))
display(sprintf('MOTOR_LEFT_GO_RIGHT %d', numel(strmatch('MOTOR_LEFT_GO_RIGHT', {event.type})) ))
display(sprintf('MOTOR_LEFT_NO_GO_RIGHT %d', numel(strmatch('MOTOR_LEFT_NO_GO_RIGHT', {event.type})) ))
display(sprintf('MOTOR_LEFT_GO_LEFT %d', numel(strmatch('MOTOR_LEFT_GO_LEFT', {event.type})) ))
display(sprintf('MOTOR_LEFT_NO_GO_LEFT %d', numel(strmatch('MOTOR_LEFT_NO_GO_LEFT', {event.type})) ))

display(sprintf('TRIGGER EVENTS WITH RIGHT HAND RESPONSES'))
display(sprintf('GO_RIGHT_CORRECT %d', numel(strmatch('GO_RIGHT_CORRECT', {event.type})) ))
display(sprintf('NO_GO_RIGHT_FALSE_RIGHT %d', numel(strmatch('NO_GO_RIGHT_FALSE_RIGHT', {event.type})) ))
display(sprintf('GO_LEFT_FALSE_RIGHT %d', numel(strmatch('GO_LEFT_FALSE_RIGHT', {event.type})) ))
display(sprintf('NO_GO_LEFT_FALSE_RIGHT %d', numel(strmatch('NO_GO_LEFT_FALSE_RIGHT', {event.type})) ))

display(sprintf('TRIGGER EVENTS WITH LEFT HAND RESPONSES'))
display(sprintf('GO_RIGHT_FALSE_LEFT %d', numel(strmatch('GO_RIGHT_FALSE_LEFT', {event.type})) ))
display(sprintf('NO_GO_RIGHT_FALSE_LEFT %d', numel(strmatch('NO_GO_RIGHT_FALSE_LEFT', {event.type})) ))
display(sprintf('GO_LEFT_CORRECT %d', numel(strmatch('GO_LEFT_CORRECT', {event.type})) ))
display(sprintf('NO_GO_LEFT_FALSE_LEFT %d', numel(strmatch('NO_GO_LEFT_FALSE_LEFT', {event.type})) ))


end