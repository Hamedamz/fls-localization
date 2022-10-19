function pointCloud = getPointCloudFromPNG(path)

[~,~,transparency] = imread(path);

count = 0;

for i = 1:size(transparency, 1)
    for j = 1:size(transparency, 2)
        if transparency(i, j) > 127
            count = count + 1;
            pointCloud(:, count) = [i; j];
        end
    end
end
end

