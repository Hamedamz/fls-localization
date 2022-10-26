function flss = main(explorerType, confidenceType, weightType, distType, pointCloud, clear)



flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0]) Dispatcher([0; 0; 0])};


explorerSet = {
    FLSExplorerTriangulation()
    FLSExplorerTrilateration()
    FLSExplorerTriangulation()
    FLSExplorerDistAngle()
    FLSExplorerLoGlo()
    FLSExplorerBasic(0.3)};

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

    explorer = explorerSet{explorerType};
    confidenceModel = ratingSet(confidenceType);
    weightModel = ratingSet(weightType);
    distModel = distModelSet{distType};

    fls = FLS(dispatcher.coord, point, weightModel, confidenceModel, distModel, explorer, screen);
    flss(i) = fls;
    fls.flyTo(point);
    screen(fls.id) = fls;
end


grid on
plotScreen([flss.gtl], 'blue', 1);

plotScreen([flss.el], 'red', 2);

plotScreen([flss.el], 'red', 3);
hold on

% return;

for j=1:15000
%     flag = 0;
%     for i = 1:size(flss, 2)
%         if flss(i).confidence ~= 1.0
%             flasg = 0;
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

    %disp([flss.freeze])
    if all([flss.freeze] == 1) 
        for i = 1:size(flss, 2)
            flss(i).freeze = 0;
        end
    end

    if all([flss.confidence] > .99) 
        disp("all confidences are 1")
        break;
    end

%     dH = hausdorff([flss.gtl], [flss.el]);
%     if dH < .4
%         break
%     end


    candidateExplorers = selectCandidateExplorers(flss);

    if size(candidateExplorers, 2) < 1
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
        if clear
            clf
        end

        plotScreen([flss.el], 'red', 3);
        hold on

        itemsToRemove = [];

        for i = 1:size(concurrentExplorers, 2)
            fls = concurrentExplorers(i);

            if fls.explorer.isFinished
                m = fls.finalizeExploration();
                if ~m && explorerType == 3
                    fls.explorer = explorerSet{2};
                    fprintf("switched %s to trialateration\n", fls.id);
                    fls.initializeExplorer();
                else
                    itemsToRemove = [itemsToRemove fls];
                    fprintf('%d - fls %s with confidence %.2f finished exploring\n', j, fls.id, fls.confidence);
%                 if m
%                     for k = 1:size(flss, 2)
%                         if flss(k).id ~= fls.id
%                             flss(k).freeze = 0;
%                         end
%                     end
%                 end
                end
                continue;
            end
            
            fls.exploreOneStep();
        end

        concurrentExplorers = setdiff(concurrentExplorers, itemsToRemove);
    end

end

reportMetrics(flss);
plotScreen([flss.el], 'black', 3)

end

