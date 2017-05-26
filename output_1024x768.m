function output_1024x768(tim,event,ao)
%global ao
cursor = get(0,'PointerLocation');
cursor(1) = (cursor(1)-512)/512*5;
cursor(2) = (cursor(2)-384)/384*5;
%display(cursor)
putsample(ao,cursor);
end