classdef FLSRatingMaxR < FLSRating
    methods        
        function out = getRating(obj, fls)
            out = 1;
            n = size(fls.elNeighbors, 2);

            if n == 0
                return;
            end

%             elDistance = [fls.elNeighbors.el] - fls.el;
            gtlDistance = [fls.elNeighbors.gtl] - fls.gtl;
            
            for i = 1:n
%                 if norm(elDistance(:,i)) > fls.communicationRange
%                     R = Inf;
%                 else
                    R = fls.r;
                out = out - min(1/n,  R / norm(gtlDistance(:,i)));
            end
        end
    end
end

