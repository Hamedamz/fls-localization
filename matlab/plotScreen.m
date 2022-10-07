function plotScreen(screen, pointCloud)
    flss = screen.values();
    flsCoords = zeros(size(pointCloud));
    
    for i = 1:size(pointCloud,1)
        flsCoords(i,:) = flss{i}.el;
    end

    scatter(flsCoords(:,1), flsCoords(:,2), "red", "filled")
    hold on
    scatter(pointCloud(:,1), pointCloud(:,2), "blue")
end

