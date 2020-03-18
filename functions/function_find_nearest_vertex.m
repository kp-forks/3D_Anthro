function [nearestPt, idx] = function_find_nearest_vertex(V, point)
    ptCloudVertex = pointCloud(V);
    [idx, ~] = findNearestNeighbors(ptCloudVertex, point, 1);
    nearestPt = V(idx, :);