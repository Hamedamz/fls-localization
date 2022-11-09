classdef FLSExplorerTrilateration < FLSExplorer
    methods
        function obj = FLSExplorerTrilateration(freezePolicy)
            obj.freezePolicy = freezePolicy;
        end

        function success = init(obj, fls)
            obj.wayPoints = [];
            obj.neighbor = 0;
            obj.scores = [];

            obj.i = 0;
            obj.bestIndex = 0;

            N = fls.elNeighbors;
            n = size(N, 2);

            if n < 3
                success = 0;
                fprintf('ERROR trilateration failed %s: less than 3 neighbors\n', fls.id);
                return;
            end

            p = randperm(n);
            ncomb = nchoosek(p,3);
            scatter(fls.el(1), fls.el(2), 'filled', 'green')

            solved = 0;
            for i = 1:size(ncomb, 1)
                k = ncomb(i,:);
                for j = 1:3
                    
                    n1 = N(k(mod(j, 3)+1));
                    n2 = N(k(mod(j+1, 3)+1));
                    n3 = N(k(mod(j+2, 3)+1));

                    d1 = norm(n1.gtl - fls.gtl);
                    d2 = norm(n2.gtl - fls.gtl);
                    d3 = norm(n3.gtl - fls.gtl);

                    scatter(n1.el(1), n1.el(2), 'filled', 'blue')
                    scatter(n2.el(1), n2.el(2), 'filled', 'blue')
                    scatter(n3.el(1), n3.el(2), 'filled', 'blue')
                    
                    rectangle('Position',[n1.el.' - [d1 d1] 2*[d1 d1]],'Curvature',[1 1]);
                    rectangle('Position',[n2.el.' - [d2 d2] 2*[d2 d2]],'Curvature',[1 1]);

                    [xout,yout] = circcirc(n1.el(1,1), n1.el(2,1), d1, n2.el(1,1), n2.el(2,1), d2);

                    out1 = [xout(1); yout(1)];
                    out2 = [xout(2); yout(2)];

                    if isnan(out1(1,1)) || ~isreal(out1(1,1))
                        continue;
                    end
    
                    dout1 = norm(out1 - n3.el);
                    dout2 = norm(out2 - n3.el);
        
                    if abs(dout1 - d3) < abs(dout2 - d3)
                        obj.wayPoints(:,1) = out1;
                        scatter(out1(1), out1(2), 'green')
                    else
                        obj.wayPoints(:,1) = out2;
                        scatter(out2(1), out2(2), 'green')
                    end

                    solved = 1;
                    break;
                end

                if solved
                    break;
                end
            end

            if solved
                success = 1;
            else
                success = -1;
                fprintf('ERROR trilateration failed %s: circles do not intersect\n', fls.id);
            end
        end
    end
end

