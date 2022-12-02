function flss = main3(flss, clear, rounds, ff)

rng('default');
rng(1);

% flss = FLS.empty(size(pointCloud, 2), 0);
% screen = containers.Map('KeyType','char','ValueType','any');
% dispatchers = {Dispatcher([0; 0]) Dispatcher([0; 0; 0])};
% 
% distModelSet = {FLSDistLinear() FLSDistSquareRoot()};
% ratingSet = {FLSRatingNormalizedDistanceGTL() FLSRatingMaxR() FLSRatingAvgR() FLSRatingRandom() FLSRatingMissingNeighbors()};
% 
% 
% for i = 1:size(pointCloud, 2)
%     point = pointCloud(:,i);
%     dispatcher = selectDispatcher(point, dispatchers);
% 
%     switch explorerType
%         case 1
%             explorer = FLSExplorerTriangulation(freezePolicy);
%         case 2
%             explorer = FLSExplorerTrilateration(freezePolicy);
%         case 3
%             explorer = FLSExplorerTriangulation(freezePolicy);
%         case 4
%             explorer = FLSExplorerDistAngle2(freezePolicy);
%         case 5
%             explorer = FLSExplorerDistAngleAvg(freezePolicy);
%         case 6
%             explorer = FLSExplorerLoGlo(freezePolicy);
%     end
% 
%     confidenceModel = ratingSet{5};
%     weightModel = ratingSet{5};
%     distModel = distModelSet{distType};
%     swarm = FLSSwarm(swarmEnabled, swarmPolicy);
% 
%     fls = FLS(dispatcher.coord, point, alpha, weightModel, confidenceModel, distModel, explorer, swarm, crm, 1, screen);
%     flss(i) = fls;
%     fls.flyTo(point);
%     fls.lastD = 0;
%     fls.locked = 0;
%     fls.distanceTraveled = 0;
%     if removeAlpha
%         fls.alpha = 0;
%     end
%     screen(fls.id) = fls;
% end


grid on
plotScreen([flss.gtl], 'blue', 3*ff+1);

plotScreen([flss.el], 'red', 3*ff+2);

figure(3*ff+3);

pltResults = zeros(26, rounds);

tries = 0;

for j=1:rounds
    terminate = 0;
    if clear
        clf
    end

    plotScreen([flss.el], 'red', 3*ff+3);
    hold on

    fprintf('\nROUND %d:\n', j);

    concurrentExplorers = selectConcurrentExplorers4(flss);
    numConcurrent = size(concurrentExplorers, 2);
    fprintf('  %d FLS(s) are selected to adjust\n', numConcurrent);

    calSuccess = 0;
    for i = 1:size(concurrentExplorers, 2)
        s = concurrentExplorers(i).initializeExplorer();
        if s > 0
            calSuccess = calSuccess + s;
        end
    end
    
    calFail = numConcurrent - calSuccess;
    fprintf('  %d FLS(s) failed to compute v\n', calFail);
    fprintf('  %d FLS(s) computed v\n', calSuccess);

    anchors = [];
    sumL = 0;
    movSuccess = 0;

    for i = 1:numConcurrent
        fls = concurrentExplorers(i);
        fls.exploreOneStep();
        movSuccess = movSuccess + fls.finalizeExploration();
        sumL = sumL + fls.lastD;
    end

    fprintf('  %d FLS(s) have nonzero v\n', movSuccess);
    movZero = calSuccess - movSuccess;

    count = 0;
    sumD = 0;
    maxD = -Inf;
    minD = Inf;
    minC = Inf;

    for i = 1:size(flss, 2)
        fls = flss(i);
        d = fls.lastD;

        if d > 0
            count = count + 1;
            sumD = sumD + d;
        end

        if d > maxD
            maxD = d;
        end
        if d < minD
            minD = d;
        end

        if fls.confidence < minC
            minC = fls.confidence;
        end

     

        fls.locked = 0;
        fls.lastD = 0;
        fls.freeze = 0;
                
    end

    [numSwarms, swarmPopulation] = reportSwarm(flss);
    fprintf('  %d swarm(s) with %s members exist\n', numSwarms, strjoin(string(swarmPopulation), ', '));


    pltResults(2,j) = count;
    pltResults(3,j) = sumD / size(flss, 2);
    pltResults(4,j) = maxD;
    pltResults(6,j) = sum([flss.confidence]) / size(flss,2);
    pltResults(8,j) = numConcurrent;
    pltResults(9,j) = calSuccess;
    pltResults(10,j) = calFail;
    pltResults(11,j) = movSuccess;
    pltResults(12,j) = movZero;
    pltResults(14,j) = numSwarms;
    pltResults(15,j) = min(swarmPopulation);
    pltResults(16,j) = mean(swarmPopulation);
    pltResults(17,j) = max(swarmPopulation);
    pltResults(18,j) = minD;
    pltResults(22,j) = max(0,size(anchors,2) - size(unique(anchors),2));
    if numConcurrent == 0
        pltResults(23,j) = 0; % avg d localizing
    else
        pltResults(23,j) = sumL / movSuccess; % avg d localizing
    end

    [s, avgE, avgC] = reportMetrics(flss);
    pltResults(25,j) = avgE;
    pltResults(26,j) = avgC;


    fprintf('  %d FLS(s) moved\n', count);

    s = fls.swarm.getAllMembers([]);
    if size(s,2) == size(flss,2)
        disp('all FLSs are in one swarm')
        dH = hausdorff([flss.gtl], [flss.el]);
        fprintf("Hausdorff Distance: %f\n", dH);

        break;
    end

end

if clear
    clf
end

text1 = sprintf("rounds: %d\nnumber of swarm resets: %d\n", j, tries-1);

% text1 = sprintf("Number of neighbors:\nmin: %d\navg: %f\nmax: %d\nrounds: %d",pltResults(19,1),pltResults(20,1),pltResults(21,1), j);


text2 = reportMetrics(flss);

dH = hausdorff([flss.gtl], [flss.el]);
txt = sprintf("%s\n%s\nHausdorff Distance: %f\n", text1, text2, dH);

plotScreen([flss.el], 'black', 3*ff+3)
annotation('textbox',[.7 .7 .1 .2], ...
    'String',txt,'EdgeColor','none')

switch ff
    case 0
    result1 = pltResults;
    save('result1.mat','result1');
    
    case 1
    result2 = pltResults;
    save('result2.mat','result2');

    case 2
    result3 = pltResults;
    save('result3.mat','result3');

    case 3
    result4 = pltResults;
    save('result4.mat','result4');

    case 4
    result5 = pltResults;
    save('result5.mat','result5');

    case 5
    result6 = pltResults;
    save('result6.mat','result6');

    case 6
    result7 = pltResults;
    save('result7.mat','result7');
end

end

