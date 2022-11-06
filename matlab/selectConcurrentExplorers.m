function flss = selectConcurrentExplorers(allFlss)
    n = size(allFlss,2);
    if n < 1
        flss = [];
    else
        flss = [];
        visited = [];
        
        for i = 1:n
            fls = allFlss(i);
            elN = fls.elNeighbors;

            N = [fls elN];
            lConf = getLeastConfident(N);

            if fls.id ~= lConf.id
                continue;
            end

            v = 0;
            for j = 1:size(visited, 2)
                if fls.id == visited(j).id
                    v = 1;
                end
            end

            if v
                continue;
            end

            flss = [flss fls];


            load('config.mat', 'swarmPolicy');

            if swarmPolicy == 1
                swarm = fls.swarm.getAllMembers([]);
            else
                swarm = [];
            end

            visited = [visited N swarm];
        end
    end
end

