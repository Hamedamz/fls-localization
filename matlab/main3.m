function flss = main3(flss, rounds, ff)
% 
% rng('default');
% rng(1);


pltResults = zeros(26, rounds);

tries = 0;

figure(2*ff-1)
clf
plotScreen([flss.el], 'red', 2*ff-1);
% axis([0 30 0 30])
% view([0 90])

for j=1:rounds
    terminate = 0;

    fprintf('\nMERGING ROUND %d:\n', j);

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


    if numSwarms == 1 && swarmPopulation(1) == length(flss)
        disp('all FLSs are in one swarm')
        break;
    end

end


text1 = sprintf("rounds: %d\nnumber of swarm resets: %d\n", j, tries-1);

% text1 = sprintf("Number of neighbors:\nmin: %d\navg: %f\nmax: %d\nrounds: %d",pltResults(19,1),pltResults(20,1),pltResults(21,1), j);


text2 = reportMetrics(flss);

dH = hausdorff([flss.gtl], [flss.el]);
txt = sprintf("%s\n%s\nHausdorff Distance: %f\n", text1, text2, dH);

fprintf("End of round %d\nMerged cubes\n%s\n", ff, txt);

figure(2*ff)
clf
plotScreen([flss.el], 'black', 2*ff);
annotation('textbox',[.7 .7 .1 .2], ...
    'String',txt,'EdgeColor','none')
% axis([0 30 0 30])
% view([0 90])

% fileName = sprintf('resultCube%d.mat', ff);
% save(fileName, 'pltResults');

end

