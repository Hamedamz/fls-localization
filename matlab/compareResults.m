function compareResults()
    load('result1.mat', 'result1');
    load('result2.mat', 'result2');
    load('result3.mat', 'result3');
    load('result4.mat', 'result4');

    plotResults('Minimum Distance Traveled', 4, result1(18,:), 'Signal Strength', result2(18,:), 'Max Radius', result3(18,:), 'Avg Radius', result4(18,:), 'Random');
    plotResults('Average Distance Traveled', 5, result1(3,:), 'Signal Strength', result2(3,:), 'Max Radius', result3(3,:), 'Avg Radius', result4(3,:), 'Random');
    plotResults('Maximum Distance Traveled', 6, result1(4,:), 'Signal Strength', result2(4,:), 'Max Radius', result3(4,:), 'Avg Radius', result4(4,:), 'Random');
    plotResults('Number of Moving FLSs', 7, result1(2,:), 'Signal Strength', result2(2,:), 'Max Radius', result3(2,:), 'Avg Radius', result4(2,:), 'Random');
%     nexttile
%     plotResults(result1(5,:), result2(5,:), 'Hausdorff');
%     nexttile
%     plotResults(result1(5,:), result2(3,:), 'avg d');
%     nexttile
%     plotResults(result1(5,:), result2(4,:), 'max d');
end

