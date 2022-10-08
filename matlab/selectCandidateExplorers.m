function [flss, indexes] = selectCandidateExplorers(allFlss)
    if size(allFlss,2) < 1
        flss = [];
    else
        minConf = Inf;
        minFls = 0;
        for i = 1:size(allFlss, 2)
            if allFlss(i).confidence < minConf
                minFls = allFlss(i);
            end
        end
        indexes = [1];
        flss = [minFls];
    end
end

