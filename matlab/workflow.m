%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'
addpath cli/;



confidenceType = Prompt("Select confidence method:", {"Signal Strength", "Confidence M", "Confidence X", "Random"}, 2).getUserInput();
weightType = confidenceType;
explorerType = Prompt("Select exploration method:", {"Triangulation", "Trilateration", "Hybrid", "DistAngle", "DistAngleAvg", "LoGlo"}, 4).getUserInput();
% distType = Prompt("Select distance model:", {"Linear", "Squre root"}, 1).getUserInput();
physical = -Prompt("Enable physical movement?", {"Yes", "No"}, 2).getUserInput() + 2;

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


fixN = Prompt("Assign closest neighbors in each round?", {"Yes", "No"}, 1).getUserInput();

if fixN == 1
    fixN = Prompt("Input the minimum number of neighbors?", {}, 1).getDirectInput();
    fixN = str2double(fixN);
else
    fixN = 0;
end


% rounds = Prompt("How many rounds?", {"10", "25", "50", "100", "200"}, 4).getUserInput();
rounds = 200;

save('config.mat','addAngleError', 'swarmPolicy', 'angleError');

square = [
    0 0 1 1;
    0 1 1 0
    ] + 5;

square3 = [
    0 0 0 1 2 2 2 1;
    0 1 2 2 2 1 0 0
    ] + 5;

polygon = [
    0 1 1 0 0;
    0 0 1 1 2
    ] + 6;

circle = [
    0 1 2 3 3 2 1;
    1 0 0 1 2 2 2
    ] + 6;

cube = [
    0 0 1 1 0 0 1 1;
    0 1 1 0 0 1 1 0;
    0 0 0 0 1 1 1 1
    ] + 10;

cube3 = [
    0 0 0 1 1 2 2 2 1 0 0 0 1 2 2 2 1 0 0 0 1 2 2 2 1 1;
    0 1 2 1 2 2 1 0 0 0 1 2 2 2 1 0 0 0 1 2 2 2 1 0 0 1;
    0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2
    ] + 10;

shape = Prompt("Select the shape:", {"butterfly", "cat", "teapot", "square3x3", "square2x2", "cube", "cube3", "race car", "butterfly 150", "454 points 3d" ...
    , "758 points 3d","760 points 3d","997 points 3d","1197 points 3d","1562 points 3d", "1727 points 3d"}, 1).getUserInput();




for i=2:2
%     shape = mod(ceil(i/3-1),2)+2;
%     explorerType = 2^(mod(ceil(i/6)+1,3));
%     alpha = 2*mod(i-1,3)+1;
%     shape = 2;
    shape = i;
    alpha = 5;
    fixN = 7;

    switch shape
    case 1
        p = getPointCloudFromPNG("./assets/butterfly2.png");
    case 2
        p = getPointCloudFromPNG("./assets/cat.png");
    case 3
        p = getPointCloudFromPNG("./assets/teapot.png");
    case 4
        p = square3;
    case 5
        p = square;
    case 6
        p = cube;
    case 7
        p = cube3;
    case 8
        p = readPtcld("./assets/pt1510.ptcld", -1);
    case 9
        p = getPointCloudFromPNG("./assets/butterfly64.png");
    case 10
        p = readPtcld("./assets/PointClouds/pt1609.454.ptcld", -1);
    case 11
        p = readPtcld("./assets/PointClouds/pt1608.758.ptcld", -1);
    case 12
        p = readPtcld("./assets/PointClouds/pt1625.760.ptcld", -1);
    case 13
        p = readPtcld("./assets/PointClouds/pt1620.997.ptcld", -1);
    case 14
        p = readPtcld("./assets/PointClouds/pt1617.1197.ptcld", -1);
    case 15
        p = readPtcld("./assets/PointClouds/pt1630.1562.ptcld", -1);
    case 16
        p = readPtcld("./assets/PointClouds/pt1619.1727.ptcld", -1);
    end

    flss = main(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, p, physical, rounds, removeAlpha, concurrentPolicy, crm, fixN, i-1);
end