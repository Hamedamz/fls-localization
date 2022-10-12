classdef FLSRatingObsGTLNeighbors < FLSRating
    methods
        function out = getRating(obj, fls)
            out = (size(intersect(fls.gtlNeighbors, fls.elNeighbors), 2) ...
                / (size(fls.gtlNeighbors, 2)));
        end
    end
end

