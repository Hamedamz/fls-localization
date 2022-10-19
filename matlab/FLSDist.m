classdef FLSDist < handle
    methods (Abstract)
        getDistance(obj, ss)
        getSignalStrength(obj, d)
    end
end
