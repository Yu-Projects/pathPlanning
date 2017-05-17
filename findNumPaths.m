% findNumPaths
% finds the number of paths given an input edge list and number of points
% used to obtain those paths
% INPUTS
% edges = gives the matrix of edges
% OUTPUTS


function [numPaths, numPoints] = findNumPaths(edges)

tempEdges = edges;
numPoints = union(tempEdges, []);

[numOfEdges, ~] = size(edges);
numPaths = numOfEdges;
for i = 1:numOfEdges
    for j = 1:numOfEdges
        if edges(i,2) == edges(j,1)
            numPaths = numPaths - 1;
        end
    end
end


end