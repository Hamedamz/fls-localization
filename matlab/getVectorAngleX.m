function a = getVectorAngleX(coord1, coord2)
    v = coord2 - coord1;
    a = atan2(v(2), v(1));
end
