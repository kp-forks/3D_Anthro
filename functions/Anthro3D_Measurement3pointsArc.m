function [circumference, datapoints] = Anthro3D_Measurement3pointsArc(V, left, middle, right)

    vectorY = [0, 1];
    vectorZ = [0, 1];
    
    V = [V];
%     V_backup = V;

    % left¸
    origin = left;
    middle = middle - origin;
    right = right - origin;
    V(:, 1) = V(:, 1) - origin(1, 1);
    V(:, 2) = V(:, 2) - origin(1, 2);
    V(:, 3) = V(:, 3) - origin(1, 3);
    left = left - origin;
    
%     [left; middle; right]
        
    % y rotation
    Ry = function_rotation(left, right, 'Y', 'X');
    left = function_rotation_matrix(left, Ry);
    middle = function_rotation_matrix(middle, Ry);
    right = function_rotation_matrix(right, Ry);
    V  = function_rotation_matrix(V, Ry);
    
%     [left; middle; right]
%     [   sqrt((left(1, 1) - right(1, 1))^2 + (left(1, 2) - right(1, 2))^2 + (left(1, 3) - right(1, 3))^2); ...
%         sqrt((left(1, 1) - middle(1, 1))^2 + (left(1, 2) - middle(1, 2))^2 + (left(1, 3) - middle(1, 3))^2); ...
%         sqrt((middle(1, 1) - right(1, 1))^2 + (middle(1, 2) - right(1, 2))^2 + (middle(1, 3) - right(1, 3))^2)]
    assert(round(right(3), 4) == 0);
    
    % z rotation
    Rz = function_rotation(left, right, 'Z', 'X');
    left = function_rotation_matrix(left, Rz);
    middle = function_rotation_matrix(middle, Rz);
    right = function_rotation_matrix(right, Rz);
    V  = function_rotation_matrix(V, Rz);
    
%     [left; middle; right]
%     [   sqrt((left(1, 1) - right(1, 1))^2 + (left(1, 2) - right(1, 2))^2 + (left(1, 3) - right(1, 3))^2); ...
%         sqrt((left(1, 1) - middle(1, 1))^2 + (left(1, 2) - middle(1, 2))^2 + (left(1, 3) - middle(1, 3))^2); ...
%         sqrt((middle(1, 1) - right(1, 1))^2 + (middle(1, 2) - right(1, 2))^2 + (middle(1, 3) - right(1, 3))^2)]
    assert(round(right(2), 4) == 0);
    
%     x rotation
    Rx = function_rotation(middle, left, 'X', 'Z');
    left   = function_rotation_matrix(left,   Rx);
    middle = function_rotation_matrix(middle, Rx);
    right  = function_rotation_matrix(right , Rx);
    V   = function_rotation_matrix(V,   Rx);
    
%     plot3(V(1:10:size(V, 1), 1), V(1:10:size(V, 1), 3), V(1:10:size(V, 1), 2), '.b');
%     view(2)
%     axis equal
%     hold on
    
%     [left; middle; right]
%     [   sqrt((left(1, 1) - right(1, 1))^2 + (left(1, 2) - right(1, 2))^2 + (left(1, 3) - right(1, 3))^2); ...
%         sqrt((left(1, 1) - middle(1, 1))^2 + (left(1, 2) - middle(1, 2))^2 + (left(1, 3) - middle(1, 3))^2); ...
%         sqrt((middle(1, 1) - right(1, 1))^2 + (middle(1, 2) -         right(1, 2))^2 + (middle(1, 3) - right(1, 3))^2)]
    assert(round(right(2), 4) == 0);
    assert(round(right(3), 4) == 0);
    assert(round(middle(2), 4) == 0);
    
    margin = 10;
    
%     [V, idx] = sortrows(V, -1);
%     V_backup = V_backup(idx, :);
       
%     V_backup(V(:, 1) > left(1) + 10, :) = [];
    V(V(:, 1) > left(1) + 10, :) = [];
    
%     V_backup(V(:, 1) < right(1) - 10, :) = [];
    V(V(:, 1) < right(1) - 10, :) = [];
        
%     V_backup(V(:, 2) < -margin, :) = [];
    V(V(:, 2) < -margin, :) = [];
    
%     V_backup(V(:, 2) > margin, :) = [];
    V(V(:, 2) > margin, :) = [];
    
%     V_backup(V(:, 3) < -1, :) = [];
    V(V(:, 3) < -1, :) = [];
    
    plot3(V(1:size(V, 1), 1), V(1:size(V, 1), 3), V(1:size(V, 1), 2), '.r');
    


    k = convhull(V(:, 1), V(:, 3)); % convex hull

    datapoints = [];
    convdata = V(k, 1:3);
%     convdata_original_datapoints = V_backup(k, 1:3);
    circumference = 0;
    for i = 2:size(convdata, 1) % circumference
        if sqrt((convdata(i, 1) - convdata(i-1, 1))^2 + (convdata(i, 3) - convdata(i-1, 3))^2) < 100
            circumference = circumference + sqrt((convdata(i, 1) - convdata(i-1, 1))^2 + (convdata(i, 3) - convdata(i-1, 3))^2);
%             datapoints = [datapoints; convdata_original_datapoints(i-1, :); convdata_original_datapoints(i, :); ];
        end
    end
%     datapoints = unique(datapoints, 'rows', 'stable');

%     datapoints(:, 1) = datapoints(:, 1) + origin(1, 1);
%     datapoints(:, 2) = datapoints(:, 2) + origin(1, 2);
%     datapoints(:, 3) = datapoints(:, 3) + origin(1, 3);
    
%     filename = sprintf('conv1/%3d.asc', p);
%     fid = fopen(filename, 'w');
%     for i = 1:size(convdata, 1)
%         fprintf(fid, '%f\t%f\t0\n', convdata(i, 1), convdata(i, 2));
%     end
%     fclose(fid);
%     
%     
%     convdata(:, 1) = convdata(:, 1) - middle(1, 1);
%     convdata(:, 2) = convdata(:, 2) - middle(1, 3);
%     
%     filename = sprintf('conv2/%3d.asc', p);
%     fid = fopen(filename, 'w');
%     for i = 1:size(convdata, 1)
%         fprintf(fid, '%f\t%f\t0\n', convdata(i, 1), convdata(i, 2));
%     end
%     fclose(fid);
    
    
%     hold on;
%     size(convdata, 1)
%     plot3(convdata(:, 1), convdata(:, 3), zeros(size(convdata, 1)), '*r');
%     plot3(convdata(:, 1), convdata(:, 3), zeros(size(convdata, 1)), '-r');
%     plot3(left(1, 1), left(1, 3), left(1, 2), 'Ok');
%     plot3(right(1, 1), right(1, 3), right(1, 2), 'Ok');
%     plot3(middle(1, 1), middle(1, 3), middle(1, 2), 'Ok');
%     pause;
%     close all;