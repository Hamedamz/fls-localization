classdef FLSDistLinear < FLSDist
    methods
        function d = getDistance(obj, fls1, fls2)
            d = obj.getSignalStrength(fls1, fls2);
        end
        
        function ss = getSignalStrength(obj, fls1, fls2)
            ss = norm(fls1.el - fls2.el);
        end
    end
end
