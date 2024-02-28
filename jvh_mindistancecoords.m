function [coord_closest, index, distance] = jvh_mindistancecoords(coord_interest,coord_targets, tolerance)
% this function computes the closest MNI coordinate
% output is for each MNI coordinate of interest: the MNI coordinate from target that is closest to the interest
% input 1 are 1 set MNI coordinates e.g. [-2 -10 59] or a list of coordinates in format n x 3, with n the number of coordinates of interest
% input 2 are list of MNI coordinates target, in format m x 3, with m the number of coordinates of all targets
% in other words: which from input 2 is closest to the input 1? Repeat for all inputs in 1.

% Jonathan Vanhoecke 2024
arguments (Input)
    coord_interest  (:,3) double % coord_interest= [-2 -10 59] or multiple rows of interests
    coord_targets   (:,3) double % coord_targets = coorddouble =  jvh_coordcell2double(cellofchannels) = an atlas or collection of MNI coordinates;
    tolerance       (1,1) {mustBeNumeric} = 5 % tolerance(optional), search faster for nodes that have an expected distance below tolerance
end
arguments (Output)
    coord_closest   (:,3) double %closest coordinate, listing 1 per coord_interest
    index           (:,1) double %corresponding target index of the closest coordinate
    distance        (:,1) double %distance between closest_coord and coord_interest
end

amount_of_interests = size(coord_interest,1);
amount_of_targets   = size(coord_targets, 1);
%%% see also wjn_distance()
coord_closest =zeros(amount_of_interests,3);
index         =zeros(amount_of_interests,1);
distance      =zeros(amount_of_interests,1);

for ii=1:amount_of_interests
    distances = zeros(amount_of_targets,1);
    distances(abs(coord_interest(ii,1)-coord_targets(:,1))>=tolerance)=tolerance/2;
    distances(abs(coord_interest(ii,2)-coord_targets(:,2))>=tolerance)=tolerance/2;
    distances(abs(coord_interest(ii,3)-coord_targets(:,3))>=tolerance)=tolerance/2;
    for i = 1:amount_of_targets
        if distances(i)<tolerance/2
            distances(i)=pdist([coord_targets(i,:);coord_interest(ii,:)],'euclidean');
        end
    end
    
    if min(distances)==tolerance/2
        [coord_closest(ii,:),index(ii,:), distance(ii,:)] = jvh_mindistancecoords(coord_interest(ii,:),coord_targets, tolerance*2);
    else
        [distance(ii,:),index(ii,:)] = min(distances);
        coord_closest(ii,:) = coord_targets(index(ii,:),:);
    end
end
end


