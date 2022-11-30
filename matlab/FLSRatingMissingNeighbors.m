classdef FLSRatingMissingNeighbors < FLSRating
    methods
        function out = getRating(obj, fls)
            out = 1 - (size(fls.missingNeighbors, 2) / size(fls.gtlNeighbors, 2));
        end
    end
end

