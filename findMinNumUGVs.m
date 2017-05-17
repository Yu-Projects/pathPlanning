% findMinNumUGVs
% this will find the minimum number of UGVs needed
% INPUTS

% OUTPUTS


function [minUGVs] = findMinNumUGVs(numPaths, usedSites, numSitesTotal)

numOfUsedSites = numel(usedSites);
sitesLeft = numSitesTotal - numOfUsedSites - 1;
minUGVs = numPaths + sitesLeft;



end

