%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'
addpath cli/;

seed = 1;
rng(seed);


confidenceType = 'distNormalizedGTL';
weightType = 'distNormalizedGTL';
clear = Prompt("Clear the plot before computing a new movement?", {"Do not clear plot.", "Clear plot before computing a new movement."}, 2).getUserInput() - 1;
explorerType = Prompt("Select exploration method:", {"Triangulation", "Trilateration", "Hybrid", "DistAngle", "DistAngleAvg", "LoGlo"}, 4).getUserInput();
% distType = Prompt("Select distance model:", {"Linear", "Squre root"}, 1).getUserInput();
distType = 1;
addAngleError = -Prompt("Add error to angle estimation?", {"Yes", "No"}, 1).getUserInput() + 2;
freezePolicy = Prompt("When to freeze an FLS?", {"Don't freeze", "After each movement", "When it wants to move with a zero vector"}, 1).getUserInput();
swarmEnabled = -Prompt("Enable swarm?", {"Yes", "No"}, 1).getUserInput() + 2;
if swarmEnabled
    swarmPolicy = Prompt("How should a swarm move?", {"Only one FLS in a swarm may move in a round", "Each swarm member moves using the first recieved vector"}, 1).getUserInput();
else
    swarmPolicy = 0;
end

alpha = 2;

% rounds = Prompt("How many rounds?", {"10", "25", "50", "100", "200"}, 4).getUserInput();
rounds = 10;

save('config.mat','addAngleError', 'swarmPolicy');

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

shape = Prompt("Select the shape:", {"butterfly", "cat", "teapot", "square3x3", "square2x2", "cube", "cube3", "race car"}, 1).getUserInput();

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
        p = readPtcld("./assets/pt1510.ptcld", -1000);
end

clf
flss = main(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, p, clear, rounds);
