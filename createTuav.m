% createTuav.m
% this is supposed to create the time matrix for uav on the ugv graph
% INPUTS
% uavSites:
% ugvSites:
% corrdinatesOfSites:
% OUTPUTS
% uavOnUgvSiteTimes:

function [uavOnUgvSiteTimes, uavTimes] = createTuav(uavSites, ugvSites, corrdinatesOfSites)

numOfUavSites = numel(uavSites);
numOfUgvSites = numel(ugvSites);
uavOnUgvSiteTimes = [];
tempAnswer = 0;
j = 1;
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

uavTimes = [];
for i = 1:numOfUgvSites+1
    for j = 2:numOfUgvSites+1
        if i == j
            uavTimes(i,j) = 0;
        else
            uavTimes(i,j) = sum(uavOnUgvSiteTimes(i:j-1));
        end
    end
end



% ugvSitesDistances = zeros(numOfChargingSites);
% for i = 1:numOfChargingSites
%     for j = 1:numOfChargingSites
%         tempPoint = [corrdinatesOfSites(:,ugvSites(i))'; corrdinatesOfSites(:,ugvSites(j))'];
%         ugvSitesDistances(i, j) = pdist(tempPoint, 'euclidean');
%     end
% end
%
% ugvSiteTimes = ugvSitesDistances ./ ugvSpeed;


end

