classdef FLS < handle
    properties
        id
        el
        gtl

        r
        alpha
        speed = 1
        communicationRange = 1.85
        crm
        fixN
        distanceTraveled = 0
        lastD = 0

        confidenceModel
        weightModel
        distModel
        explorer
        swarm
        screen
        celNeighbors = []
        cgtlNeighbors = []

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
        function obj = FLS(el, gtl, alpha, weightModel, confidenceModel, distModel, explorer, swarm, crm, fixN, screen)
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
            obj.crm = crm;
            obj.fixN = fixN;
        end

        function ve = addErrorToVector(obj, v)
            if obj.alpha == 0
                ve = v;
                return;
            end

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

%                 phi = rand(1) * 2 * pi;
                phi = 0;
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
            if obj.fixN
                out = obj.celNeighbors;
                return;
            end

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
            if size(obj.cgtlNeighbors, 2)
                out = obj.cgtlNeighbors;
                return;
            end

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
            obj.cgtlNeighbors = N;
        end

        function computeNeighbors(obj, allflss)
            n = size(obj.celNeighbors, 2);
            m = obj.fixN - n;

            if m > 0
                B = [obj obj.celNeighbors];
                flss = allflss(~ismember(allflss, B));

                N1 = [];
                N2 = [];
                N3 = [];
                N4 = [];
                for i = 1:size(flss,2)
                    d = norm(flss(i).el - obj.el);
                    if d < 2.5
                        N1 = [N1 flss(i)];
                    elseif d < 5
                        N2 = [N2 flss(i)];
                    elseif d < 10
                        N3 = [N3 flss(i)];
                    else
                        N4 = [N4 flss(i)];
                    end
                    if size(N1,2) == m
                        N = N1;
                        break;
                    end
                end

                allN = [N1 N2 N3 N4];
                N = allN(1:m);

%                 k = randperm(size(flss,2), m);
%                 N = flss(k);

                obj.celNeighbors = [obj.celNeighbors N];

                for i=1:size(N,2)
                    if ~any(ismember(N(i).celNeighbors, obj))
                       N(i).celNeighbors = [N(i).celNeighbors obj]; 
                    end
                end
            end
        end

        function adjustCR(obj)
            minD = Inf;
            flss = obj.screen.values();
            for i = 1:size(flss,2)
                if (flss{i}.id == obj.id)
                    continue;
                end
                d = obj.distModel.getDistance(obj, flss{i});
                if d < minD
                    minD = d;
                end
            end
            obj.communicationRange = minD * obj.crm;
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