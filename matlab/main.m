function flss = main(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, pointCloud, clear)



flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0]) Dispatcher([0; 0; 0])};

distModelSet = {FLSDistLinear() FLSDistSquareRoot()};

ratingSet = containers.Map( ...
    {'distTraveled', 'distGTL', 'distNormalizedGTL', 'obsGTLN', 'mN', 'eN', 'hN'}, ...
    {FLSRatingDistanceTraveled(), ...
    FLSRatingDistanceGTL(), ...
    FLSRatingNormalizedDistanceGTL(), ...
    FLSRatingObsGTLNeighbors(), ...
    FLSRatingMissingNeighbors(), ...
    FLSRatingErroneousNeighbors(), ...
    FLSRatingNeighbors(.5, .5)} ...
    );


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

    confidenceModel = ratingSet(confidenceType);
    weightModel = ratingSet(weightType);
    distModel = distModelSet{distType};
    swarm = FLSSwarm(swarmEnabled, swarmPolicy);

    fls = FLS(dispatcher.coord, point, alpha, weightModel, confidenceModel, distModel, explorer, swarm, screen);
    flss(i) = fls;
    fls.flyTo(point);
    fls.lastD = 0;
    fls.locked = 0;
    fls.distanceTraveled = 0;
    screen(fls.id) = fls;
end


grid on
plotScreen([flss.gtl], 'blue', 1);

plotScreen([flss.el], 'red', 2);

% return;
figure(3);

rounds = 100;
pltResults = zeros(6, rounds);

for j=1:rounds
    terminate = 0;

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

    concurrentExplorers = selectConcurrentExplorers(candidateExplorers);

    for i = 1:size(concurrentExplorers, 2)
        concurrentExplorers(i).initializeExplorer();
    end

    while size(concurrentExplorers, 2)
        itemsToRemove = [];

        for i = 1:size(concurrentExplorers, 2)
            fls = concurrentExplorers(i);

%             if fls.explorer.isFinished
%                 m = fls.finalizeExploration();
%                 itemsToRemove = [itemsToRemove fls];
%                 %fprintf('%d - fls %s with confidence %.2f finished exploring\n', j, fls.id, fls.confidence);
% 
%                 continue;
%             end
            
            fls.exploreOneStep();
            itemsToRemove = [itemsToRemove fls];
        end

        fprintf('  %d FLS(s) computed v\n', size(itemsToRemove, 2));
        %disp([itemsToRemove.id]);

        
        for i = 1:size(itemsToRemove, 2)
            fls = itemsToRemove(i);
            fls.finalizeExploration();
        end

        concurrentExplorers = setdiff(concurrentExplorers, itemsToRemove);

        count = 0;
        sumD = 0;
        maxD = -Inf;
        minD = Inf;

        for i = 1:size(flss, 2)
            d = flss(i).lastD;

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

            flss(i).locked = 0;
            flss(i).lastD = 0;
        end

        pltResults(1,j) = numFrozen;
        pltResults(2,j) = count;
        pltResults(3,j) = sumD / count;
        pltResults(4,j) = maxD;
        pltResults(5,j) = hausdorff([flss.gtl], [flss.el]);
        pltResults(6,j) = sum([flss.confidence]) / size(flss,2);

        fprintf('  %d FLS(s) moved\n', count);
        if count
            fprintf('   min: %f\n   avg %f\n   max %f\n', minD, sumD/count, maxD);
        else
            s = fls.swarm.getAllMembers([]);
            if size(s,2) == size(flss,2)
                disp('all FLSs are in one swarm')
                terminate = 1;
            end
        end
    end
%     if terminate
%         break;
%     end
end

if clear
    clf
end

reportMetrics(flss);
plotScreen([flss.el], 'black', 3)

if swarmPolicy == 1
    result1 = pltResults;
    save('result1.mat','result1');
else
    result2 = pltResults;
    save('result2.mat','result2');
end
end

