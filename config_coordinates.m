
function [xcos,ysin] = config_coordinates(closedmode)

%% Coordinate combinations of the target circles
if closedmode==1;
    xcos = [ 0 1 0 -1];
    ysin = [1 0 -1 0 ];
else
    xcos = [ 0 1  0 -1 0.707 -0.707 0.707 -0.707];
    ysin = [ 1 0 -1 0 0.707 -0.707 -0.707 0.707]; 
end
end