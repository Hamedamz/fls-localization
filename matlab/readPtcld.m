function A = readPtcld(path, n)
    fileID = fopen(path,'r');
    formatSpec = '%d %d %d\n';
    A = fscanf(fileID,formatSpec, [3 Inf]);
    fclose(fileID);

    if n>0
        rp = randperm(size(A,2));
        A = A(:, rp(1:n));
    end
end

