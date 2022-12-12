function A = pngToPly(path, pointCloudFileName)
    [~,~,transparency] = imread(path);

    count = 0;
    
    xres = size(transparency, 1);
    yres = size(transparency, 2);
    
    A = [];
    
    for i = 1:xres
        for j = 1:yres
            t = transparency(i, j);
            if (t < 1 && t > 0.25) || (t > 127)
                count = count + 1;
                A(:, count) = [j + 3; xres - i + 3];
            end
        end
    end

    fid = fopen(pointCloudFileName,'w');
    fprintf(fid,'ply\nformat ascii 1.0\nelement vertex %d\nelement face 0\nproperty list uchar uint vertex_indices\nend_header\n', count);
    % fprintf(fid,'%d 0 0 \n',size(ptCloud,1));
    for j=1:size(A,2)
        % The following switch between y and z is intentional
        % It is to accomodate matlab 3D plot used in plotPtCld.m
        fprintf(fid,'%d %d %d 0 0 0 0\n',A(1,j), A(2,j), 0 );
    end

    fclose(fid);

end

