function flss = selectConcurrentExplorersSwarMer3(allFlss)
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
%             mNeighbors = mNeighbors(~[mNeighbors.freeze]);
            minP = length(swarm);
            anchor = flsj;
            for k=1:length(mNeighbors)
                mFls = mNeighbors(k);
                if mFls.freeze
                    continue;
                end
                N = 1;
                swarmn = mFls.swarm.getAllMembers([mFls]);
                p = length(swarmn);
                if p < minP
                    minP = p;
                    anchor = mFls;
                end


                for kk = 1:length(swarmn)
                    swarmn(kk).freeze = 1;
                end
        
            end

            if N == 1
                localizers = [flsj mNeighbors];
                localizers = setdiff(localizers, anchor);
    
                for k=1:length(localizers)
                    lFls = localizers(k);
                    lFls.celNeighbors = anchor;
                    flss = [flss lFls];
                end
            end

            if N ~= -1
                break
            end
        end


        for j = 1:size(swarm, 2)
            swarm(j).freeze = 1;
        end


%         if N == -1
%             continue;
%         end
% 
%         if fls.id > N.id
%             AFls = N;
%             LFls = fls;
%         else
%             AFls = fls;
%             LFls = N;
%         end
% 
%         LFls.celNeighbors = AFls;
% 
%         swarmn = N.swarm.getAllMembers([N]);
% 
%         for k = 1:size(swarmn, 2)
%             swarmn(k).freeze = 1;
%         end
% 
%         flss = [flss LFls];
    end
end



