function flss = selectConcurrentExplorers5(allFlss)
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

            
            swarm = fls.swarm.getAllMembers([fls]);

            f = getLeastConfident(swarm);
%             if f.id ~= fls.id
%                 continue
%             end
            Ns = setdiff(f.gtlNeighbors, swarm);
            Ns = Ns(~[Ns.freeze]);
            N = getNearestNeighbor(f, Ns);


            for j = 1:size(swarm, 2)
                swarm(j).freeze = 1;
            end



            if size(N,2) == 0
                continue;
            end

            f.celNeighbors = N;

            swarmn = N.swarm.getAllMembers([]);

            for k = 1:size(swarmn, 2)
                swarmn(k).freeze = 1;
            end

            N.freeze = 1;
            flss = [flss f];
            
        end
    end
end

