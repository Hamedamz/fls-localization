classdef FLS < handle
    properties
        id
        el
        gtl

        r
        alpha = 3 / 180 * pi
        speed = 1
        communicationRange = 2
        distanceTraveled = 0
        distanceExplored = 0

        confidenceModel
        weightModel
        distModel
        explorer
        screen

        freeze = 0
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
        function obj = FLS(el, gtl, weightModel, confidenceModel, distModel, explorer, screen)
            obj.id = coordToId(gtl);
            obj.el = el;
            obj.gtl = gtl;
            obj.weightModel = weightModel;
            obj.confidenceModel = confidenceModel;
            obj.distModel = distModel;
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
            d = floor(obj.communicationRange);
            for i = -d:d
                for j = -d:d
                    if i == 0 && j == 0
                        continue;
                    end

                    nId = coordToId(obj.gtl + [i; j]);
                    
                    if isKey(obj.screen, nId)
                        N = [N obj.screen(nId)];
                    end
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
            d = obj.explorer.step(obj);
            obj.distanceExplored = obj.distanceExplored + d;
        end

        function m = finalizeExploration(obj)
            bestCoord = obj.explorer.finalize();
            if isnan(bestCoord)
                m = 0;
                return;
            end
            d = norm(bestCoord - obj.el);
            obj.distanceExplored = obj.distanceExplored + d;
            obj.el = bestCoord;
            obj.freeze = 1;
            m = 1;
        end



        function A = get.erroneousNeighbors(obj)
            A = setdiff(obj.elNeighbors, obj.gtlNeighbors);
        end

        function A = get.missingNeighbors(obj)
            A = setdiff(obj.gtlNeighbors, obj.elNeighbors);
        end

        function out = get.confidence(obj)
            if obj.freeze
                out = 1.0;
            else
                out = obj.confidenceModel.getRating(obj);
            end
        end

        function out = get.weight(obj)
            out = obj.weightModel.getRating(obj);
        end
    end
end