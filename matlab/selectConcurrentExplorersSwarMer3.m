function flss = selectConcurrentExplorersSwarMer3(allFlss)
    n = size(allFlss,2);
    flss = [];
    minNumberOfNeighbors = 5;

    for i = 1:n
        fls = allFlss(i);
        
        if fls.freeze == 1 || fls.visited == 1
            continue;
        end

        swarm = fls.swarm.getAllMembers([fls]);

        for q=1:length(swarm)
            swarm(q).visited = 1;
        end

        for j=1:length(swarm)
            flsj = swarm(j);
            knn = getKNN(flsj, allFlss, minNumberOfNeighbors+1);
            missingN = knn(~ismember(knn, swarm));
            missingAN = missingN(~[missingN.freeze]);

            if ~isempty(missingAN)
                misingS = [];
                maxP = length(swarm);
                maxPFls = flsj;

                for k=1:length(missingAN)
                    mFls = missingAN(k);
                    if ~mFls.freeze
                        mSwarm = mFls.swarm.getAllMembers([mFls]);
                        for q=1:length(mSwarm)
                            mSwarm(q).freeze = 1;
                        end
                        misingS = [misingS mFls];
                        if length(mSwarm) > maxP
                            maxP = length(mSwarm);
                            maxPFls = mFls;
                        end
                    end
                end
                
                if ~isempty(misingS)
                    localizingCandidates = [misingS flsj];

                    for p=1:length(localizingCandidates)
                        lFls = localizingCandidates(p);
                        if lFls.id == maxPFls
                            continue;
                        end
                        lFls.celNeighbors = maxPFls;
                        flss = [flss lFls];
                    end

                    for q=1:length(swarm)
                        swarm(q).freeze = 1;
                    end

                    break;
                end

            elseif ~isempty(missingN)
                flsj.celNeighbors = missingN(1);
                flss = [flss flsj];

                for q=1:length(swarm)
                    swarm(q).freeze = 1;
                end

                break;
            end
        end
    end
end




