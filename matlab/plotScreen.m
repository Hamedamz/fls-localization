function h = plotScreen(pointCloud, color, f)

figure(f)

if size(pointCloud,1) == 3
    h = scatter3(pointCloud(1,:), pointCloud(2,:), pointCloud(3,:), color, 'filled');
    axis equal
else
    h = scatter(pointCloud(1,:), pointCloud(2,:), color, 'filled');
    axis([0 30 0 30])
    axis square
end

grid on

end

