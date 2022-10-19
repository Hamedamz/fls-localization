classdef FLSDistSquareRoot < FLSDist
    methods
        function d = getDistance(obj, fls1, fls2)
            d = sgrt(1 / obg.getSignalStrength(fls1, fls2));
        end
        
        function ss = getSignalStrength(obj, fls1, fls2)
            ss = 1 / (norm(fls1.el - fls2.el) ^ 2);
        end
    end
end
