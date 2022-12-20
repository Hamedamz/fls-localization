classdef FLSExplorer < handle
    properties
        wayPoints = []
        scores = []
        neighbor = 0
        bestIndex = 0
        i = 0
        freezePolicy
        lastConf = 0
        histNeighbors = []
        d0 = 0
        d1 = 0 
        d2 = 0
    end

    properties (Dependent)
        isFinished
    end
    
    methods (Abstract)
        init(obj, fls)
    end

    methods
        function step(obj)
            obj.i = obj.i + 1;
            obj.bestIndex = obj.i;
        end

        function success = finalize(obj, fls)
            k = obj.bestIndex;

            if k > size(obj.wayPoints, 2) || k < 1
                fls.freeze = 1;
                success = 0;
                return;
            end

            dest = obj.wayPoints(:,k);
            
            d = norm(dest - fls.el);
            
%             if d < 0.1
%                 if obj.freezePolicy == 3 || obj.freezePolicy == 2
%                     fls.freeze = 1;
%                     obj.histNeighbors = [obj.histNeighbors obj.neighbor];
%                 end
%                 success = 0;
%                 return;
%             end

            obj.lastConf = fls.confidence;

            if fls.physical
%                 fls.flyTo(fls.el + obj.d1);
%                 fls.flyTo(fls.el + obj.d2);
                v = dest - fls.el;
                fls.swarm.enabled = 0;
                fls.el = fls.el + obj.d1;
                fls.flyTo(fls.el + obj.d2);
                fls.swarm.enabled = 1;
                fls.swarm.follow(fls, v);
            else
                fls.flyTo(dest);
            end
            

            fls.d0 = fls.d0 + norm(obj.d0);
            fls.d1 = fls.d1 + norm(obj.d1);
            fls.d2 = fls.d2 + norm(obj.d2);

            if obj.neighbor ~= 0
                fls.swarm.addMember(obj.neighbor);
                obj.neighbor.swarm.addMember(fls);

                if fls.confidence <= obj.lastConf
                    obj.histNeighbors = [obj.histNeighbors obj.neighbor];
                end
            end

            if obj.freezePolicy == 2
                fls.freeze = 1;
            end

            success = 1;
        end

        function out = get.isFinished(obj)
            out = obj.i >= size(obj.wayPoints, 2) && obj.i;
        end
    end
end

