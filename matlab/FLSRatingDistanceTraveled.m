classdef FLSRatingDistanceTraveled < FLSRating
    methods
        function out = getRating(obj, fls)
            out = 1 / fls.distanceTraveled;
        end
    end
end

