classdef FLSWeightBasic < FLSWeight
    methods        
        function out = getWeight(obj, fls)
            elDistance = [fls.gtlNeighbors.el] - fls.el;
            gtlDistance = [fls.gtlNeighbors.gtl] - fls.gtl;

            out = 0;
            for i = 1:size(fls.gtlNeighbors, 2)
                out = out + abs(norm(elDistance(:,1)) - norm(gtlDistance(:,1)));
            end
        end
    end
end

