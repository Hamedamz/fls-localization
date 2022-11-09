function pointCloud = getPointCloudFromPNG(path)

[~,~,transparency] = imread(path);

count = 0;

xres = size(transparency, 1);
yres = size(transparency, 2);

for i = 1:xres
    for j = 1:yres
        if transparency(i, j) > 127
            count = count + 1;
            pointCloud(:, count) = [j + 3; xres - i + 3];
        end
    end
end
end

