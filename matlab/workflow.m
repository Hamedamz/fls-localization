%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'
addpath cli/;

seed = 1;
rng(seed);


clear = Prompt("Clear the plot before computing a new movement?", {"Do not clear plot.", "Clear plot before computing a new movement."}, 2).getUserInput() - 1;
explorerType = Prompt("Select exploration method:", {"Triangulation", "Trilateration"}, 1).getUserInput();
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

clf
flss = main(explorerType, confidenceType, weightType, distType, square3, clear);
