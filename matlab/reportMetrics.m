function [min, max, avg, totalTraveled, numFLSMoved] = reportMetrics(flss)
min = Inf;
max = 0;
sum = 0;
totalTraveled = 0;
numFLSMoved = 0;
maxTime = 0;

for i = 1:size(flss, 2)
    d = norm(flss(i).gtl - flss(i).el);
    sum = sum + d;

    tm = (flss(i).distanceTraveled + flss(i).distanceExplored) / flss(i).speed;

    if tm > maxTime
        maxTime = tm;
    end
    
    if d < min
        min = d;
    end
    
    if d > max
        max = d;
    end

    if flss(i).distanceExplored > 0
        numFLSMoved = numFLSMoved + 1;
        totalTraveled = totalTraveled + flss(i).distanceExplored;
    end
end

avg = sum / size(flss, 2);

sprintf('Distance between EL and GTL:\nmin: %f\nmax: %f\navg: %f\ntotalDistanceExplored: %f\nnumFLSsMoved: %d\nmaxTravelTime: %f\n', min, max, avg, totalTraveled, numFLSMoved, maxTime)
end

