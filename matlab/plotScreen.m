function plotScreen(pointCloud, color, f)

figure(f)

if size(pointCloud,1) == 3
    scatter3(pointCloud(1,:), pointCloud(2,:), pointCloud(3,:), color, 'filled')
else
    scatter(pointCloud(1,:), pointCloud(2,:), color, 'filled')
end

axis([0 30 0 30])
axis square
% axis equal

end

