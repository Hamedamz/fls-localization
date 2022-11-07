classdef FLSExplorerDistAngle < FLSExplorer
    methods
        function obj = FLSExplorerDistAngle(freezePolicy)
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
                fprintf("ERROR distangle failed %s: no neighbors\n", fls.id);
                success = 0;
                return;
            end

            N = getMostConfident(fls.elNeighbors);

%             rp = randperm(n);
%             rp = rp(1);
%             N = fls.gtlNeighbors(rp);

            [phi, theta] = getVectorAngleX(N.el, fls.el);

            d = fls.distModel.getDistance(fls, N);
            D = fls.gtl - N.gtl;

            if fls.D == 3
                dv = [d * sin(theta) * cos(phi); d * sin(theta) * sin(phi); d * cos(theta)];
            else
                dv = [d * cos(phi); d * sin(phi)];
            end

            V = D - dv;
            P = fls.el + V;

            scatter(N.el(1), N.el(2), 'filled', 'blue')
            scatter(fls.el(1), fls.el(2), 'filled', 'green')
            scatter(P(1), P(2), 'green')

            obj.wayPoints(:,1) = P;
            obj.neighbor = N;
            success = 1;
        end
    end
end

