classdef FLSRatingNeighbors < FLSRating
    properties
        a
        b
    end
    methods
        function obj = FLSRatingNeighbors(a, b)
            obj.a = a;
            obj.b = b;
        end
        function out = getRating(obj, fls)
            out = 1 - ( ...
                (obj.a * size(fls.missingNeighbors, 2) ...
                + obj.b * size(fls.erroneousNeighbors, 2)) ...
                / (size(fls.el, 1) ^ 2 - 1));
        end
    end
end

