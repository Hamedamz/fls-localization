classdef FLSExplorerDistAngleOld < FLSExplorer
    methods
        function obj = FLSExplorerDistAngleOld(freezePolicy)
            obj.freezePolicy = freezePolicy;
        end

        function init(obj, fls)
            obj.wayPoints = [];
            obj.neighbor = 0;
            obj.scores = [];

            obj.i = 0;
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

            A = getVectorAngleX(fls.gtl, N.gtl);
            alpha = getVectorAngleX(fls.el, N.el);

            D = norm(fls.gtl - N.gtl);
            d = norm(fls.el - N.el);


            a = abs(alpha - A);
            v = sqrt(d^2 + D^2 - 2*d*D*cos(a));

            if v == 0
                return;
            end
            
            if D < d
                beta = asin(D*sin(a)/v);
            else
                gama = asin(d*sin(a)/v);
                beta = pi - gama - a;
            end

            if alpha > A
                theta = alpha + beta;
            else
                theta = alpha - beta;
            end

            V = [v*cos(theta); v*sin(theta)];
            R = fls.el + V;

            scatter(N.el(1), N.el(2), 'filled', 'blue')
            scatter(fls.el(1), fls.el(2), 'filled', 'green')
            scatter(R(1), R(2), 'green')

            obj.wayPoints(:,1) = R;
            obj.neighbor = N;
                
        end
    end
end

