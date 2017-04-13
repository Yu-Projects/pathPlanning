
%% Subtour Constraints
% Because you can't add all of the subtour constraints, take an iterative
% approach. Detect the subtours in the current solution, then add
% inequality constraints to prevent those particular subtours from
% happening. By doing this, you find a suitable tour in a few iterations.
%
% Eliminate subtours with inequality constraints. An example of how this
% works is if you have five points in a subtour, then you have five lines
% connecting those points to create the subtour. Eliminate this subtour by
% implementing an inequality constraint to say there must be less than or
% equal to four lines between these five points.
%
% Even more, find all lines between these five points, and constrain the
% solution not to have more than four of these lines present. This is a
% correct constraint because if five or more of the lines existed in a
% solution, then the solution would have a subtour (a graph with $n$ nodes
% and $n$ edges always contains a cycle).
%
% The |detectSubtours| function analyzes the solution and returns a cell
% array of vectors.  Each vector in the cell array contains the stops
% involved in that particular subtour.

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);

%%
% Include the linear inequality constraints to eliminate subtours, and
% repeatedly call the solver, until just one subtour remains.

A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)]; % a guess at how many nonzeros to allocate
    for ii = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{ii}; % Extract the current subtour
%         The next lines find all of the variables associated with the
%         particular subtour, then add an inequality constraint to prohibit
%         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end

    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    
    % Visualize result
    lh = updateSalesmanPlot(lh,x_tsp,idxs,stopsLon,stopsLat);
    
    % How many subtours this time?
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
end

title('Solution with Subtours Eliminated');
hold off

%% Solution Quality
% The solution represents a feasible tour, because it is a single closed
% loop. But is it a minimal-cost tour? One way to find out is to examine
% the output structure.

disp(output.absolutegap)

%%
% The smallness of the absolute gap implies that the solution is either
% optimal or has a total length that is close to optimal.
