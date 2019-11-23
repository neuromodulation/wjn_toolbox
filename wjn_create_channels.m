function channels = wjn_create_channels(str,num)

if ischar(str)
    str = {str};
end
channels = [];
for a = 1:length(str)
channels = [channels;strrep(strcat(str(a),num2str(num')),' ','0')];
end

