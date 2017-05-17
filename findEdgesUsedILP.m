% findEdgesUsedTSP
% finds the number of edges that are created by the ILP solver
% INPUTS
% x = x_tsp given from intlinprog
% idxs = id's of the edges used for ILP
% OUTPUTS


function [edges] = findEdgesUsedILP(x, idxs)

locationOfOnes = find(x==1);

edges = [];
numOfLocationOfOnes = numel(locationOfOnes);
for i = 1:numOfLocationOfOnes
    edges(end+1,:) = idxs(locationOfOnes(i),:);
end


end

