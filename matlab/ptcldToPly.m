function A = ptcldToPly(path, pointCloudFileName)
    fileID = fopen(path,'r');
    formatSpec = '%d %d %d\n';
    A = fscanf(fileID,formatSpec, [3 Inf]);
    fclose(fileID);

    fid = fopen(pointCloudFileName,'w');
    fprintf(fid,'ply\nformat ascii 1.0\nelement vertex %d\nelement face 0\nproperty list uchar uint vertex_indices\nend_header\n', size(A,2));
    % fprintf(fid,'%d 0 0 \n',size(ptCloud,1));
    for j=1:size(A,2)
        % The following switch between y and z is intentional
        % It is to accomodate matlab 3D plot used in plotPtCld.m
        fprintf(fid,'%d %d %d 0 0 0 0\n',A(1,j), A(2,j), A(3,j) );
    end

    fclose(fid);

end

