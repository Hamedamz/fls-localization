function [numSwarms, swarmPopulation, avgConf] = reportSwarm(flss)
    n = size(flss,2);

    visited = [];
    numSwarms = 0;
    swarmPopulation = [0];
    avgConf = [0];

    for i = 1:n
        fls = flss(i);

        v = 0;
        for j = 1:size(visited, 2)
            if fls.id == visited(j).id
                v = 1;
            end
        end

        if v
            continue;
        end

        swarm = fls.swarm.getAllMembers([]);
        ns = size(swarm, 2);
        if ns > 1
            numSwarms = numSwarms + 1;
            swarmPopulation(numSwarms) = ns;
            avgConf(numSwarms) = mean([swarm.confidence]);
        end

        visited = [visited swarm];
    end
end

