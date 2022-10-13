function [out1, out2] = CircleIntersection(x0, y0, r0, x1, y1, r1)

    d = norm([x0 y0] - [x1 y1]);
    
    if d > r0 + r1
        out1 = [nan; nan];
        out2 = [nan; nan];
        return;
    end

    if d < abs(r0 - r1)
        out1 = [nan; nan];
        out2 = [nan; nan];
        return;
    end

    if d == 0 && r0 == r1
        out1 = [nan; nan];
        out2 = [nan; nan];
        return;
    end

    a = (r0^2 - r1^2 + d^2) / (2 * d);
    h = sqrt(r0^2 - a^2);
    x2 = x0 + a * (x1 - x0) / d;
    y2 = y0 + a * (y1 - y0) / d;  
    x3 = x2 + h * (y1 - y0) / d;    
    y3 = y2 - h * (x1 - x0) / d;
    x4 = x2 - h * (y1 - y0) / d;
    y4 = y2 + h * (x1 - x0) / d;
    out1 = [x3; y3];
    out2 = [x4; y4];
end

