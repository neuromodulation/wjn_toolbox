function mycallback(tim,event,ao)
%global ao
cursor = get(0,'PointerLocation');
cursor(1) = cursor(1)/100-5.12;
cursor(2) = cursor(2)/100-3.84;
%display(cursor)
putsample(ao,cursor);