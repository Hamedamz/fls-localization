function flss = selectConcurrentExplorersSwarMer(allFlss)
    n = size(allFlss,2);
    flss = [];
    minNumberOfNeighbors = 5;

    for i = 1:n
        fls = allFlss(i);
        
        if fls.freeze == 1
            continue;
        end

        swarm = fls.swarm.getAllMembers([fls]);
        N = -1;

        for j=1:length(swarm)
            flsj = swarm(j);
            knn = getKNN(flsj, allFlss, minNumberOfNeighbors);
            maxR = max(vecnorm([knn.el] - flsj.el));
            eNeighbors = getRS(flsj, allFlss, maxR);
            gtIdx = rangesearch([allFlss.gtl].',[flsj.gtl].', maxR);
            gtNeighbors = allFlss(gtIdx{:});
            seNeighbors = intersect(eNeighbors, swarm);
            osgtNeighbors = setdiff(gtNeighbors, swarm);
            mNeighbors = setdiff(osgtNeighbors, seNeighbors);
            for k=1:length(mNeighbors)
                mFls = mNeighbors(k);
                if ~mFls.freeze
                    fls = flsj;
                    N = mFls;
                    break;
                end
            end
            if N ~= -1
                break
            end
        end


        for j = 1:size(swarm, 2)
            swarm(j).freeze = 1;
        end


        if N == -1
            continue;
        end

        if fls.id > N.id
            AFls = N;
            LFls = fls;
        else
            AFls = fls;
            LFls = N;
        end

        LFls.celNeighbors = AFls;

        swarmn = N.swarm.getAllMembers([N]);

        for k = 1:size(swarmn, 2)
            swarmn(k).freeze = 1;
        end

        flss = [flss LFls];
    end
end



