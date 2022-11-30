function [N, k] = getTwoNearestNeighbor(fls, flss)
    minD = [inf inf];
    N = [];
    k = [];
    for i = 1:size(flss,2)
        d = fls.distModel.getDistance(fls, flss(i));
        if d < minD(1)
            minD(1) = d;
            if size(N,2) > 0
                N(2) = N(1);
                k(2) = k(1);
            end
            N(1) = flss(i);
            k(1) = i;
        elseif d < minD(2)
            minD(2) = d;
            N(2) = flss(i);
            k(2) = i;
        end
    end
end
