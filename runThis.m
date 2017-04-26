


uavSpeed = 1;
ugvSpeed = uavSpeed / UGVSpeed;
uavSites = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
ugvSites = [6,10,15,20];
numOfSites = 20;
numOfChargingSites = 4;
[locationOfRobots, ugvSitesDistances, uavOnUgvSiteTimes, pathsForRobots] = minNumberOfRobots(numOfSites, numOfChargingSites, uavSites, ugvSites, corrdinatesOfSites, ugvSpeed)


