function compareResults()
    load('result1.mat', 'result1');
    load('result2.mat', 'result2');

    plotResults(result1(1,:), result2(1,:), 'Number of Frozen FLS', 4);
    plotResults(result1(2,:), result2(2,:), 'Number of Moved FLS', 5);
%     nexttile
%     plotResults(result1(5,:), result2(5,:), 'Hausdorff');
%     nexttile
%     plotResults(result1(5,:), result2(3,:), 'avg d');
%     nexttile
%     plotResults(result1(5,:), result2(4,:), 'max d');
end

