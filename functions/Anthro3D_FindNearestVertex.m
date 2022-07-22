function [nearestPt, idx] = Anthro3D_FindNearestVertex(V, targetPts)
    ptCloudVertex = pointCloud(V);
    nearestPt = zeros(size(targetPts, 1), 3);
    idx = zeros(size(targetPts, 1), 1);
    
    for i = 1:size(targetPts, 1)
        [idx(i), ~] = findNearestNeighbors(ptCloudVertex, targetPts(i, :), 1);
        nearestPt(i, :) = V(idx(i), :);
    end