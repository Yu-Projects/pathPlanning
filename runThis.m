


uavSpeed = 1;
ugvSpeed = uavSpeed / UGVSpeed;
% uavSites = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
% ugvSites = [6,10,15,20];
% numOfSites = 20;
% numOfChargingSites = 4;
numOfSites = numPointsInit;


uavSites = zeros(1,numOfSites);
for i = 1:numOfSites
    uavSites(i) = i;
end
ugvSites = [];
for a = 1:numel(GLNSSolution)-1
    temp = v_Type(GLNSSolution(a), GLNSSolution(a+1));
    if temp == 1
        
    elseif temp == 2
        ugvSites(end+1) = a;
        ugvSites(end+1) = a+1;
    elseif temp == 3
        ugvSites(end+1) = a+1;
    else
        print('error')
    end
end
% ugvSites = [9,10,22,23,38,39,50];
ugvSites(end+1) = numel(uavSites);
numOfChargingSites = numel(ugvSites);
corrdinatesOfSites = [GLNSx(1:end-1); GLNSy(1:end-1)];
[locationOfRobots, ugvSiteTimes, uavOnUgvSiteTimes, pathsForRobots] = minNumberOfRobots(numOfSites, numOfChargingSites, uavSites, ugvSites, corrdinatesOfSites, ugvSpeed)


