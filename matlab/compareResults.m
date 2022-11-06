function compareResults()
    load('result1.mat', 'result1');
    load('result2.mat', 'result2');

    plotResults(result1(1,:), result2(1,:), 4, 'Number of Frozen FLS');
    plotResults(result1(2,:), result2(2,:), 5, 'Number of Moved FLS');
    plotResults(result1(5,:), result2(5,:), 6, 'Hausdorff');
    plotResults(result1(5,:), result2(3,:), 7, 'avg d');
    plotResults(result1(5,:), result2(4,:), 8, 'max d');
end

