function [p, t] = getVectorAngleX(a, b)
    maxE = 2 * pi / 180;

    pe = 0;
    te = 0;

    load('config.mat', 'addAngleError');

    if addAngleError
        pe = (2 * rand(1) - 1) * maxE;
        te = (2 * rand(1) - 1) * maxE;
    end

    if size(a, 1) == 2
        a = [a; 0];
        b = [b; 0];
    end

    v = b - a;

    x = [1; 0; 0];
    z = [0; 0; 1];

    t = atan2(norm(cross(z,v)), dot(z,v)) + te;

    v(3) = 0;
    p = cross(x, v);
    p = sign(dot(p,z)) * norm(p);
    p = atan2(p,dot(v,x)) + pe;
end
