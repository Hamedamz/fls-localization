classdef FLSExplorerDistAngle < FLSExplorer
    methods
        function init(obj, fls)
            obj.wayPoints = [];
            obj.scores = [];

            obj.i = 0;
            obj.bestScore = -Inf;
            obj.bestIndex = 0;

            n = size(fls.gtlNeighbors, 2);
            if n < 1
                fprintf("FLS %s has no neighbors\n", fls.id);
                return;
            end

            maxConf = -inf;
            for i = 1:n
                conf = fls.gtlNeighbors(i).confidence;
                if conf > maxConf
                    maxConf = conf;
                    N = fls.gtlNeighbors(i);
                end
            end
%             rp = randperm(n);
%             rp = rp(1);
%             N = fls.gtlNeighbors(rp);

            [phi, theta] = getVectorAngleX(N.el, fls.el);

            d = norm(fls.el - N.el);
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
            scatter(R(1), R(2), 'green')

            obj.wayPoints(:,1) = R;
                
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

            fls.el = obj.wayPoints(:,obj.i);
            newScore = fls.weight;
            obj.scores(obj.i) = newScore;
            
            if newScore > obj.bestScore
                obj.bestScore = newScore;
                obj.bestIndex = obj.i;
            end
        end

        function bestCoord = finalize(obj)
            if obj.bestIndex > 0
                bestCoord = obj.wayPoints(:,obj.bestIndex);
            else
                bestCoord = nan;
            end
        end
    end
end

