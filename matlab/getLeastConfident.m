function [N, k] = getLeastConfident(flss)
    minConf = inf;
    for i = 1:size(flss,2)
        conf = flss(i).confidence;
        if conf < minConf
            minConf = conf;
            N = flss(i);
            k = i;
        end
    end
end
