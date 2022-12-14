function map = compareResults(fig, rounds)
%     
    load(sprintf('resultSwarmer-0-%d.mat',1), 'pltResults');
    result1=pltResults(:,1:10);

    load(sprintf('resultSwarmer-1-%d.mat',3), 'pltResults');
    result2=pltResults(:,1:14);

    load(sprintf('resultSwarmer-2-%d.mat',5), 'pltResults');
    result3=pltResults(:,1:13);

% 
%     for j=1:5
%     for i=1:24
%             if result3(8,i) == 0
%                result3(:,i) = [];
%                break;
%             end
%     end
%     end

%     load(sprintf('resultBin%d.mat',fig+1), 'pltResults');
%     result2=pltResults(:,1:140);

%     load(sprintf('resultBin%d.mat',fig+2), 'pltResults');
%     result3=pltResults(:,1:50);
% 
%     load(sprintf('resultBin%d.mat',fig+3), 'pltResults');
%     result4=pltResults(:,1:50);

%     load('result1.mat', 'pltResults');
%     result2=pltResults(:,1:rounds);
%     
%     load('result2.mat', 'pltResults');
%     result3=pltResults(:,1:rounds);

keySet = {2,4,6,5,14,16,8,18,22,23,27};
valueSet = [
    "1d" "3d" "5d" ...
    "Hd" ...
    "Number of swarms" ...
    "Average Population of Swarms" ...
    "Number of Localizing FLSs" ...
    "Number of Anchors" ...
    "Number of Shared Anchors" ...
    "Average Dead Reckoning Distance Traveled by Localizing FLSs" ...
    "Average Dead Reckoning Distance Traveled by Swarms"];
map = containers.Map(keySet,valueSet);

for i=4:length(keySet)
    key = keySet{i};
    title = map(key);
    plotResults(title, key, result1(key,:), '\epsilon=1^{\circ}', result2(key,:), '\epsilon=3^{\circ}', result3(key,:), '\epsilon=5^{\circ}');
end

% key = 8;
%     plotResults('', key, result1(key,:), 'dragon', result2(key,:), 'hat', result3(key,:), 'skateboard');


% plotResults('Number of swarms', 14, result1(14,:), '\epsilon=1^{\circ}', result2(14,:), '\epsilon=3^{\circ}', result3(14,:), '\epsilon=5^{\circ}');
% plotResults('Average Population of Swarms', 16, result1(16,:), '\epsilon=1^{\circ}', result2(16,:), '\epsilon=3^{\circ}', result3(16,:), '\epsilon=5^{\circ}');
% plotResults('Number of Localizing FLSs', 8, result1(8,:), '\epsilon=1^{\circ}', result2(8,:), '\epsilon=3^{\circ}', result3(8,:), '\epsilon=5^{\circ}');
% plotResults('Number of Anchors', 18, result1(18,:), '\epsilon=1^{\circ}', result2(18,:), '\epsilon=3^{\circ}', result3(18,:), '\epsilon=5^{\circ}');
% % plotResults('Number of Shared Anchors', 22, result1(22,:), '\epsilon=1^{\circ}', result2(22,:), '\epsilon=3^{\circ}', result3(22,:), '\epsilon=5^{\circ}');
% plotResults('Average Dead Reckoning Distance Traveled by Localizing FLSs', 23, result1(23,:), '\epsilon=1^{\circ}', result2(23,:), '\epsilon=3^{\circ}', result3(23,:), '\epsilon=5^{\circ}');
% % plotResults('Average Dead Reckoning Distance Traveled by Swarms', 27, result1(27,:), '\epsilon=1^{\circ}', result2(27,:), '\epsilon=3^{\circ}', result3(27,:), '\epsilon=5^{\circ}');


% figure(fig+1000);
% clf

% subplot(2,1,1)   
% plotResults('Hd ', 3, result1(5,:), '', result2(5,:), '');
% plotResults('average dead reckoning distance by all flss', 5, result1(3,:) ./ result1(2,:) * 94, '', result2(3,:) ./ result2(2,:) * 94, '');

% subplot(2,1,2)   
% plotResults('Hd ', 4, result3(5,:), '', result4(5,:), '');

%     plotResults('Number of localizing FLSs', 14, result1(8,:), '\epsilon=5^{\circ}');
% subplot(3,1,1)    
% subplot(3,1,2)
% plotResults('Average error of ptcld ', 19, result1(25,:), '\epsilon=1^{\circ}', result2(25,:), '\epsilon=3^{\circ}', result3(25,:), '\epsilon=5^{\circ}');
% subplot(3,1,3)
% 
% subplot(3,1,1)    
% plotResults('Number of swarms', 1, result1(14,:), 'butterfly', result2(14,:), 'cat', result3(14,:), 'teapot');
% subplot(3,1,2)
% plotResults('Average error of ptcld ', 2, result1(25,:), 'butterfly', result2(25,:), 'cat', result3(25,:), 'teapot');
% subplot(3,1,3)
% plotResults('Hd ', 3, result1(5,:), 'butterfly', result2(5,:), 'cat', result3(5,:), 'teapot');

% subplot(3,1,1)    
% plotResults('Number of swarms', 1, result1(14,:), '');
% subplot(3,1,2)
% plotResults('Average error of ptcld ', 2, result1(25,:), '');
% subplot(3,1,3)
% plotResults('Hd ', 3, result1(5,:), '');

% legend('butterfly', 'cat', 'teapot');
%  plotResults('Average confidence of FLSs ', 20, result1(26,:), '\epsilon=5^{\circ}');











    
%     plotResults('Number of moving FLSs', 10, result1(2,:), '\epsilon=1^{\circ}', result2(2,:), '\epsilon=3^{\circ}', result3(2,:), '\epsilon=5^{\circ}');
%     plotResults('Minimum confidence of FLSs', 11, result1(13,:), '\epsilon=1^{\circ}', result2(13,:), '\epsilon=3^{\circ}', result3(13,:), '\epsilon=5^{\circ}');
%     axis([1 33 0 1])
%     plotResults('Average distance moved by Localizing FLSs', 12, result1(23,:), '\epsilon=1^{\circ}', result2(23,:), '\epsilon=3^{\circ}', result3(23,:), '\epsilon=5^{\circ}');
%     plotResults('Average distance moved by swarm FLSs', 13, result1(24,:), '\epsilon=1^{\circ}', result2(24,:), '\epsilon=3^{\circ}', result3(24,:), '\epsilon=5^{\circ}');
%     axis([1 33 0 4])
%     plotResults('Number of localizing FLSs', 14, result1(8,:), '\epsilon=1^{\circ}', result2(8,:), '\epsilon=3^{\circ}', result3(8,:), '\epsilon=5^{\circ}');
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

