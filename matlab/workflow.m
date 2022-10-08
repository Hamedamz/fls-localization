pointCloud = [
    0 0 1 1;
    0 1 1 0
    ] + 5;

flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0])};

for i = 1:size(pointCloud, 2)
    point = pointCloud(:,i);
    dispatcher = selectDispatcher(point, dispatchers);

    explorer = FLSExplorerBasic(0.5);
    confidenceModel = FLSConfidenceDistance();
    weightModel = FLSWeightBasic();

    fls = FLS(dispatcher.coord, point, weightModel, confidenceModel, explorer, screen);
    flss(i) = fls;
    fls.flyTo(point);
    screen(fls.id) = fls;
end

plotScreen(flss, pointCloud);

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
        plotScreen(flss, pointCloud);
    end

    
    break;
end

plotScreen(flss, pointCloud, "black")