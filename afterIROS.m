
sizeOfLocationMatrix = 5;
location = zeros(sizeOfLocationMatrix, sizeOfLocationMatrix, sizeOfLocationMatrix);
costMatrix = zeros(sizeOfLocationMatrix, sizeOfLocationMatrix);
costMatrix(:, 1) = [1; 2; 3; 4; 5];