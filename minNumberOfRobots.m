 %#ok<*SAGROW>

numOfSites = 11;
numOfChargingSites = 6;
uavSpeed = 1;
area = 100;
numPoints = 11;
uavSites = [1, 2, 3, 4, 5 ,6 ,7 ,8 ,9 ,10, 11]; % vector of site id's
ugvSites = [2, 4, 5, 8, 9, 11]; % vector of site id's for UGV charging sites
% x = randperm(area, numPoints);
% y = randperm(area, numPoints);
% corrdinatesOfSites = [x;y]; % nx2 matrix that corresponds with "uavSites"
% ugvSpeed = uavSpeed * 0.5;

ugvSitesDistances = zeros(numOfChargingSites);
for i = 1:numOfChargingSites
    for j = 1:numOfChargingSites
        tempPoint = [corrdinatesOfSites(:,ugvSites(i))'; corrdinatesOfSites(:,ugvSites(j))'];
        ugvSitesDistances(i, j) = pdist(tempPoint, 'euclidean');
    end
end

ugvSiteTimes = ugvSitesDistances ./ ugvSpeed;
numOfUavSites = numel(uavSites);
numOfUgvSites = numel(ugvSites);
uavOnUgvSiteTimes = [];
j = 1;
tempAnswer = 0;
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

tempUgvTimes = [];
locationOfRobots = [1]; % this is the index of the vector ugvSites
for i = 2:numOfChargingSites
    numOfRobotsActive = numel(locationOfRobots);
    for j = 1:numOfRobotsActive
        tempUgvTimes(end+1) = ugvSiteTimes(locationOfRobots(j), i);
        %         if ugvSiteTimes(locationOfRobots(j), i) < uavOnUgvSiteTimes(i)
        %
        %         else
        %            locationOfRobots(end+1) =  i;
        %         end
    end
    numOfTempUgvTimes = numel(tempUgvTimes);
    for j = 1:numOfTempUgvTimes
        if tempUgvTimes < uavOnUgvSiteTimes(i)
            
        else
            
        end
    end
    
    
    
    
    tempUgvTimes = [];
end
locationOfRobots
