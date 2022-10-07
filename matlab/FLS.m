classdef FLS < handle
    properties
        id
        el
        gtl
        r
        alpha = .05
        range = 1
        elNeighbors = {}
        gtlNeighbors = {}
        distanceTraveled = 0
        confidenceFunction
    end

    properties (Dependent)
        confidence
        missingNeighbors
        erroneousNeighbors
    end

    methods
        function obj = FLS(el, gtl, confidenceFuntion)
            obj.id = coordToId(gtl);
            obj.el = el;
            obj.gtl = gtl;
            obj.confidenceFunction = confidenceFuntion;
        end

        function flyTo(obj, coord)
            v = coord - obj.el;
            d = norm(v);
            obj.r = d * tan(obj.alpha);
            theta = 2 * obj.alpha * rand(1) - obj.alpha;

            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            vR = v * R;

            obj.distanceTraveled = obj.distanceTraveled + d;
            obj.el = vR;
        end

        function computeElNeighbors(obj, screen)
            N = [];
            flss = screen.values();
            for i = 1:size(screen, 1)
                d = norm(flss{i}.el - obj.el);
                if d <= obj.range
                    N = [N coordToId(flss{i}.gtl)];
                end
            end
            obj.elNeighbors = N;
        end

        function computeGtlNeighbors(obj, screen)
            N = [];
            for i = 1:size(Consts.dv2, 2)
                id = coordToId(obj.gtl + Consts.dv2(:,i).');

                if isKey(screen, id)
                    N = [N id];
                end
            end
            obj.gtlNeighbors = N;
        end

        function A = get.erroneousNeighbors(obj)
            A = setdiff(obj.elNeighbors, obj.gtlNeighbors);
        end

        function A = get.missingNeighbors(obj)
            A = setdiff(obj.gtlNeighbors, obj.elNeighbors);
        end

        function conf = get.confidence(obj)
            conf = obj.confidenceFunction(obj);
        end
    end
end