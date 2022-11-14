function [N, k] = getMostConfident(flss)
    maxConf = -inf;
    N = [];
    k = 0;
    for i = 1:size(flss,2)
        conf = flss(i).confidence;
        if conf > maxConf
            maxConf = conf;
            N = flss(i);
            k = i;
        end
    end
end
