classdef FLSRatingNormalizedDistanceGTL < FLSRating
    methods        
        function out = getRating(obj, fls)
            out = 1;
            n = size(fls.gtlNeighbors, 2);

            if n == 0
                return;
            end

            elDistance = [fls.gtlNeighbors.el] - fls.el;
            gtlDistance = [fls.gtlNeighbors.gtl] - fls.gtl;
            
            for i = 1:n
                out = out - min(1/n, abs(norm(elDistance(:,i)) - norm(gtlDistance(:,i))) / norm(gtlDistance(:,i)));
            end
        end
    end
end

