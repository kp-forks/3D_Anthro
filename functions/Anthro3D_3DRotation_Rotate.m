function data = Anthro3D_3DRotation_Rotate(data, rMatrix, rotationCenter)
    if nargin < 3
        rotationCenter = [0, 0, 0];
    end

    data_copy = data;
    for j = 1:3
        data_copy(:, j) = data_copy(:, j) - rotationCenter(j);
    end
    for j = 1:3
        data(:, j) = rMatrix(j, 1)*data_copy(:, 1) + rMatrix(j, 2)*data_copy(:, 2) + rMatrix(j, 3)*data_copy(:, 3);
        data(:, j) = data(:, j) + rotationCenter(j);
    end