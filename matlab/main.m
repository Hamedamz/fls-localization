function flss = main(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, pointCloud, clear, rounds, removeAlpha, concurrentPolicy)



flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0]) Dispatcher([0; 0; 0])};

distModelSet = {FLSDistLinear() FLSDistSquareRoot()};
ratingSet = {FLSRatingNormalizedDistanceGTL() FLSRatingMaxR() FLSRatingAvgR() FLSRatingRandom()};

switch concurrentPolicy
    case 1
        concurrentSelector = @selectConcurrentExplorers;
    case 2
        concurrentSelector = @selectConcurrentExplorers2;
end

% ratingSet = containers.Map( ...
%     {'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'}, ...
%     {FLSRatingDistanceTraveled(), ...
%     FLSRatingDistanceGTL(), ...
%     FLSRatingNormalizedDistanceGTL(), ...
%     FLSRatingObsGTLNeighbors(), ...
%     FLSRatingMissingNeighbors(), ...
%     FLSRatingErroneousNeighbors(), ...
%     FLSRatingNeighbors(.5, .5)} ...
%     );


for i = 1:size(pointCloud, 2)
    point = pointCloud(:,i);
    dispatcher = selectDispatcher(point, dispatchers);

    switch explorerType
        case 1
            explorer = FLSExplorerTriangulation(freezePolicy);
        case 2
            explorer = FLSExplorerTrilateration(freezePolicy);
        case 3
            explorer = FLSExplorerTriangulation(freezePolicy);
        case 4
            explorer = FLSExplorerDistAngle(freezePolicy);
        case 5
            explorer = FLSExplorerDistAngleAvg(freezePolicy);
        case 6
            explorer = FLSExplorerLoGlo(freezePolicy);
    end

    confidenceModel = ratingSet{confidenceType};
    weightModel = ratingSet{weightType};
    distModel = distModelSet{distType};
    swarm = FLSSwarm(swarmEnabled, swarmPolicy);

    fls = FLS(dispatcher.coord, point, alpha, weightModel, confidenceModel, distModel, explorer, swarm, screen);
    flss(i) = fls;
    fls.flyTo(point);
    fls.lastD = 0;
    fls.locked = 0;
    fls.distanceTraveled = 0;
    if removeAlpha
        fls.alpha = 0;
    end
    screen(fls.id) = fls;
end


grid on
plotScreen([flss.gtl], 'blue', 1);

plotScreen([flss.el], 'red', 2);

% return;
figure(3);

pltResults = zeros(18, rounds);

for j=1:rounds
    if clear
        clf
    end

    plotScreen([flss.el], 'red', 3);
    hold on

    fprintf('\nROUND %d:\n', j);

    if all([flss.freeze] == 1) 
        disp('  all FLS are freezed');
        for i = 1:size(flss, 2)
            flss(i).freeze = 0;
        end
        disp('  unfreezed all FLSs');
    end

    numFrozen = sum([flss.freeze]);
    fprintf('  %d FLS(s) are frozen\n', numFrozen);

%     dH = hausdorff([flss.gtl], [flss.el]);
%     if dH < .4
%         break
%     end


    candidateExplorers = selectCandidateExplorers(flss);
    numCandidate = size(candidateExplorers, 2);
    fprintf('  %d FLS(s) are less than 95 percent confident\n', numCandidate);

    if size(candidateExplorers, 2) < 1
        disp('  no FLSs is selected to move')

        if all([flss.freeze] == 0)
            break;
        else
            for k = 1:size(flss, 2)
                flss(k).freeze = 0;
            end
    
            continue;
        end
    end

    concurrentExplorers = concurrentSelector(candidateExplorers);
    numConcurrent = size(concurrentExplorers, 2);
    fprintf('  %d FLS(s) are selected to adjust\n', numConcurrent);

    calSuccess = 0;
    specificEr = 0;
    for i = 1:size(concurrentExplorers, 2)
        s = concurrentExplorers(i).initializeExplorer();
        if s > 0
            calSuccess = calSuccess + s;
        elseif s == -1
            specificEr = specificEr + 1;
        end
    end
    
    calFail = numConcurrent - calSuccess;
    fprintf('  %d FLS(s) failed to compute v\n', calFail);
    fprintf('  %d FLS(s) computed v\n', calSuccess);

    while size(concurrentExplorers, 2)
        itemsToRemove = [];

        for i = 1:size(concurrentExplorers, 2)
            fls = concurrentExplorers(i);
            fls.exploreOneStep();
            itemsToRemove = [itemsToRemove fls];
        end

        movSuccess = 0;
        for i = 1:size(itemsToRemove, 2)
            fls = itemsToRemove(i);
            movSuccess = movSuccess + fls.finalizeExploration();
        end
        fprintf('  %d FLS(s) have nonzero v\n', movSuccess);
        movZero = calSuccess - movSuccess;

        concurrentExplorers = setdiff(concurrentExplorers, itemsToRemove);

        count = 0;
        sumD = 0;
        maxD = -Inf;
        minD = Inf;

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

            fls.locked = 0;
            fls.lastD = 0;

            if fls.confidence < 0.5
                M = fls.swarm.members;

                if size(M, 2) > 0    
                    for k = 1:size(M, 2)
                        M(k).swarm.removeMember(fls);
                    end
                    fls.swarm.members = [];

                    fprintf('  FLS %s was removed from its swarm\n', fls.id);
                end
            end
                    
        end

        [numSwarms, swarmPopulation] = reportSwarm(flss);
        fprintf('  %d swarm(s) with %s members exist\n', numSwarms, strjoin(string(swarmPopulation), ', '));


        pltResults(1,j) = numFrozen;
        pltResults(2,j) = count;
        pltResults(3,j) = sumD / size(flss, 2);
        pltResults(4,j) = maxD;
        pltResults(5,j) = hausdorff([flss.gtl], [flss.el]);
        pltResults(6,j) = sum([flss.confidence]) / size(flss,2);
        pltResults(7,j) = numCandidate;
        pltResults(8,j) = numConcurrent;
        pltResults(9,j) = calSuccess;
        pltResults(10,j) = calFail;
        pltResults(11,j) = movSuccess;
        pltResults(12,j) = movZero;
        pltResults(13,j) = specificEr;
        pltResults(14,j) = numSwarms;
        pltResults(15,j) = min(swarmPopulation);
        pltResults(16,j) = mean(swarmPopulation);
        pltResults(17,j) = max(swarmPopulation);
        pltResults(18,j) = minD;


        fprintf('  %d FLS(s) moved\n', count);
        if count
            fprintf('   min: %f\n   avg %f\n   max %f\n', minD, sumD/count, maxD);
        end
    end

%     if numSwarms == 1
%         disp('all FLSs are in one swarm')
%         break;
%     end
    s = fls.swarm.getAllMembers([]);
    if size(s,2) == size(flss,2)
        disp('all FLSs are in one swarm')
        break;
    end

end

if clear
    clf
end

reportMetrics(flss);
plotScreen([flss.el], 'black', 3)

switch confidenceType
    case 1
    result1 = pltResults;
    save('result1.mat','result1');
    
    case 2
    result2 = pltResults;
    save('result2.mat','result2');

    case 3
    result3 = pltResults;
    save('result3.mat','result3');

    case 4
    result4 = pltResults;
    save('result4.mat','result4');
end

end

