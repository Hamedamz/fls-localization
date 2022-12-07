classdef FLSRatingM < FLSRating
    methods        
        function out = getRating(obj, fls)
            out = 1;
            m = size(fls.missingNeighbors, 2);
            k = size(fls.correctNeighbors, 2);

            n = m + k;

            if n == 0
                out = 0;
                return
            end

            out = out - (1/n) * m;

            if k == 0
                return
            end

            gtlDistance = vecnorm([fls.correctNeighbors.gtl] - fls.gtl);
            

            for i = 1:k
                R = fls.r;
                out = out - min(1/n,  R / gtlDistance(:,i));
            end
        end
    end
end

