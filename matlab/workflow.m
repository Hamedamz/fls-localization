%'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'

explorerMode = 'basic';
confidenceMode = 'distGTL';
weightMode = 'distGTL';

clf
flss = main(explorerMode, confidenceMode, weightMode);
