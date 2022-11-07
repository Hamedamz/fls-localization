classdef FLS < handle
    properties
        id
        el
        gtl

        r
        alpha = 3 / 180 * pi
        speed = 1
        communicationRange = 2.5
        distanceTraveled = 0
        lastD = 0

        confidenceModel
        weightModel
        distModel
        explorer
        swarm
        screen

        freeze = 0
        locked = 0
        D
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
        function obj = FLS(el, gtl, alpha, weightModel, confidenceModel, distModel, explorer, swarm, screen)
            obj.id = coordToId(gtl);
            obj.el = el;
            obj.gtl = gtl;
            obj.weightModel = weightModel;
            obj.confidenceModel = confidenceModel;
            obj.distModel = distModel;
            obj.explorer = explorer;
            obj.screen = screen;
            obj.D = size(gtl,1);
            obj.swarm = swarm;
            obj.alpha = alpha / 180 * pi;
        end

        function ve = addErrorToVector(obj, v)
            d = norm(v);
            obj.r = d * tan(obj.alpha);
            
            if obj.D == 3
                i = [v(2); -v(1); 0];
                j = cross(v, i);
                
                ni = norm(i);
                nj = norm(j);

                if ni ~= 0
                    i = i / norm(i);
                end
                if nj ~= 0
                    j = j / norm(j);
                end

                phi = rand(1) * 2 * pi;
                e = i * cos(phi) + j * sin(phi);
                ve = v + e * rand(1) * obj.r;
                nve = norm(ve);

                if nve ~= 0
                    ve = ve / nve;
                end
                ve = ve * d;

            else
                theta = 2 * obj.alpha * rand(1) - obj.alpha;
                R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
                ve = R * v;
            end
        end

        function flyTo(obj, coord)
            if obj.locked 
                obj.lastD = 0;
                return;
            end

            v = coord - obj.el;
            ve = obj.addErrorToVector(v);
            d = norm(ve);
            
            obj.distanceTraveled = obj.distanceTraveled + d;
            obj.el = obj.el + ve;
            obj.lastD = d;

            obj.swarm.follow(obj, v);
        end



        function out = get.elNeighbors(obj)
            N = [];
            flss = obj.screen.values();

            for i = 1:size(flss,2)
                if (flss{i}.id == obj.id)
                    continue;
                end
                d = obj.distModel.getDistance(obj, flss{i});
                if d <= obj.communicationRange
                    N = [N flss{i}];
                end
            end

%             for i = -d:d
%                 for j = -d:d
% 
%                     if obj.D == 3
%                         for k = -d:d
%                             if i == 0 && j == 0 && k == 0
%                                 continue;
%                             end
%         
%                             nId = coordToId(obj.gtl + [i; j; k]);
%                             
%                             if isKey(obj.screen, nId)
%                                 d = norm(obj.screen(nId).el - obj.el);
%                                 if d <= obj.communicationRange
%                                     N = [N obj.screen(nId)];
%                                 end
%                             end
%                         end
%                     else
%                         if i == 0 && j == 0
%                             continue;
%                         end
%     
%                         nId = coordToId(obj.gtl + [i; j]);
%                         
%                         if isKey(obj.screen, nId)
%                             d = norm(obj.screen(nId).el - obj.el);
%                             if d <= obj.communicationRange
%                                 N = [N obj.screen(nId)];
%                             end
%                         end
%                     end
% 
%                 end
%             end

            out = N;
        end

        function out = get.gtlNeighbors(obj)
            N = [];
            d = floor(obj.communicationRange);
            for i = -d:d
                for j = -d:d

                    if obj.D == 3
                        for k = -d:d
                            if i == 0 && j == 0 && k == 0
                                continue;
                            end
        
                            nId = coordToId(obj.gtl + [i; j; k]);
                            
                            if isKey(obj.screen, nId)
                                N = [N obj.screen(nId)];
                            end
                        end
                    else
                        if i == 0 && j == 0
                            continue;
                        end
    
                        nId = coordToId(obj.gtl + [i; j]);
                        
                        if isKey(obj.screen, nId)
                            N = [N obj.screen(nId)];
                        end
                    end

                end
            end

            out = N;
        end

        function computeNeighbors(obj, screen)
            obj.computeGtlNeighbors(screen);
            obj.computeElNeighbors(screen);            
        end



        function success = initializeExplorer(obj)
            success = obj.explorer.init(obj);
        end

        function exploreOneStep(obj)
            obj.explorer.step();
        end

        function success = finalizeExploration(obj)
            success = obj.explorer.finalize(obj);
        end



        function A = get.erroneousNeighbors(obj)
            A = setdiff(obj.elNeighbors, obj.gtlNeighbors);
        end

        function A = get.missingNeighbors(obj)
            A = setdiff(obj.gtlNeighbors, obj.elNeighbors);
        end

        function out = get.confidence(obj)
            if obj.freeze
                out = 1;
            else
                out = obj.confidenceModel.getRating(obj);
            end
        end

        function out = get.weight(obj)
            out = obj.weightModel.getRating(obj);
        end
    end
end