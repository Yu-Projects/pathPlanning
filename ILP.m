%clear all;
%close all;
figure(1);

% constants
uavSpeed = 1;
ugvSpeed = uavSpeed * 0.5;

% creating the points for the problem
numOfPoints = 4; % you can use any number, but the problem size scales as N^2
xPoints = zeros(numOfPoints,1); % allocate x-coordinates of nStops
yPoints = xPoints; % allocate y-coordinates
for i = 1:numOfPoints
    xP = rand*1.5;
    yP = rand;
    xPoints(i) = xP;
    yPoints(i) = yP;
end
xPoints(end+1) = 0; % adding depot node
yPoints(end+1) = 0; % adding depot node
numOfPoints = numel(xPoints);
plot(xPoints,yPoints,'*b')
hold off

% creating the initial constraints of the problem intlinprog
idxs = nchoosek(1:numOfPoints,2); % all possible paths
dist = hypot(yPoints(idxs(:,1)) - yPoints(idxs(:,2)), xPoints(idxs(:,1)) - xPoints(idxs(:,2))); % gets distances for all combinations in idxs
lendist = numel(dist);
edgeCostMatrix = [idxs, dist];

% optimization function min(-yij)
f = ones(lendist,1)*-1;
intcon = 1:lendist; % which values are integers(all values left out are not specifically integers)

% creating upper and lower bound for problem (based on environment size)
lb = zeros(lendist,1);  % lower bound for intlinprog (based off of the lower bound for xPoints & yPoints)
ub = ones(lendist,1);   % upper bound for intlinprog (based off of the upper bound for xPoints & yPoints)

A1 = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b1 = ones(numOfPoints-1,1);
% all outgoing edges have to add up to <=1
for j = 1:numOfPoints
    for i = 1:lendist
        yi = idxs(i,1);
        if yi == j
            A1(j, i) = 1;
        end
    end
end
A1 = full(A1);
[A1, b1, ~, ~] = removeRowCol(A1, b1);

A2 = spalloc(0,lendist,0);
b2 = ones(numOfPoints,1);
% all incoming edges have to add up to <=1
for j = 2:numOfPoints
    for i = 1:lendist
        yj = idxs(i,2);
        if yj == j
            A2(j, i) = 1;
        end
    end
end
A2 = full(A2);
[A2, b2, ~, ~] = removeRowCol(A2, b2);

A = [A1;A2]; % combining A & B
b = [b1;b2];
for i = 1:lendist
    if idxs(i,2) == numOfPoints
        dist(i) = 0;
    end
end

%---------------------------------------------%
for i = 1:lendist
    fromNode = idxs(i,1);
    toNode = idxs(i, 2);
    if tUGV(fromNode, toNode) > tUAV(fromNode, toNode)
        location(i) = 1;
        finalTotal(end+1) = 0;
    end
end
%---------------------------------------------%

opts = optimoptions('intlinprog','Display','off');  % implements the constraints
[x_tsp,costopt,exitflag,output] = intlinprog(f,intcon, A, b',[],[],lb,ub,opts);

hold on
segments = find(x_tsp); % Get indices of lines on optimal path
lh = zeros(numOfPoints,1); % Use to store handles to lines on plot
lh = updateSalesmanPlot(lh,x_tsp,idxs,xPoints,yPoints);
title('Solution with Subtours');

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);

A1 = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b1 = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b1 = [b1;zeros(numtours,1)]; % allocate b
    A1 = [A1;spalloc(numtours,lendist,numOfPoints)]; % a guess at how many nonzeros to allocate
    for i = 1:numtours
        rowIdx = size(A1,1)+1; % Counter for indexing
        subTourIdx = tours{i}; % Extract the current subtour
        %         The next lines find all of the variables associated with the
        %         particular subtour, then add an inequality constraint to prohibit
        %         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for j = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(j,1)),2)) & ...
                (sum(idxs==subTourIdx(variations(j,2)),2));
            A1(rowIdx,whichVar) = 1;
        end
        b1(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end
    
    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A1,b1,Aeq,beq,lb,ub,opts);
    
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
