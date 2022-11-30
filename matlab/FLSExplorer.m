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
            
            fls.flyTo(dest);

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

