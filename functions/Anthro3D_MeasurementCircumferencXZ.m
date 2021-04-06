function circumference = Anthro3D_MeasurementCircumferencXZ(V, H, upperMargin, loewrMargin)

    V(V(:, 2) > H + upperMargin, :) = [];
    V(V(:, 2) < H - loewrMargin, :) = [];
    
    k = convhull(V(:, 1), V(:, 2));
    convdata = V(k, 1:3);
    assert(~isempty(convdata), 'data matrix of convex hull analysis is empty');
    circumference = 0;
    for i = 2:size(convdata, 1) % circumference
        circumference = circumference + norm(convdata(i-1, 1:2) - convdata(i, 1:2));
    end