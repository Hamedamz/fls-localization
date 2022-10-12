classdef FLSRatingNormalizedDistanceGTL < FLSRating
    methods        
        function out = getRating(obj, fls)
            elDistance = [fls.gtlNeighbors.el] - fls.el;
            gtlDistance = [fls.gtlNeighbors.gtl] - fls.gtl;

            out = 1;
            n = size(fls.gtlNeighbors, 2);
            for i = 1:n
                out = out - min(1/n, abs(norm(elDistance(:,i)) - norm(gtlDistance(:,i))) / norm(gtlDistance(:,i)));
            end
        end
    end
end

