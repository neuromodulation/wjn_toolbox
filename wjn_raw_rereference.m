function [reref,refchannels,reflocation,montage]=wjn_raw_rereference(signal,f,channels,location)

if size(location,1)>size(location,2)
    warning('LOCATION VECTOR WILL BE TRANSPOSED, WRONG DIMENSIONS')
    location = location';
end

switch f
    case 'bipolar'
        for a =1:size(signal,1)-1
            reref(a,:) = signal(a,:)-signal(a+1,:);
            montage(a,a:a+1)=1;
            if exist('channels','var')
                refchannels{a} = [channels{a} '-' channels{a+1}(end)];
            else
                refchannels{a} = [];
            end
            if exist('location','var')
                reflocation(:,a) = nanmean(location(:,a:a+1),2);
            else
                reflocation(:,a) =nan(3,1);
            end
        end     
    case 'common_average'
        reref = signal-nanmean(signal);
        if exist('channels','var')
            for a =1:length(channels)
                refchannels{a}=[channels{a} '-average'];
                montage(a,a)=1;
            end
        else
            refchannels =[];
        end
        if exist('location','var')
            reflocation = location;
        else
            reflocation =[];
        end
end