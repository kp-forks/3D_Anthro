function [circumference, convdata] = Anthro3D_MeasurementCircumferencXZ(V, H, upperMargin, lowerMargin)

    V(V(:, 2) > H + upperMargin, :) = [];
    V(V(:, 2) < H - lowerMargin, :) = [];
    
    k = convhull(V(:, 1), V(:, 3));
    convdata = V(k, 1:3);
    assert(~isempty(convdata), 'data matrix of convex hull analysis is empty');
    circumference = 0;
    for i = 2:size(convdata, 1) % circumference
        circumference = circumference + norm(convdata(i-1, [1,3]) - convdata(i, [1,3]));
    end