function main(explorerMode, confidenceMode, weightMode)

pointCloud = [
    0 0 1 1;
    0 1 1 0
    ] + 5;

flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0])};


explorerSet = containers.Map({'basic'}, {FLSExplorerBasic(0.5)});

confidenceModelSet = containers.Map( ...
    {'basic', 'mN', 'eN', 'hN'}, ...
    {FLSRatingDistanceTraveled(), ...
    FLSRatingMissingNeighbors(), ...
    FLSRatingErroneousNeighbors(), ...
    FLSRatingNeighbors(.5, .5)});

weightModelSet = containers.Map({'basic'}, {FLSRatingDistanceGTL()});


for i = 1:size(pointCloud, 2)
    point = pointCloud(:,i);
    dispatcher = selectDispatcher(point, dispatchers);

    explorer = explorerSet(explorerMode);
    confidenceModel = confidenceModelSet(confidenceMode);
    weightModel = weightModelSet(weightMode);

    fls = FLS(dispatcher.coord, point, weightModel, confidenceModel, explorer, screen);
    flss(i) = fls;
    fls.flyTo(point);
    screen(fls.id) = fls;
end

plotScreen(flss, pointCloud, 'red');

while 1
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
                continue;
            end
            
            fls.exploreOneStep();
        end

        concurrentExplorers = setdiff(concurrentExplorers, itemsToRemove);
        plotScreen(flss, pointCloud, 'red');
    end

    
    break;
end

reportMetrics(flss);
plotScreen(flss, pointCloud, 'black')

end

