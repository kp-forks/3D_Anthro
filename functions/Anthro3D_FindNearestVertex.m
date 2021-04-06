function [nearestPt, idx] = Anthro3D_FindNearestVertex(V, targetPoint)
    ptCloudVertex = pointCloud(V);
    [idx, ~] = findNearestNeighbors(ptCloudVertex, targetPoint, 1);
    nearestPt = V(idx, :);