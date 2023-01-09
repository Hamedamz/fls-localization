% Final binary: mereges swarms using closest anchor

function flss = selectConcurrentExplorers4(allFlss)
    n = size(allFlss,2);
    if n < 1
        flss = [];
    else
        flss = [];

        for i = 1:n
            fls = allFlss(i);
            
            if fls.freeze == 1
                continue;
            end

            swarm = fls.swarm.getAllMembers([]);

            for j = 1:size(swarm, 2)
                swarm(j).freeze = 1;
            end

            fls.freeze = 1;

            minD = inf;
            N = -1;
            for j = 1:n
                flsn = allFlss(j);

                if flsn.freeze == 1
                    continue;
                end

                d = fls.distModel.getDistance(fls, flsn);
                if d < minD
                    minD = d;
                    N = flsn;
                end
            end

            if N == -1
                continue;
            end

            fls.celNeighbors = N;

            swarmn = N.swarm.getAllMembers([]);

            for k = 1:size(swarmn, 2)
                swarmn(k).freeze = 1;
            end

            N.freeze = 1;
            flss = [flss fls];
        end
    end
end



