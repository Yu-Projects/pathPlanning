% createTugv.m
% gives distances for all ugv times from one point to another
% INPUTS
% numOfChargingSites:
% corrdinatesOfSites: 
% ugvSites: 
% ugvSpeed: ugv speed in relation to uav speed
% OUTPUTS
% ugvSiteTimes: matrix that contains all the times it takes for the ugv to go from one site to another

function [ugvSiteTimes] = createTugv(numOfChargingSites, corrdinatesOfSites, ugvSites, ugvSpeed)

ugvSitesDistances = zeros(numOfChargingSites);
for i = 1:numOfChargingSites
    for j = 1:numOfChargingSites
        tempPoint = [corrdinatesOfSites(:,ugvSites(i))'; corrdinatesOfSites(:,ugvSites(j))'];
        ugvSitesDistances(i, j) = pdist(tempPoint, 'euclidean');
    end
end

ugvSiteTimes = ugvSitesDistances ./ ugvSpeed;

end