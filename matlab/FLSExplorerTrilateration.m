classdef FLSExplorerTrilateration < FLSExplorer
    methods
        function obj = FLSExplorerTrilateration(freezePolicy)
            obj.freezePolicy = freezePolicy;
        end

        function init(obj, fls)
            obj.wayPoints = [];
            obj.neighbor = 0;
            obj.scores = [];

            obj.i = 0;
            obj.bestIndex = 0;

            i = randperm(size(fls.gtlNeighbors, 2));

            n1 = fls.gtlNeighbors(i(1));
            n2 = fls.gtlNeighbors(i(2));
            d1 = norm(n1.gtl - fls.gtl);
            d2 = norm(n2.gtl - fls.gtl);

%             [o1, o2] = CircleIntersection(n1.el(1,1), n1.el(2,1), d1, n2.el(1,1), n2.el(2,1), d2);

            [xout,yout] = circcirc(n1.el(1,1), n1.el(2,1), d1, n2.el(1,1), n2.el(2,1), d2);

            out1 = [xout(1); yout(1)];
            out2 = [xout(2); yout(2)];

            if isnan(out1(1,1))
                obj.wayPoints(:,1) = fls.el;
                return
            end
            if size(fls.gtlNeighbors, 2) == 2
                if norm(fls.gtl - out1) < norm(fls.gtl - out2)
                    obj.wayPoints(:,1) = out1;
                else
                    obj.wayPoints(:,1) = out2;
                end
            else
                n3 = fls.gtlNeighbors(i(3));
                d3 = norm(n3.gtl - fls.gtl);

                dout1 = norm(out1 - n3.el);
                dout2 = norm(out2 - n3.el);
    
                if abs(dout1 - d3) < abs(dout2 - d3)
                    obj.wayPoints(:,1) = out1;
                else
                    obj.wayPoints(:,1) = out2;
                end
            end
        end
    end
end

