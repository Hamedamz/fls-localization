classdef FLSExplorerBasic < FLSExplorer
    properties
        r
    end
    
    methods
        function obj = FLSExplorerBasic(r)
            obj.r = r;
        end
        
        function init(obj, fls)
            obj.wayPoints = zeros(size(Consts.dc2));
            obj.scores = zeros(size(Consts.dc2, 2));

            for i = 1:size(Consts.dc2, 2)
                obj.wayPoints(:,i) = (fls.el + Consts.dc2(:,i) * obj.r);
            end

            obj.i = 0;
            obj.bestScore = -Inf;
            obj.bestIndex = 0;

        end

        function step(obj, fls)
            obj.i = obj.i + 1;

            fls.el = obj.wayPoints(:,obj.i);
            newScore = fls.weight;
            obj.scores(obj.i) = newScore;
            %sprintf('weight: %f', fls.weight)
            %sprintf('point: %f %f', fls.el)

            
            if newScore > obj.bestScore
                %disp(obj.i)
                obj.bestScore = newScore;
                obj.bestIndex = obj.i;
            end
        end

        function bestCoord = finalize(obj)
            bestCoord = obj.wayPoints(:,obj.bestIndex);
            %disp(bestCoord);
        end
    end
end

