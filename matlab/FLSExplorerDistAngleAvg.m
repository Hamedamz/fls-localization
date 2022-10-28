classdef FLSExplorerDistAngleAvg < FLSExplorer
    methods
        function init(obj, fls)
            obj.wayPoints = [];
            obj.eWayPoints = [];
            obj.scores = [];

            obj.i = 0;
            obj.bestScore = -Inf;
            obj.bestIndex = 0;

            n = size(fls.elNeighbors, 2);
            if n < 1
                fprintf("FLS %s has no neighbors\n", fls.id);
                return;
            end

            obj.wayPoints(:,1) = zeros(size(fls.el));
            for i = 1:n
                N = fls.elNeighbors(i);
                [phi, theta] = getVectorAngleX(N.el, fls.el);

                d = fls.distModel.getDistance(fls, N);
                D = fls.gtl - N.gtl;
    
                if fls.D == 3
                    dv = [d * sin(theta) * cos(phi); d * sin(theta) * sin(phi); d * cos(theta)];
                else
                    dv = [d * cos(phi); d * sin(phi)];
                end
    
                V = D - dv;
                R = fls.el + V;
    
                scatter(N.el(1), N.el(2), 'filled', 'blue')
                scatter(fls.el(1), fls.el(2), 'filled', 'green')
    
                obj.wayPoints(:,1) = obj.wayPoints(:,1) + R;
            end
            obj.wayPoints(:,1) = obj.wayPoints(:,1) / n;
        end

        function d = step(obj, fls)
            obj.i = obj.i + 1;

            if obj.i > size(obj.wayPoints, 2)
                fls.freeze = 1;
                d = 0;
                return;
            end
            
            d = norm(obj.wayPoints(:,obj.i) - fls.el);

            if d == 0
                fls.freeze = 1;
                d = 0;
                return;
            end

            el = fls.flyTo(obj.wayPoints(:,obj.i));
            obj.eWayPoints(:,obj.i) = el;
            newScore = fls.weight;
            obj.scores(obj.i) = newScore;
            scatter(el(1), el(2), 'green')

            
            if newScore > obj.bestScore
                obj.bestScore = newScore;
                obj.bestIndex = obj.i;
            end
        end

        function bestCoord = finalize(obj)
            if obj.bestIndex > 0
                bestCoord = obj.eWayPoints(:,obj.bestIndex);
            else
                bestCoord = nan;
            end
        end
    end
end

