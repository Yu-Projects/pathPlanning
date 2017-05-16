% calculateWaitUAV.m
% this function calculates the amount of wait time the UAV would have to
% go through if the it had to wait on a slower UGV
% INPUTS

% OUTPUTS



function [waitTime] = calculateWaitUAV(tUAV, tUGV, numOfUGVSites)

waitTime = 0;
for i = 1:numOfUGVSites-1
    temp =  tUGV(i, i+1) - tUAV(i, i+1);
    if temp >= 0
        waitTime = waitTime + temp;
    end
end




end

