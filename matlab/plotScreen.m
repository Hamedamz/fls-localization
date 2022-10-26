function plotScreen(pointCloud, color, f)
if size(pointCloud,1) == 3
    figure(f)
    scatter3(pointCloud(1,:), pointCloud(2,:), pointCloud(3,:), color, 'filled')
else
    figure(f)
    scatter(pointCloud(1,:), pointCloud(2,:), color, 'filled')
end

end

