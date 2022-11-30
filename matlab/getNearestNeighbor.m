function [N, k] = getNearestNeighbor(fls, flss)
    minD = inf;
    N = [];
    k = [];
    for i = 1:size(flss,2)
        d = fls.distModel.getDistance(fls, flss(i));
        if d < minD
            minD = d;
            N = flss(i);
            k = i;
        end
    end
end
