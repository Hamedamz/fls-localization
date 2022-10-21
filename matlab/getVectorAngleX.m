function a = getVectorAngleX(coord1, coord2)
    v = coord2 - coord1;
    a = atan2(v(2), v(1));
    if a < 0
        a = 2*pi+a;
    end
end
