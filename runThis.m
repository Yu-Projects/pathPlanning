clear all;
close all;
figure(1);

% constants
uavSpeed = 1;
ugvSpeed = uavSpeed * 0.5;

numOfPoints = 100; % you can use any number, but the problem size scales as N^2
xPoints = zeros(numOfPoints,1); % allocate x-coordinates of nStops
yPoints = xPoints; % allocate y-coordinates
for i = 1:numOfPoints
    xP = rand*1.5;
    yP = rand;
    xPoints(i) = xP;
    yPoints(i) = yP;
end
xPoints(end+1) = 0;
yPoints(end+1) = 0;
numOfPoints = numel(xPoints); 
plot(xPoints,yPoints,'*b')
hold off

idxs = nchoosek(1:numOfPoints,2);

dist = hypot(yPoints(idxs(:,1)) - yPoints(idxs(:,2)), ...
             xPoints(idxs(:,1)) - xPoints(idxs(:,2)));
lendist = numel(dist);
edgeCostMatrix = [idxs, dist];

Aeq = spones(1:length(idxs)); % Adds up the number of trips
beq = numOfPoints;

Aeq = [Aeq;spalloc(numOfPoints,length(idxs),numOfPoints*(numOfPoints-1))]; % allocate a sparse matrix
for i = 1:numOfPoints
    whichIdxs = (idxs == i); % find the trips that include stop i
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where i is at either end
    Aeq(i+1,:) = whichIdxs'; % include in the constraint matrix
end
beq = [beq; 2*ones(numOfPoints,1)];

intcon = 1:lendist;
lb = zeros(lendist,1);  % lower bound for intlinprog (based off of the lower bound for xPoints/yPoints)
ub = ones(lendist,1);   % upper bound for intlinprog (based off of the upper bound for xPoints/yPoints)

opts = optimoptions('intlinprog','Display','off');  % implements the constraints
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);

hold on
segments = find(x_tsp); % Get indices of lines on optimal path
lh = zeros(numOfPoints,1); % Use to store handles to lines on plot
lh = updateSalesmanPlot(lh,x_tsp,idxs,xPoints,yPoints);
title('Solution with Subtours');

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);

A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,numOfPoints)]; % a guess at how many nonzeros to allocate
    for i = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{i}; % Extract the current subtour
%         The next lines find all of the variables associated with the
%         particular subtour, then add an inequality constraint to prohibit
%         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for j = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(j,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(j,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end

    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    
    % Visualize result
    lh = updateSalesmanPlot(lh,x_tsp,idxs,xPoints,yPoints);
    
    % How many subtours this time?
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
end

title('Solution with Subtours Eliminated');
hold off

disp(output.absolutegap)
