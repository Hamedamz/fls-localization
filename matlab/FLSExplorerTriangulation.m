classdef FLSExplorerTriangulation < FLSExplorer
    methods
        function init(obj, fls)
            obj.wayPoints = [];
            obj.scores = [];

            obj.i = 0;
            obj.bestScore = -Inf;
            obj.bestIndex = 0;

            if size(fls.gtlNeighbors, 2) < 3
                fprintf("FLS %s has less that 3 neighbors\n", fls.id);
                return;
            end

            randi = randperm(size(fls.gtlNeighbors, 2));

            for i = 1:size(randi, 2)
                orderFound = 0;
                els = [fls.gtlNeighbors(randi(1:3)).el];
                gtls = [fls.gtlNeighbors(randi(1:3)).gtl];

                [xn,yn] = poly2ccw(els(1,:), els(2,:));
                [xg,yg] = poly2ccw(gtls(1,:), gtls(2,:));
        
                n = [xn; yn];
                g = [xg; yg];

                for j = 1:3
                    a1 = getVectorAngleX(fls.gtl, g(:,1));
                    a2 = getVectorAngleX(fls.gtl, g(:,2));
                    a3 = getVectorAngleX(fls.gtl, g(:,3));
        
                    alpha = a2 - a1;
                    betha = a3 - a2;
        
                    if alpha < pi && betha < pi && alpha > 0 && betha > 0 && sin(alpha) ~= 0 && sin(betha) ~= 0
                        orderFound = 1;
                        break;
                    end
                    n = circshift(n, 1, 2);
                    g = circshift(g, 1, 2);
                end

                if orderFound
                    break;
                end

                randi = circshift(randi, 1);
            end

            if ~orderFound
                fprintf("FLS %s faild to triangulate\n", fls.id);
                return;
            end

            n1 = n(:,1);
            n2 = n(:,2);
            n3 = n(:,3);

            alpha = a2 - a1;
            betha = a3 - a2;
            
            d12 = norm(n1 - n2);
            d23 = norm(n2 - n3);
            p12 = (n1 + n2) / 2;
            p23 = (n2 + n3) / 2;
            ra = d12 / (2 * sin(alpha));
            rb = d23 / (2 * sin(betha));
            la = d12 / (2 * tan(alpha));
            lb = d23 / (2 * tan(betha));
            v12 = (n2 - n1) / d12;
            v23 = (n3 - n2) / d23;
            ca = [p12(1) - la * v12(2); p12(2) + la * v12(1)];
            cb = [p23(1) - lb * v23(2); p23(2) + lb * v23(1)];

            % return error if the centers of the two circles are too close

            cba = (ca - cb) / norm(ca - cb);
            gamma = acos(dot(n2 - cb, cba) / rb);

            % if gamma is very large, then return an error
            
            d2r = 2 * rb * sin(gamma);
            c2m = rb * cos(gamma);
            m = cb + c2m * cba;
            R = 2 * m - n2;
            %disp(fls.id)
            %disp(R)
            %figure(3)
            scatter(n1(1), n1(2), 'filled', 'blue')
            scatter(n2(1), n2(2), 'filled', 'blue')
            scatter(n3(1), n3(2), 'filled', 'blue')
            scatter(fls.el(1), fls.el(2), 'filled', 'green')
            scatter(R(1), R(2), 'green')
            rectangle('Position',[ca.' - [ra ra] 2*[ra ra]],'Curvature',[1 1]);
            rectangle('Position',[cb.' - [rb rb] 2*[rb rb]],'Curvature',[1 1]);

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

            if d > fls.r*2 || d == 0
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

