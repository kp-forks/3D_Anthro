function [ListVertex, landmark] = function_alignment(source, ListFace, ListVertex, landmark, visualization)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 30 Mar 2016
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTE: This code is illustrated for some facial measurement.
    
    %% visualization of 3D face
    if visualization == 1
        f = figure(1);
%             set(f, 'Name', filename_3D_scan);
            set(f, 'position', [100 200 600 600]);
        %     set(f, 'MenuBar', 'none');
        %     set(f, 'ToolBar', 'none');

            h = trisurf(ListFace, ListVertex(:, 1), ListVertex(:, 2), ListVertex(:, 3));
                set(h, 'FaceColor',[1 0.88 0.77])
                set(h, 'EdgeColor', 'none');
                set(h, 'facealpha',0.5);

                view(2);
                axis equal;
                light('Position', [3 5 7], 'Style', 'infinite');
                lighting gouraud;
                material dull;

        %% visualization of landmarks
            hold on
            h = plot3(landmark{:, 1}, landmark{:, 2}, landmark{:, 3}, 'k.');
                set(h, 'color', 'b', 'markersize', 10)
    end

    VectorAxis = [1, 0];
    
    landmark_array = table2array(landmark);
    
    if source.point1(2) < source.point2(2)
        temp = source.point1;
        source.point1 = source.point2;
        source.point2 = temp;
    end
    
    if source.point4(1) < source.point3(1)
        temp = source.point3;
        source.point3 = source.point4;
        source.point4 = temp;
    end
    
    % rotate X axis
    VectorK = [source.point1(2) - source.point2(2), source.point1(3) - source.point2(3)];
    rotAngle = acosd(dot(VectorK, VectorAxis) / (norm(VectorK) * norm(VectorAxis)));
    if rotAngle > 90
        rotAngle = 180 - rotAngle;
    end
    rotAngle = rotAngle/180*pi;
    if source.point1(3) > source.point2(3)
        R = function_rotationmat3D(-rotAngle, [1, 0, 0]);
    else
        R = function_rotationmat3D(rotAngle, [1, 0, 0]);
    end

    ListVertex     = function_rotation_matrix(ListVertex, R);
    landmark_array = function_rotation_matrix(landmark_array, R);
    source.point1  = function_rotation_matrix(source.point1, R);
    source.point2  = function_rotation_matrix(source.point2, R);
    source.point3  = function_rotation_matrix(source.point3, R);
    source.point4  = function_rotation_matrix(source.point4, R);
    
    
    % rotate Z axis
    VectorK = [source.point1(2) - source.point2(2), source.point1(1) - source.point2(1)];
    rotAngle = acosd(dot(VectorK, VectorAxis) / (norm(VectorK) * norm(VectorAxis)));
    if rotAngle > 90
        rotAngle = 180 - rotAngle;
    end
    rotAngle = rotAngle/180*pi;
    if source.point1(1) < source.point2(1)
        R = function_rotationmat3D(-rotAngle, [0, 0, 1]);
    else
        R = function_rotationmat3D(rotAngle, [0, 0, 1]);
    end

    ListVertex     = function_rotation_matrix(ListVertex, R);
    landmark_array = function_rotation_matrix(landmark_array, R);
    source.point1  = function_rotation_matrix(source.point1, R);
    source.point2  = function_rotation_matrix(source.point2, R);
    source.point3  = function_rotation_matrix(source.point3, R);
    source.point4  = function_rotation_matrix(source.point4, R);
    
    
    % rotate Y axis
    VectorK = [source.point3(1) - source.point4(1), source.point3(3) - source.point4(3)];
    rotAngle = acosd(dot(VectorK, VectorAxis) / (norm(VectorK) * norm(VectorAxis)));
    if rotAngle > 90
        rotAngle = 180 - rotAngle;
    end
    rotAngle = rotAngle/180*pi;
    if source.point3(3) > source.point4(3)
        R = function_rotationmat3D(-rotAngle, [0, 1, 0]);
    else
        R = function_rotationmat3D(rotAngle, [0, 1, 0]);
    end

    ListVertex     = function_rotation_matrix(ListVertex, R);
    landmark_array = function_rotation_matrix(landmark_array, R);
    source.point1  = function_rotation_matrix(source.point1, R);
    source.point2  = function_rotation_matrix(source.point2, R);
    source.point3  = function_rotation_matrix(source.point3, R);
    source.point4  = function_rotation_matrix(source.point4, R);
    
    
    landmark_array(:, :) = roundn(landmark_array(:, :), -5);
    landmark{:, :} = landmark_array(:, :);