classdef FLSExplorerTriangulation < FLSExplorer
    methods
        function init(obj, fls)
            obj.wayPoints = [];
            obj.scores = [];

            obj.i = 0;
            obj.bestScore = -Inf;
            obj.bestIndex = 0;

            if size(fls.gtlNeighbors, 2) < 3
                disp("not enough neighbors");
                obj.wayPoints(:,1) = fls.el;
                return;
            end

            randi = randperm(size(fls.gtlNeighbors, 2));

            for i = 1:size(randi, 2)
                flag = 0;
                n = [fls.gtlNeighbors(randi(1:3)).el];
                g = [fls.gtlNeighbors(randi(1:3)).gtl];

                for j = 1:3
                    [xn2,yn2] = poly2ccw(n(1,:), n(2,:));
                    [xg2,yg2] = poly2ccw(g(1,:), g(2,:));
        
                    n = [xn2; yn2];
                    g = [xg2; yg2];
        
                    a1 = getVectorAngleX(fls.gtl, g(:,1));
                    a2 = getVectorAngleX(fls.gtl, g(:,2));
                    a3 = getVectorAngleX(fls.gtl, g(:,3));
        
                    alpha = a2 - a1;
                    betha = a3 - a1;
        
                    if alpha < pi && betha < pi
                        alpha = a2 - a1;
                        betha = a3 - a2;
                        if sin(alpha) == 0 || sin(betha) == 0 || sin(alpha) < 0 || sin(betha) < 0
                            continue;
                        end
                        flag = 1;
                        break;
                    end
                    n = circshift(n, 1);
                    g = circshift(g, 1);
                end

                if flag
                    break;
                end

                randi = circshift(randi, 1);
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

            if ra < 0 || rb < 0
                obj.wayPoints(:,1) = fls.el;
                return;
            end
%             if fls.id == "5.5"
            
            rectangle('Position',[ca.' - [ra ra] 2*[ra ra]],'Curvature',[1 1])
            rectangle('Position',[cb.' - [rb rb] 2*[rb rb]],'Curvature',[1 1])
%             scatter(ca(1), ca(2))
%             scatter(cb(1), cb(2))
%             end

            % return error if the centers of the two circles are too close

            cba = (ca - cb) / norm(ca - cb);
            gamma = acos(dot(n2 - cb, cba) / rb);

            % if gamma is very large, then return an error
            
            d2r = 2 * rb * sin(gamma);
            c2m = rb * cos(gamma);
            m = cb + c2m * cba;
            R = 2 * m - n2;
            disp(fls.id)
            disp(R)
            scatter(R(1), R(2))

            obj.wayPoints(:,1) = R;
                
        end

        function d = step(obj, fls)
            obj.i = obj.i + 1;
            d = norm(obj.wayPoints(:,obj.i) - fls.el);

            if d > fls.r*2 || d == 0
                fls.freeze = 1;
                d = 0;
                return;
            end

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
            if obj.bestIndex > 0
                bestCoord = obj.wayPoints(:,obj.bestIndex);
            else
                bestCoord = nan;
            end
            %disp(bestCoord);
        end
    end
end

