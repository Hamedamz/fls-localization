classdef FLSRatingDistanceGTL < FLSRating
    methods        
        function out = getRating(obj, fls)
            elDistance = [fls.gtlNeighbors.el] - fls.el;
            gtlDistance = [fls.gtlNeighbors.gtl] - fls.gtl;

            out = 0;
            for i = 1:size(fls.gtlNeighbors, 2)
                out = out - abs(norm(elDistance(:,i)) - norm(gtlDistance(:,i)));
            end
        end
    end
end

