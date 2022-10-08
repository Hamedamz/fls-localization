classdef Consts
    properties (Constant)
        dv2 = [-1 0 1 1 1 0 -1 -1; -1 -1 -1 0 1 1 1 0]
        dc2 = [
            0 0 cosd(45) 1 cosd(45) 0 -cosd(45) -1 -cosd(45);
            0 1 sind(45) 0 -sind(45) -1 -sind(45) 0 sind(45)
            ]
        dv3 = []
    end
end

