function pathxyz = Anthro_ShortestPath_genPath(point1, point2, V, sparsematrix, method)
    % find index of point1 and point2
    if size(V, 2) > 3
        V(:, 4:end) = [];
    end
    ptCloudVertex = pointCloud(V);
    [index, ~] = findNearestNeighbors(ptCloudVertex, point1, 1);
    point1 = V(index, :);
    [index, ~] = findNearestNeighbors(ptCloudVertex, point2, 1);
    point2 = V(index, :);
    
    point1Index = find(V(:, 1) == point1(1));
        if size(point1Index, 1) > 1
            temp99 = V(point1Index, :);
            clear point1Index;
            point1Index = find(temp99(:, 2) == point1(2));
        end
        if size(point1Index, 1) > 1
            temp99 = V(point1Index, :);
            clear point1Index;
            point1Index = find(temp99(:, 3) == point1(3));
        end
    point2Index = find(V(:, 1) == point2(1));
        if size(point2Index, 1) > 1
            temp99 = V(point2Index, :);
            clear point2Index;
            point2Index = find(temp99(:, 2) == point2(2));
        end
        if size(point2Index, 1) > 1
            temp99 = V(point2Index, :);
            clear point2Index;
            point2Index = find(temp99(:, 3) == point2(3));
        end
    assert(size(point1Index, 1) == 1);
    assert(size(point2Index, 1) == 1);

    % shortestpath
    [~, path, ~] = graphshortestpath(sparsematrix, point1Index, point2Index, 'method', method);
    path = path';
    if ~isempty(path)
        for i = 1:size(path, 1)
            pathxyz(i, :) = V(path(i), :);
        end
    else
        pathxyz = [NaN, NaN, NaN];
    end