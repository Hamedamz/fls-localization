function [flss] = selectCandidateExplorers(allFlss)
    if size(allFlss,2) < 1
        flss = [];
    else
        minConf = 1;
        minFls = [];
        for i = 1:size(allFlss, 2)
            if allFlss(i).confidence < minConf
                minConf = allFlss(i).confidence;
                minFls = allFlss(i);
            end
        end
        flss = [minFls];
    end
end

