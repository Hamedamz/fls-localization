%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'
addpath cli/;



confidenceType = Prompt("Select confidence method:", {"Signal Strength", "Max Radius", "Avg Radius", "Random"}, 2).getUserInput();
weightType = confidenceType;
clear = 1;
% clear = Prompt("Clear the plot before computing a new movement?", {"Do not clear plot.", "Clear plot before computing a new movement."}, 2).getUserInput() - 1;
explorerType = Prompt("Select exploration method:", {"Triangulation", "Trilateration", "Hybrid", "DistAngle", "DistAngleAvg", "LoGlo"}, 4).getUserInput();
% distType = Prompt("Select distance model:", {"Linear", "Squre root"}, 1).getUserInput();
distType = 1;
addAngleError = -Prompt("Add error to angle estimation?", {"Yes", "No"}, 2).getUserInput() + 2;
freezePolicy = Prompt("When to freeze an FLS?", {"Don't freeze", "After each movement", "When it wants to move with a zero vector"}, 2).getUserInput();
swarmEnabled = -Prompt("Enable swarm?", {"Yes", "No"}, 1).getUserInput() + 2;
if swarmEnabled
    swarmPolicy = Prompt("How should a swarm move?", {"Only one FLS in a swarm may move in a round", "Each swarm member moves using the first recieved vector"}, 1).getUserInput();
else
    swarmPolicy = 0;
end
concurrentPolicy = Prompt("Which neighbors should remain stationay when an FLS is localizing?", {"All el neighbors", "Only the most confident neighbor"}, 1).getUserInput();

removeAlpha = 0;
alpha = 5;
angleError = 0;

crm = Prompt("Adjust communication range?", {"Yes", "No"}, 2).getUserInput();

if crm == 1
    crm = Prompt("Input the multiplier for communication range?", {}, 1).getDirectInput();
    crm = str2double(crm);
else
    crm = 0;
end


fixN = Prompt("Assign random neighbors?", {"Yes", "No"}, 1).getUserInput();

if fixN == 1
    fixN = Prompt("Input the minimum number of neighbors?", {}, 1).getDirectInput();
    fixN = str2double(fixN);
else
    fixN = 0;
end


% rounds = Prompt("How many rounds?", {"10", "25", "50", "100", "200"}, 4).getUserInput();
rounds = 100;

flssCube = {};
plt = zeros(27, rounds);
maxR = 0;

CF = cpa2;

numCubes = 0;
for i=1:size(CF{1}.cubes,2)
    points = [CF{1}.vertexList{CF{1}.cubes(i).assignedVertices}];
    if size(points,2) == 0
        continue;
    end
%     numCubes = numCubes + 1;
%     continue;
    n = CF{1}.cubes(i).numVertices;
    p = zeros(3,n);
    for j=1:n
        p(1,j) = points(j*7-6);
        p(2,j) = points(j*7-5);
        p(3,j) = points(j*7-4);
    end
    [cube, pltCube, j] = main(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, p, clear, rounds, removeAlpha, concurrentPolicy, crm, fixN, i-1);
    flssCube{i} = cube;
    maxR = max(maxR, j); 
    plt = plt + pltCube;
end

% return;

main3([flssCube{:}], clear, rounds, i+1);
figure(1);
compareResults(plt, maxR);