function plotScreen(flss, pointCloud)
    flsCoords = [flss.el];

    scatter(flsCoords(1,:), flsCoords(2,:), "red", "filled")
    hold on
    scatter(pointCloud(1,:), pointCloud(2,:), color, "filled")
end

