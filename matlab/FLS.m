classdef FLS < handle
    properties
        id
        el
        gtl

        r
        alpha = .05
        communicationRange = 1.5
        distanceTraveled = 0

        confidenceModel
        weightModel
        explorer
        screen
    end

    properties (Dependent)
        elNeighbors
        gtlNeighbors
        missingNeighbors
        erroneousNeighbors

        confidence
        weight

        isExplorationFinished
    end

    methods
        function obj = FLS(el, gtl, weightModel, confidenceModel, explorer, screen)
            obj.id = coordToId(gtl);
            obj.el = el;
            obj.gtl = gtl;
            obj.weightModel = weightModel;
            obj.confidenceModel = confidenceModel;
            obj.explorer = explorer;
            obj.screen = screen;
        end

        function flyTo(obj, coord)
            v = coord - obj.el;
            d = norm(v);
            obj.r = d * tan(obj.alpha);
            theta = 2 * obj.alpha * rand(1) - obj.alpha;

            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            vR = R * v;

            obj.distanceTraveled = obj.distanceTraveled + d;
            obj.el = vR;
        end



        function out = get.elNeighbors(obj)
            N = [];
            flss = obj.screen.values();
            for i = 1:size(obj.screen, 1)
                if flss{i}.id == obj.id
                    continue;
                end

                d = norm(flss{i}.el - obj.el);
                if d <= obj.communicationRange
                    N = [N flss{i}];
                end
            end
            out = N;
        end

        function out = get.gtlNeighbors(obj)
            N = [];
            for i = 1:size(Consts.dv2, 2)
                nId = coordToId(obj.gtl + Consts.dv2(:,i));

                if isKey(obj.screen, nId)
                    N = [N obj.screen(nId)];
                end
            end
            out = N;
        end

        function computeNeighbors(obj, screen)
            obj.computeGtlNeighbors(screen);
            obj.computeElNeighbors(screen);            
        end



        function initializeExplorer(obj)
            obj.explorer.init(obj);
        end

        function exploreOneStep(obj)
            obj.explorer.step(obj);
        end

        function finalizeExploration(obj)
            bestCoord = obj.explorer.finalize();
            obj.el = bestCoord;
        end



        function A = get.erroneousNeighbors(obj)
            A = setdiff(obj.elNeighbors, obj.gtlNeighbors);
        end

        function A = get.missingNeighbors(obj)
            A = setdiff(obj.gtlNeighbors, obj.elNeighbors);
        end

        function out = get.confidence(obj)
            out = obj.confidenceModel.getRating(obj);
        end

        function out = get.weight(obj)
            out = obj.weightModel.getRating(obj);
        end
    end
end