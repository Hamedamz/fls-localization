classdef FLSRatingErroneousNeighbors < FLSRating
    methods
        function out = getRating(obj, fls)
            out = 1 - (size(fls.erroneousNeighbors, 2) / (size(fls.el, 1) ^ 2 - 1));
        end
    end
end

