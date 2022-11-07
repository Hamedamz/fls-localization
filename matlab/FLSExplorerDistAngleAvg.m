classdef FLSExplorerDistAngleAvg < FLSExplorer
    methods
        function obj = FLSExplorerDistAngleAvg(freezePolicy)
            obj.freezePolicy = freezePolicy;
        end

        function success = init(obj, fls)
            obj.wayPoints = [];
            obj.neighbor = 0;
            obj.scores = [];

            obj.i = 0;
            obj.bestIndex = 0;

            n = size(fls.elNeighbors, 2);
            if n < 1
                fprintf("FLS %s has no neighbors\n", fls.id);
                success = 0;
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
            success = 1;
        end
    end
end

