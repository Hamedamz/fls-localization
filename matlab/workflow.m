%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'
seed = 1;
rng(seed);

explorerMode = 'TriL';
confidenceMode = 'distNormalizedGTL';
weightMode = 'distNormalizedGTL';

square = [
    0 0 1 1;
    0 1 1 0
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
flss = main(explorerMode, confidenceMode, weightMode, circle);
