function [ListVertex, landmark] = example_alignment(reference, origin, ListFace, ListVertex, landmark, visualization)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab Tutorial for 3D Anthropometry
    %
    % Wonsup Lee
    % 30 May 2016
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
    origin = table2array(origin);
    
    if reference.point1(2) < reference.point2(2)
        temp = reference.point1;
        reference.point1 = reference.point2;
        reference.point2 = temp;
    end
    
    if reference.point4(1) < reference.point3(1)
        temp = reference.point3;
        reference.point3 = reference.point4;
        reference.point4 = temp;
    end
    
    % rotate X axis
    VectorK = [reference.point1(2) - reference.point2(2), reference.point1(3) - reference.point2(3)];
    rotAngle = acosd(dot(VectorK, VectorAxis) / (norm(VectorK) * norm(VectorAxis)));
    if rotAngle > 90
        rotAngle = 180 - rotAngle;
    end
    rotAngle = rotAngle/180*pi;
    if reference.point1(3) > reference.point2(3)
        R = function_rotationmat3D(-rotAngle, [1, 0, 0]);
    else
        R = function_rotationmat3D(rotAngle, [1, 0, 0]);
    end

    ListVertex     = function_rotation_matrix(ListVertex, R);
    landmark_array = function_rotation_matrix(landmark_array, R);
    reference.point1  = function_rotation_matrix(reference.point1, R);
    reference.point2  = function_rotation_matrix(reference.point2, R);
    reference.point3  = function_rotation_matrix(reference.point3, R);
    reference.point4  = function_rotation_matrix(reference.point4, R);
    
    
    % rotate Z axis
    VectorK = [reference.point1(2) - reference.point2(2), reference.point1(1) - reference.point2(1)];
    rotAngle = acosd(dot(VectorK, VectorAxis) / (norm(VectorK) * norm(VectorAxis)));
    if rotAngle > 90
        rotAngle = 180 - rotAngle;
    end
    rotAngle = rotAngle/180*pi;
    if reference.point1(1) < reference.point2(1)
        R = function_rotationmat3D(-rotAngle, [0, 0, 1]);
    else
        R = function_rotationmat3D(rotAngle, [0, 0, 1]);
    end

    ListVertex     = function_rotation_matrix(ListVertex, R);
    landmark_array = function_rotation_matrix(landmark_array, R);
    reference.point1  = function_rotation_matrix(reference.point1, R);
    reference.point2  = function_rotation_matrix(reference.point2, R);
    reference.point3  = function_rotation_matrix(reference.point3, R);
    reference.point4  = function_rotation_matrix(reference.point4, R);
    
    
    % rotate Y axis
    VectorK = [reference.point3(1) - reference.point4(1), reference.point3(3) - reference.point4(3)];
    rotAngle = acosd(dot(VectorK, VectorAxis) / (norm(VectorK) * norm(VectorAxis)));
    if rotAngle > 90
        rotAngle = 180 - rotAngle;
    end
    rotAngle = rotAngle/180*pi;
    if reference.point3(3) > reference.point4(3)
        R = function_rotationmat3D(-rotAngle, [0, 1, 0]);
    else
        R = function_rotationmat3D(rotAngle, [0, 1, 0]);
    end

    ListVertex     = function_rotation_matrix(ListVertex, R);
    landmark_array = function_rotation_matrix(landmark_array, R);
    reference.point1  = function_rotation_matrix(reference.point1, R);
    reference.point2  = function_rotation_matrix(reference.point2, R);
    reference.point3  = function_rotation_matrix(reference.point3, R);
    reference.point4  = function_rotation_matrix(reference.point4, R);
    
    
    landmark_array(:, :) = roundn(landmark_array(:, :), -5);
    
    % change origin point
    landmark_array = landmark_array - repmat(origin, size(landmark_array, 1), 1);
    ListVertex = ListVertex - repmat(origin, size(ListVertex, 1), 1);
    
    landmark{:, :} = landmark_array(:, :);