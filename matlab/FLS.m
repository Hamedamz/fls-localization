classdef FLS
    properties
        id
        el
        gtl
        elNeighbors
        gtlNeighbors
        distanceTraveled
        confidenceFunction
    end

    properties (Dependent)
        confidence
        expectedNeighbors
        unexpectedNeighbors
    end

    methods
        function obj = FLS(el, gtl, confidenceFuntion)
            obj.id = coordToId(gtl);
            obj.el = el;
            obj.gtl = gtl;
            obj.confidenceFunction = confidenceFuntion;
        end

        function obj = flyTo(coord)
            travelVector = coord - obj.el;
            obj.distanceTraveled = obj.distanceTraveled + norm(travelVector);
            e = [0 0 0];
            obj.el = coord + e;
        end

        function obj = computeElNeighbors(screen)
            obj.elNeighbors = [];
        end

        function obj = computeGtlNeighbors(screen)
            obj.gtlNeighbors = [];
        end

        function conf = get.confidence(obj)
            conf = obj.confidenceFunction(obj);
        end
    end
end