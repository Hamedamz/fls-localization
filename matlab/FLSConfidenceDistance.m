classdef FLSConfidenceDistance < FLSConfidence
    methods
        function out = getConfidence(obj, fls)
            out = 1 / fls.distanceTraveled;
        end
    end
end

