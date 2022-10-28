%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'
addpath cli/;

seed = 1;
rng(seed);


clear = Prompt("Clear the plot before computing a new movement?", {"Do not clear plot.", "Clear plot before computing a new movement."}, 2).getUserInput() - 1;
explorerType = Prompt("Select exploration method:", {"Triangulation", "Trilateration", "Hybrid", "DistAngle", "DistAngleAvg", "LoGlo"}, 1).getUserInput();
confidenceType = 'distNormalizedGTL';
weightType = 'distNormalizedGTL';
distType = Prompt("Select distance model:", {"Linear", "Squre root"}, 1).getUserInput();

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
flss = main(explorerType, confidenceType, weightType, distType, p, clear);
