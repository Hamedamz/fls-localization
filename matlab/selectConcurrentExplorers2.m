function flss = selectConcurrentExplorers2(allFlss)
    n = size(allFlss,2);
    if n < 1
        flss = [];
    else
        flss = [];
        visited = [];

        for i = 1:n
            fls = allFlss(i);
            elN = fls.elNeighbors;

            v = 0;
            for j = 1:size(visited, 2)
                if fls.id == visited(j).id
                    v = 1;
                end
            end

            if v
                continue;
            end


            load('config.mat', 'swarmPolicy');

            if swarmPolicy == 1
                swarm = fls.swarm.getAllMembers([]);
            else
                swarm = [];
            end

            mConf = getMostConfident(elN);

            flss = [flss fls];
            visited = [visited mConf fls swarm];
        end
    end
end

