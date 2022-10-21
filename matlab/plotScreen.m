function plotScreen(pointCloud, color, f)
    figure(f)
    scatter(pointCloud(1,:), pointCloud(2,:), color, 'filled')
    grid
end

