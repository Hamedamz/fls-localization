function plotScreen(flss, pointCloud, color)
    flsCoords = [flss.el];

    scatter(flsCoords(1,:), flsCoords(2,:), color, 'filled')
    hold on
    scatter(pointCloud(1,:), pointCloud(2,:), 'blue', 'filled')
end

