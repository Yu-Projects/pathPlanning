% createTuav.m
% this is supposed to create the time matrix for uav on the ugv graph
% INPUTS
% uavSites:
% ugvSites: 
% corrdinatesOfSites: 
% OUTPUTS
% uavOnUgvSiteTimes: 

function [uavOnUgvSiteTimes] = createTuav(uavSites, ugvSites, corrdinatesOfSites)


for i = 1:numOfUavSites-1
    tempPoint = [corrdinatesOfSites(:,uavSites(i))'; corrdinatesOfSites(:,uavSites(i+1))'];
    tempDistance = pdist(tempPoint, 'euclidean');
    tempAnswer = tempDistance + tempAnswer;
    if i+1 == ugvSites(j)
        uavOnUgvSiteTimes(end+1) = tempAnswer;
        tempAnswer = 0;
        j = j+1;
    end
end


end

