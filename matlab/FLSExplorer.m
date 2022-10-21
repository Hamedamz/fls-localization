classdef FLSExplorer < handle
    properties
        wayPoints = []
        scores = []
        bestIndex = 0
        bestScore = 0
        i = 0
    end

    properties (Dependent)
        isFinished
    end
    
    methods (Abstract)
        init(obj, fls)
        step(obj, fls)
        finalize(obj)
    end

    methods
        function out = get.isFinished(obj)
            out = obj.i >= size(obj.wayPoints, 2) && obj.i;
        end
    end
end

