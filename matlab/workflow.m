pointCloud = [0 0; 0 1; 1 1; 1 0] + 5;

screen = containers.Map('KeyType','char','ValueType','any');
dispatchers = {Dispatcher([0 0])};

for i = 1:size(pointCloud, 1)
    point = pointCloud(i,:);
    dispatcher = selectDispatcher(point, dispatchers);
    fls = FLS(dispatcher.coord, point, @confByDistance);
    fls.flyTo(point);
    screen(fls.id) = fls;
end

plotScreen(screen, pointCloud)