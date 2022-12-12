function KNN = getKNN(fls, flss, k)
    if size(flss,2)
        Idx = knnsearch([flss.el].',[fls.el].', 'K', k);
        KNN = flss(Idx);
    else
        KNN = [];
    end
end

