function [min, max, avg] = reportMetrics(flss)
min = Inf;
max = 0;
sum = 0;

for i = 1:size(flss, 2)
    d = norm(flss(i).gtl - flss(i).el);
    sum = sum + d;
    
    if d < min
        min = d;
    end
    
    if d > max
        max = d;
    end
end

avg = sum / size(flss, 2);

sprintf('Distance between EL and GTL:\nmin: %f\nmax: %f\navg: %f', min, max, avg)
end

