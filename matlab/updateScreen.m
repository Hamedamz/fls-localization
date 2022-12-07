function updateScreen(h, pointCloud)


if size(pointCloud,1) == 3
    set(h, 'XData', pointCloud(1,:), 'YData', pointCloud(2,:), 'ZData', pointCloud(3,:))
else
    set(h, 'XData', pointCloud(1,:), 'YData', pointCloud(2,:))
end

drawnow

% grid on
% axis([0 30 0 30])
% axis square
% axis equal

end

