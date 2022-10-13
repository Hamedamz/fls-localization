function flss = main(explorerType, confidenceType, weightType, pointCloud)



flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0])};


explorerSet = containers.Map({'basic', 'TriL'}, {FLSExplorerBasic(0.3), FLSExplorerTrilateration()});

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

    explorer = explorerSet(explorerType);
    confidenceModel = ratingSet(confidenceType);
    weightModel = ratingSet(weightType);

    fls = FLS(dispatcher.coord, point, weightModel, confidenceModel, explorer, screen);
    flss(i) = fls;
    fls.flyTo(point);
    screen(fls.id) = fls;
end

plotScreen(flss, pointCloud, 'red');

for j=1:10
%     flag = 0;
%     for i = 1:size(flss, 2)
%         if flss(i).confidence ~= 1.0
%             flag = 0;
%         end
%     end
%     if flag
%         flss.confidence
%         for i = 1:size(flss, 2)
%             flss(i).confidenceModel = ratingSet('distNormalizedGTL');
%             flss(i).weightModel = ratingSet('distNormalizedGTL');
%         end
%         
%         disp('switched to distance heuristic')
%     end

    candidateExplorers = selectCandidateExplorers(flss);

    if size(candidateExplorers, 2) < 1
        break;
    end

    concurrentExplorers = selectConcurrentExplorers(candidateExplorers);

    for i = 1:size(concurrentExplorers, 2)
        concurrentExplorers(i).initializeExplorer();
    end

    while size(concurrentExplorers, 2)
        itemsToRemove = [];

        for i = 1:size(concurrentExplorers, 2)
            fls = concurrentExplorers(i);

            if fls.explorer.isFinished
                fls.finalizeExploration();
                itemsToRemove = [itemsToRemove fls];
                sprintf('fls %s finished exploring', fls.id)
                continue;
            end
            
            fls.exploreOneStep();
        end

        concurrentExplorers = setdiff(concurrentExplorers, itemsToRemove);
        plotScreen(flss, pointCloud, 'red');
    end

end

reportMetrics(flss);
plotScreen(flss, pointCloud, 'black')

end

