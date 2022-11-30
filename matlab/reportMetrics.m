function [s, avg, cavg, max, totalTraveled, numFLSMoved] = reportMetrics(flss)
min = Inf;
max = 0;
sum = 0;
cmin = Inf;
cmax = 0;
csum = 0;
totalTraveled = 0;
numFLSMoved = 0;
maxTime = 0;

for i = 1:size(flss, 2)
    d = 0;
    for j = 1:size(flss, 2)
        if i == j 
            continue;
        end

        gtd = flss(i).gtl - flss(j).gtl;
        ed = flss(i).el - flss(j).el;

        d = d + norm(ed - gtd);
    end

    d = d / (j-1);

    sum = sum + d;

    if d < min
        min = d;
    end
    
    if d > max
        max = d;
    end

    tm = flss(i).distanceTraveled / flss(i).speed;

    if tm > maxTime
        maxTime = tm;
    end

    if flss(i).distanceTraveled > 0
        numFLSMoved = numFLSMoved + 1;
        totalTraveled = totalTraveled + flss(i).distanceTraveled;
    end

    conf = flss(i).confidence;
    csum = csum + conf;

    if conf < cmin
        cmin = conf;
    end
    
    if conf > cmax
        cmax = conf;
    end
end

avg = sum / i;
cavg = csum / i;

% dH = hausdorff([flss.gtl], [flss.el]);

% s=sprintf('Difference between EL and GTL:\n min: %f\n avg: %f\n max: %f\nConfidence:\n min: %f\n avg: %f\n max: %f\ntotalDistanceExplored: %f\nnumFLSsMoved: %d\nmaxTravelTime: %f\n', min, avg, max, cmin, cavg, cmax, totalTraveled, numFLSMoved, maxTime);
s=sprintf('Difference between EL and GTL:\n min: %f\n avg: %f\n max: %f\ntotalDistanceExplored: %f\nnumFLSsMoved: %d\nmaxTravelTime: %f\n', min, avg, max, totalTraveled, numFLSMoved, maxTime);
end

