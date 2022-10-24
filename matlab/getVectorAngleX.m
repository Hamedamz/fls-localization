function [p, t] = getVectorAngleX(a, b)
    if size(a, 1) == 2
        a = [a; 0];
        b = [b; 0];
    end

    v = b - a;

    x = [1; 0; 0];
    z = [0; 0; 1];

    t = atan2(norm(cross(z,v)), dot(z,v));

    v(3) = 0;
    p = cross(x, v);
    p = sign(dot(p,z)) * norm(p);
    p = atan2(p,dot(v,x));
end
