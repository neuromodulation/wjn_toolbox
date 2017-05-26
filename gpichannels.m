function [channels,hemisphere] = gpichannels(type)

if ~exist('type','var')
    type = 'medtronic';
end

switch type
    case 'medtronic'
        channels = {'GPiR01','GPiR12','GPiR23','GPiL01','GPiL12','GPiL23'};
        hemisphere = [ones(1,3) ones(1,3)*2];
end