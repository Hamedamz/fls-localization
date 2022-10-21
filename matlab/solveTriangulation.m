function [R, n1, n2, n3, ca, cb, ra, rb, success] = solveTriangulation(fls, N)

    randi = randperm(size(N, 2));

    for i = 1:size(randi, 2)
        orderFound = 0;
        els = [N(randi(1:3)).el];
        gtls = [N(randi(1:3)).gtl];

        [xn,yn] = poly2ccw(els(1,:), els(2,:));
        [xg,yg] = poly2ccw(gtls(1,:), gtls(2,:));

        n = [xn; yn];
        g = [xg; yg];

        for j = 1:3
            a1 = getVectorAngleX(fls.gtl, g(:,1));
            a2 = getVectorAngleX(fls.gtl, g(:,2));
            a3 = getVectorAngleX(fls.gtl, g(:,3));

            alpha = a2 - a1;
            betha = a3 - a2;

            if alpha < pi && betha < pi && alpha > 0 && betha > 0 && sin(alpha) ~= 0 && sin(betha) ~= 0
                orderFound = 1;
                break;
            end
            n = circshift(n, 1, 2);
            g = circshift(g, 1, 2);
        end

        if orderFound
            break;
        end

        randi = circshift(randi, 1);
    end

    if ~orderFound
        success = 0;
        R = nan; n1 = nan; n2 = nan; n3 = nan; ca = nan; cb = nan; ra = nan; rb = nan;
        return;
    end

    n1 = n(:,1);
    n2 = n(:,2);
    n3 = n(:,3);

    alpha = a2 - a1;
    betha = a3 - a2;
    
    d12 = norm(n1 - n2);
    d23 = norm(n2 - n3);
    p12 = (n1 + n2) / 2;
    p23 = (n2 + n3) / 2;
    ra = d12 / (2 * sin(alpha));
    rb = d23 / (2 * sin(betha));
    la = d12 / (2 * tan(alpha));
    lb = d23 / (2 * tan(betha));
    v12 = (n2 - n1) / d12;
    v23 = (n3 - n2) / d23;
    ca = [p12(1) - la * v12(2); p12(2) + la * v12(1)];
    cb = [p23(1) - lb * v23(2); p23(2) + lb * v23(1)];

    % return error if the centers of the two circles are too close

    cba = (ca - cb) / norm(ca - cb);
    gamma = acos(dot(n2 - cb, cba) / rb);

    % if gamma is very large, then return an error
    
    d2r = 2 * rb * sin(gamma);
    c2m = rb * cos(gamma);
    m = cb + c2m * cba;
    R = 2 * m - n2;
    success = 1;
end

