function plotScreen(flss, pointCloud, color)
    flsCoords = [flss.el];

    scatter(pointCloud(1,:), pointCloud(2,:), 'blue', 'filled')
    hold on
    scatter(flsCoords(1,:), flsCoords(2,:), color, 'filled')

end

