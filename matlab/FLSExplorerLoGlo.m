classdef FLSExplorerLoGlo < FLSExplorer
    methods
        function obj = FLSExplorerLoGlo(freezePolicy)
            obj.freezePolicy = freezePolicy;
        end

        function init(obj, fls)
            obj.wayPoints = [];
            obj.neighbor = 0;
            obj.scores = [];

            obj.i = 0;
            obj.bestIndex = 0;

            if size(fls.gtlNeighbors, 2) < 3
                fprintf("FLS %s has less that 3 neighbors\n", fls.id);
                return;
            end

            [R, n1, n2, n3, ca, cb, ra, rb, success] = solveTriangulation(fls, fls.gtlNeighbors);

            if success
                scatter(n1(1), n1(2), 'filled', 'blue')
                scatter(n2(1), n2(2), 'filled', 'blue')
                scatter(n3(1), n3(2), 'filled', 'blue')
                scatter(fls.el(1), fls.el(2), 'filled', 'green')
                scatter(R(1), R(2), 'green')
                rectangle('Position',[ca.' - [ra ra] 2*[ra ra]],'Curvature',[1 1]);
                rectangle('Position',[cb.' - [rb rb] 2*[rb rb]],'Curvature',[1 1]);
    
                obj.wayPoints(:,1) = R;
            else
                fprintf("FLS %s faild to solve local triangulation\n", fls.id);
                return;
            end

            flsCenter = FLS([0; 0], [0; 0], nan, nan, nan, nan, nan);
            flsA = FLS([10; 5], [10; 5], nan, nan, nan, nan, nan);
            flsB = FLS([20; 30], [20; 30], nan, nan, nan, nan, nan);
            [R, n1, n2, n3, ca, cb, ra, rb, success] = solveTriangulation(fls, [flsCenter flsA flsB]);

            if success
                scatter(n1(1), n1(2), 'filled', 'blue')
                scatter(n2(1), n2(2), 'filled', 'blue')
                scatter(n3(1), n3(2), 'filled', 'blue')
                scatter(fls.el(1), fls.el(2), 'filled', 'green')
                scatter(R(1), R(2), 'green')
                rectangle('Position',[ca.' - [ra ra] 2*[ra ra]],'Curvature',[1 1]);
                rectangle('Position',[cb.' - [rb rb] 2*[rb rb]],'Curvature',[1 1]);
    
                obj.wayPoints(:,2) = R;
            else
                fprintf("FLS %s faild to solve global triangulation\n", fls.id);
                return;
            end
                
        end
    end
end

