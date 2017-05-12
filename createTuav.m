% createTuav.m
% this is supposed to create the time matrix for uav on the ugv graph
% INPUTS
% uavSites:
% ugvSites:
% corrdinatesOfSites:
% OUTPUTS
% uavOnUgvSiteTimes:

function [uavOnUgvSiteTimes] = createTuav(uavSites, ugvSites, corrdinatesOfSites, numOfUavSites)

uavOnUgvSiteTimes = [];
numOfUgvSites = numel(ugvSites);
for i = 2:numOfUgvSites
    k = i;
    tempAnswer = 0;
    for j = ugvSites(i-1):numOfUavSites-1
        tempPoint = [corrdinatesOfSites(:,uavSites(j))'; corrdinatesOfSites(:,uavSites(j+1))'];
        tempDistance = pdist(tempPoint, 'euclidean');
        tempAnswer = tempDistance + tempAnswer;
        if j+1 == ugvSites(k)
            uavOnUgvSiteTimes(i-1,k) = tempAnswer;
            k = k+1;
        end
    end
end

end

