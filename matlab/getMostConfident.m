function N = getMostConfident(flss)
    maxConf = -inf;
    for i = 1:size(flss,2)
        conf = flss(i).confidence;
        if conf > maxConf
            maxConf = conf;
            N = flss(i);
        end
    end
end
