function h = plotScreen(pointCloud, color, f)

figure(f)

if size(pointCloud,1) == 3
    h = scatter3(pointCloud(1,:), pointCloud(2,:), pointCloud(3,:), color, 'filled');
else
    h = scatter(pointCloud(1,:), pointCloud(2,:), color, 'filled');
end

grid on
axis([0 30 0 30])
axis square
% axis equal

end

