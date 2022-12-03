function compareResults()
    load('result1.mat', 'result1');
    load('result2.mat', 'result2');
    load('result3.mat', 'result3');

    result1=result1(:,1:200);
    result2=result2(:,1:200);
    result3=result3(:,1:200);



%     plotResults('Number of localizing FLSs', 14, result1(8,:), '\epsilon=5^{\circ}');
    subplot(3,1,1)    
plotResults('Number of swarms', 17, result1(14,:), '\epsilon=1^{\circ}', result2(14,:), '\epsilon=3^{\circ}', result3(14,:), '\epsilon=5^{\circ}');
       subplot(3,1,2)
 plotResults('Average error of ptcld ', 19, result1(25,:), '\epsilon=1^{\circ}', result2(25,:), '\epsilon=3^{\circ}', result3(25,:), '\epsilon=5^{\circ}');
       subplot(3,1,3)
plotResults('Hd ', 19, result1(5,:), '\epsilon=1^{\circ}', result2(5,:), '\epsilon=3^{\circ}', result3(5,:), '\epsilon=5^{\circ}');

%  plotResults('Average confidence of FLSs ', 20, result1(26,:), '\epsilon=5^{\circ}');











    
%     plotResults('Number of moving FLSs', 10, result1(2,:), '\epsilon=1^{\circ}', result2(2,:), '\epsilon=3^{\circ}', result3(2,:), '\epsilon=5^{\circ}');
%     plotResults('Minimum confidence of FLSs', 11, result1(13,:), '\epsilon=1^{\circ}', result2(13,:), '\epsilon=3^{\circ}', result3(13,:), '\epsilon=5^{\circ}');
%     axis([1 33 0 1])
%     plotResults('Average distance moved by Localizing FLSs', 12, result1(23,:), '\epsilon=1^{\circ}', result2(23,:), '\epsilon=3^{\circ}', result3(23,:), '\epsilon=5^{\circ}');
%     plotResults('Average distance moved by swarm FLSs', 13, result1(24,:), '\epsilon=1^{\circ}', result2(24,:), '\epsilon=3^{\circ}', result3(24,:), '\epsilon=5^{\circ}');
%     axis([1 33 0 4])
    plotResults('Number of localizing FLSs', 14, result1(8,:), '\epsilon=1^{\circ}', result2(8,:), '\epsilon=3^{\circ}', result3(8,:), '\epsilon=5^{\circ}');
%     plotResults('Number of shared anchored FLSs', 15, result1(22,:), '\epsilon=1^{\circ}', result2(22,:), '\epsilon=3^{\circ}', result3(22,:), '\epsilon=5^{\circ}');
%     plotResults('Number of stationary FLSs', 16, 997-result1(8,:), '\epsilon=1^{\circ}', 997-result2(8,:), '\epsilon=3^{\circ}', 977-result3(8,:), '\epsilon=5^{\circ}');
%     plotResults('Number of swarms', 17, result1(14,:), '\epsilon=1^{\circ}', result2(14,:), '\epsilon=3^{\circ}', result3(14,:), '\epsilon=5^{\circ}');
%     plotResults('Average population of swarms ', 18, result1(16,:), '\epsilon=1^{\circ}', result2(16,:), '\epsilon=3^{\circ}', result3(16,:), '\epsilon=5^{\circ}');
%     plotResults('Average error of ptcld ', 19, result1(25,:), '\epsilon=1^{\circ}', result2(25,:), '\epsilon=3^{\circ}', result3(25,:), '\epsilon=5^{\circ}');
%     plotResults('Average confidence of FLSs ', 20, result1(26,:), '\epsilon=1^{\circ}', result2(26,:), '\epsilon=3^{\circ}', result3(26,:), '\epsilon=5^{\circ}');

%     plotResults('Number of moving FLSs', 10, result3(2,:), '\epsilon=5^{\circ}');
%     plotResults('Minimum confidence of FLSs', 11, result3(13,:), '\epsilon=5^{\circ}');
%     axis([1 100 0 1])
%     plotResults('Average distance moved by Localizing FLSs', 12, result3(23,:), '\epsilon=5^{\circ}');
%     plotResults('Average distance moved by swarm FLSs', 13, result3(24,:), '\epsilon=5^{\circ}');
%     plotResults('Number of localizing FLSs', 14, result3(8,:), '\epsilon=5^{\circ}');
%     plotResults('Number of shared anchored FLSs', 15, result3(22,:), '\epsilon=5^{\circ}');
%     plotResults('Number of stationary FLSs', 16, 100-result3(8,:), '\epsilon=5^{\circ}');
%     plotResults('Number of swarms', 17, result3(14,:), '\epsilon=5^{\circ}');
%     plotResults('Average population of swarms ', 18, result3(16,:), '\epsilon=5^{\circ}');
%     plotResults('Average error of ptcld ', 19, result3(25,:), '\epsilon=5^{\circ}');
%     plotResults('Average confidence of FLSs ', 20, result3(26,:), '\epsilon=5^{\circ}');

    %     nexttile
%     plotResults(result1(5,:), result2(5,:), 'Hausdorff');
%     nexttile
%     plotResults(result1(5,:), result2(3,:), 'avg d');
%     nexttile
%     plotResults(result1(5,:), result2(4,:), 'max d');
end

