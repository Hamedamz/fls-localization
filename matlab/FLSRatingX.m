classdef FLSRatingX < FLSRating
    methods        
        function out = getRating(obj, fls)
            out = 1;
            e = size(fls.erroneousNeighbors, 2);
            m = size(fls.missingNeighbors, 2);
            k = size(fls.correctNeighbors, 2);

            n = e + m + k;

            if n == 0
                out = 0;
                return
            end

            out = out - (1/n) * (e + m);

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

