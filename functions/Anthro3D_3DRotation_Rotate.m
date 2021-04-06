function data = Anthro3D_3DRotation_Rotate(data, rMatrix)
    data_copy = data;
    data(:, 1) = rMatrix(1, 1)*data_copy(:, 1) + rMatrix(1, 2)*data_copy(:, 2) + rMatrix(1, 3)*data_copy(:, 3);
    data(:, 2) = rMatrix(2, 1)*data_copy(:, 1) + rMatrix(2, 2)*data_copy(:, 2) + rMatrix(2, 3)*data_copy(:, 3);
    data(:, 3) = rMatrix(3, 1)*data_copy(:, 1) + rMatrix(3, 2)*data_copy(:, 2) + rMatrix(3, 3)*data_copy(:, 3);