%#ok<*SAGROW>

% numOfSites = 11;
% numOfChargingSites = 6;
% uavSpeed = 1;
% area = 100;
% numPoints = 11;
% uavSites = [1, 2, 3, 4, 5 ,6 ,7 ,8 ,9 ,10, 11]; % vector of site id's
% ugvSites = [2, 4, 5, 8, 9, 11]; % vector of site id's for UGV charging sites
% x = randperm(area, numPoints);
% y = randperm(area, numPoints);
% corrdinatesOfSites = [x;y]; % 2xn matrix that corresponds with "uavSites"
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


locationOfRobots = [0];
for j = 1:numOfChargingSites
    numOfActiveRobots = numel(locationOfRobots);
    ugvToCurrent = [];
    uavToCurrent = [];
    possible = zeros(1,numOfChargingSites);
    % calculate uavToCurrent position (j)
    for i = 1:numOfActiveRobots
        uavToCurrent(end+1) = sum(uavOnUgvSiteTimes(locationOfRobots(i)+1:j));
    end
    
    
    for i = 1:numOfActiveRobots
        if locationOfRobots(i) ==0
            ugvToCurrent(end+1) = 0;
        else
            ugvToCurrent(end+1) = ugvSitesDistances(locationOfRobots(i), j);% time it takes for ugv to get to current location
        end
        if ugvToCurrent(i) < uavToCurrent(i)
            possible(i) = 1;
        else
            possible(i) = 0;
        end
    end
    
    if max(possible) == 1
        tempAnswer = Inf;
        for i = 1:numOfActiveRobots
            if possible(i) == 1
                tempAnswer = min(ugvToCurrent(i), tempAnswer);
            else
                ;
            end
        end
        [~,robotToMove] = find(ugvToCurrent == tempAnswer);
        locationOfRobots(robotToMove) = j;
    else
        locationOfRobots(end+1) = j;
    end
    
end
