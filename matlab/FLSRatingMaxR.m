classdef FLSRatingMaxR < FLSRating
    methods        
        function out = getRating(obj, fls)
            out = 1;
            n = size(fls.gtlNeighbors, 2);

            if n == 0
                return;
            end

            elDistance = [fls.gtlNeighbors.el] - fls.el;
            gtlDistance = [fls.gtlNeighbors.gtl] - fls.gtl;
            
            for i = 1:n
                if norm(elDistance(:,i)) > fls.communicationRange
                    R = Inf;
                else
                    R = fls.r;
                end
                out = out - min(1/n,  R / norm(gtlDistance(:,i)));
            end
        end
    end
end

