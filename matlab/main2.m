function flss = main2(explorerType, confidenceType, weightType, distType, swarmEnabled, swarmPolicy, freezePolicy, alpha, pointCloud, physical, rounds, removeAlpha, concurrentPolicy, crm, fixN, ff)

rng('default');
rng(1);

flss = FLS.empty(size(pointCloud, 2), 0);
screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0; 0]) Dispatcher([0; 0; 0])};

distModelSet = {FLSDistLinear() FLSDistSquareRoot()};
ratingSet = {FLSRatingNormalizedDistanceGTL() FLSRatingM() FLSRatingX() FLSRatingRandom() FLSRatingMissingNeighbors()};

binary = 1;

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
            explorer = FLSExplorerDistAngle2(freezePolicy);
        case 5
            explorer = FLSExplorerDistAngleAvg(freezePolicy);
        case 6
            explorer = FLSExplorerLoGlo(freezePolicy);
    end

    confidenceModel = ratingSet{5};
    weightModel = ratingSet{5};
    distModel = distModelSet{distType};
    swarm = FLSSwarm(swarmEnabled, swarmPolicy);

    fls = FLS(dispatcher.coord, point, alpha, weightModel, confidenceModel, distModel, explorer, swarm, crm, 1, physical, screen);
    flss(i) = fls;
    fls.flyTo(point);
    fls.lastD = 0;
    fls.d0 = 0;
    fls.d1 = 0;
    fls.d2 = 0;
    fls.d3 = 0;
    fls.locked = 0;
    fls.visited = 0;
    fls.distanceTraveled = 0;
    if removeAlpha
        fls.alpha = 0;
    end
    screen(fls.id) = fls;
end


% plotScreen([flss.gtl], 'blue', 3*ff+1);
% 
% plotScreen([flss.el], 'red', 3*ff+2);

pltResults = zeros(26, rounds);
tries = 0;

dH = hausdorff([flss.gtl], [flss.el]);
txt = sprintf("Hausdorff Distance: %f\n", dH);

h = plotScreen([flss.el], 'red', 2*ff+1);
% gifName = sprintf('gif/bin%d.gif', ff);

annotation('textbox',[.7 .7 .3 .3], ...
    'String',txt,'EdgeColor','none')

% figure(4);
% s=scatter(pointCloud(1,:), pointCloud(2,:), 'red', 'filled');
% axis square;

for j=1:rounds
    terminate = 0;

    fprintf('\nROUND %d:\n', j);

    if binary
        concurrentExplorers = selectConcurrentExplorers4(flss);
    else
        concurrentExplorers = selectConcurrentExplorersSwarMer3(flss);
    end

    numConcurrent = size(concurrentExplorers, 2);
    fprintf('  %d FLS(s) are selected to adjust\n', numConcurrent);


    anchors = [];
    sumL = 0;
    movSuccess = 0;
    calSuccess = 0;

    for i = 1:numConcurrent
        s = concurrentExplorers(i).initializeExplorer();
        if s > 0
            calSuccess = calSuccess + s;
        end
        fls = concurrentExplorers(i);
        fls.exploreOneStep();
        movSuccess = movSuccess + fls.finalizeExploration();
        sumL = sumL + fls.lastD;
        anchors = [anchors fls.explorer.neighbor];
    end

    
    calFail = numConcurrent - calSuccess;
    fprintf('  %d FLS(s) failed to compute v\n', calFail);
    fprintf('  %d FLS(s) computed v\n', calSuccess);

    fprintf('  %d FLS(s) have nonzero v\n', movSuccess);
    movZero = calSuccess - movSuccess;

    count = 0;
    sumD = 0;
    maxD = -Inf;
    minD = Inf;

    [text2, avgE, avgC] = reportMetrics(flss);
    pltResults(25,j) = avgE; % average error
    pltResults(26,j) = avgC;

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
        fls.freeze = 0;
        fls.visited = 0;
%         fls.d0 = 0;
%         fls.d1 = 0;
%         fls.d2 = 0;
%         fls.d3 = 0;
                
    end

    [numSwarms, swarmPopulation] = reportSwarm(flss);
    fprintf('  %d swarm(s) with %s members exist\n', numSwarms, strjoin(string(swarmPopulation), ', '));


    [uniqAnchors,~,ix] = unique(anchors);
    C = accumarray(ix,1).';
    C=C(C~=1);

    pltResults(2,j) = count; % number of all moveing FLSs
    pltResults(3,j) = sumD / count; % average distance traveled by al FLSs
    pltResults(4,j) = maxD;
    pltResults(8,j) = numConcurrent; % number of localizing FLSs
    pltResults(9,j) = calSuccess;
    pltResults(10,j) = calFail;
    pltResults(11,j) = movSuccess;
    pltResults(12,j) = movZero;
    pltResults(14,j) = numSwarms; % number of swarms
    pltResults(15,j) = min(swarmPopulation);
    pltResults(16,j) = mean(swarmPopulation); % average population of swarms
    pltResults(17,j) = max(swarmPopulation);
    pltResults(18,j) = length(uniqAnchors); % number of anchors
    pltResults(22,j) = length(C); % number of shared anchors

    if numConcurrent == 0
        pltResults(23,j) = 0;
    else
        pltResults(23,j) = sumL / movSuccess; % avg distance traveled by localizing FLSs
    end

    if count - movSuccess == 0
        pltResults(27,j) = 0;
    else
        pltResults(27,j) = (sumD - sumL) / (count - movSuccess); % average distance traveled by swarms
    end



    fprintf('  %d FLS(s) moved\n', count);

    updateScreen(h, [flss.el]);
%     exportgraphics(gcf,gifName,'Append',true);

    dH = hausdorff([flss.gtl], [flss.el]);
    pltResults(5,j) = dH;

    s = fls.swarm.getAllMembers([]);
%     || numConcurrent == 0
    if size(s,2) == size(flss,2) 
        disp('all FLSs are in one swarm')
        
        fprintf("Hausdorff Distance: %f\n", dH);

        tries = 1 + tries;
        if dH < 0.09
            break;
        end
        if tries == 5
            break;
        end

        for i = 1:size(flss,2)
            flss(i).swarm.members = [];
        end
    end

%     figure(4);
%     set(s, 'XData', pointCloud(1,:), 'YData', pointCloud(2,:));
%     s=scatter3(pointCloud(1,:), pointCloud(2,:), pointCloud(3,:), color, 'filled');

end


figure(2*ff+2);
clf

text1 = sprintf("rounds: %d\nnumber of swarm resets: %d\n", j, tries-1);

dH = hausdorff([flss.gtl], [flss.el]);
txt = sprintf("%s\n%s\nHausdorff Distance: %f\n", text1, text2, dH);

plotScreen([flss.el], 'black', 2*ff+2)
annotation('textbox',[.7 .7 .3 .3], ...
    'String',txt,'EdgeColor','none')

fileName = sprintf('resultSwarmer-%d-%d.mat', ff, alpha);
save(fileName, 'pltResults');

end

