function [flss, indexes] = selectConcurrentExplorers(allFlss)
    if size(allFlss,2) < 1
        flss = [];
    else
        indexes = [1];
        flss = [allFlss(1)];
    end
end

