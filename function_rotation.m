function R = function_rotation(P1, P2, axis, alignTo)
    if strcmp(axis, 'X') || strcmp(axis, 'x')
        A1 = 2; A2 = 3; A3 = [1, 0, 0];
    elseif strcmp(axis, 'Y') || strcmp(axis, 'y')
        A1 = 1; A2 = 3; A3 = [0, 1, 0];
    elseif strcmp(axis, 'Z') || strcmp(axis, 'z')
        A1 = 1; A2 = 2; A3 = [0, 0, 1];
    end

    if strcmp(axis, 'X') || strcmp(axis, 'x')
        if strcmp(alignTo, 'Y') || strcmp(alignTo, 'y')
            vectorAxis = [1, 0];
            vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
            rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));

            if P1(A2) > P2(A2)
                rotationAngle = rotationAngle * -1;
            else
            end
            R = function_rotationmat3D(rotationAngle/180*pi, A3);
            P1 = round(function_rotation_matrix(P1, R), 4);
            P2 = round(function_rotation_matrix(P2, R), 4);
            assert(P1(A2) == P2(A2), 'error - X rotatoin');
            
        elseif strcmp(alignTo, 'Z') || strcmp(alignTo, 'z')
            vectorAxis = [0, 1];
            vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
            rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));

            if P1(A1) > P2(A1)
                rotationAngle = rotationAngle * -1;
            else
            end
            R = function_rotationmat3D(rotationAngle/180*pi, A3);
            P1 = round(function_rotation_matrix(P1, R), 4);
            P2 = round(function_rotation_matrix(P2, R), 4);
            assert(P1(A1) == P2(A1), 'error - X rotatoin');
        end
        
    elseif strcmp(axis, 'Y') || strcmp(axis, 'y')
        if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
            vectorAxis = [1, 0];
            vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
            rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));
            if P1(A2) > P2(A2)
            else
                rotationAngle = rotationAngle * -1;
            end
            R = function_rotationmat3D(rotationAngle/180*pi, A3);
            P1 = round(function_rotation_matrix(P1, R), 4);
            P2 = round(function_rotation_matrix(P2, R), 4);
            assert(P1(A2) == P2(A2), 'error - Y rotatoin');

        elseif strcmp(alignTo, 'Z') || strcmp(alignTo, 'z')
            vectorAxis = [0, 1];
            vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
            rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));
            if P1(A1) > P2(A1)
            else
                rotationAngle = rotationAngle * -1;
            end
            R = function_rotationmat3D(rotationAngle/180*pi, A3);
            P1 = round(function_rotation_matrix(P1, R), 4);
            P2 = round(function_rotation_matrix(P2, R), 4);
            assert(P1(A1) == P2(A1), 'error - Y rotatoin');
        end
        
    elseif strcmp(axis, 'Z') || strcmp(axis, 'z')
        if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
            vectorAxis = [1, 0];
            vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
            rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));
            if P1(A2) > P2(A2)
            else
                rotationAngle = rotationAngle * -1;
            end
            R = function_rotationmat3D(rotationAngle/180*pi, A3);
            P1 = round(function_rotation_matrix(P1, R), 4);
            P2 = round(function_rotation_matrix(P2, R), 4);
            assert(P1(A2) == P2(A2), 'error - Z rotatoin');
            
        elseif strcmp(alignTo, 'Y') || strcmp(alignTo, 'y')
            vectorAxis = [0, 1];
            vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
            rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));
            if P1(A1) > P2(A1)
            else
                rotationAngle = rotationAngle * -1;
            end
            R = function_rotationmat3D(rotationAngle/180*pi, A3);
            P1 = round(function_rotation_matrix(P1, R), 4);
            P2 = round(function_rotation_matrix(P2, R), 4);
            assert(P1(A1) == P2(A1), 'error - Z rotatoin');
        end
    end