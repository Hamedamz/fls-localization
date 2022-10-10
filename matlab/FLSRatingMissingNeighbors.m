classdef FLSRatingMissingNeighbors < FLSRating
    methods
        function out = getRating(obj, fls)
            out = 1 - (size(fls.missingNeighbors, 2) / (size(fls.el, 1) ^ 2 - 1));
        end
    end
end

