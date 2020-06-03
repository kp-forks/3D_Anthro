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
            assert(P1(A2) == P2(A2), 'error - X rotation');
            
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
            assert(P1(A1) == P2(A1), 'error - X rotation');
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
            assert(P1(A2) == P2(A2), 'error - Y rotation');

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
            assert(P1(A1) == P2(A1), 'error - Y rotation');
        end
        
    elseif strcmp(axis, 'Z') || strcmp(axis, 'z')
        if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
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
            assert(P1(A2) == P2(A2), 'error - Z rotation');
            
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
            assert(P1(A1) == P2(A1), 'error - Z rotation');
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
% function R = function_rotation(P1, P2, rotationAxis, alignTo)
%     if strcmp(rotationAxis, 'X') || strcmp(rotationAxis, 'x')
%         A1 = 2; A2 = 3; A3 = [1, 0, 0];
%     elseif strcmp(rotationAxis, 'Y') || strcmp(rotationAxis, 'y')
%         A1 = 1; A2 = 3; A3 = [0, 1, 0];
%     elseif strcmp(rotationAxis, 'Z') || strcmp(rotationAxis, 'z')
%         A1 = 1; A2 = 2; A3 = [0, 0, 1];
%     end
% 
%     if strcmp(rotationAxis, 'X') || strcmp(rotationAxis, 'x')
%         if strcmp(alignTo, 'Y') || strcmp(alignTo, 'y')
%             vectorAxis = [1, 0];
%             R = rotation(vectorAxis, P1, P2, A1, A2, A3);
%             P1 = round(function_rotation_matrix(P1, R), 4);
%             P2 = round(function_rotation_matrix(P2, R), 4);
%             assert(P1(A2) == P2(A2), 'error - X rotation');
%             
%         elseif strcmp(alignTo, 'Z') || strcmp(alignTo, 'z')
%             vectorAxis = [0, 1];
%             R = rotation(vectorAxis, P1, P2, A1, A2, A3);
%             P1 = round(function_rotation_matrix(P1, R), 4);
%             P2 = round(function_rotation_matrix(P2, R), 4);
%             assert(P1(A1) == P2(A1), 'error - X rotation');
%         end
%         
%     elseif strcmp(rotationAxis, 'Y') || strcmp(rotationAxis, 'y')
%         if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
%             vectorAxis = [1, 0];
%             R = rotation(vectorAxis, P1, P2, A1, A2, A3);
%             P1 = round(function_rotation_matrix(P1, R), 4);
%             P2 = round(function_rotation_matrix(P2, R), 4);
%             assert(P1(A2) == P2(A2), 'error - Y rotation');
% 
%         elseif strcmp(alignTo, 'Z') || strcmp(alignTo, 'z')
%             vectorAxis = [0, 1];
%             R = rotation(vectorAxis, P1, P2, A1, A2, A3);
%             P1 = round(function_rotation_matrix(P1, R), 4);
%             P2 = round(function_rotation_matrix(P2, R), 4);
%             assert(P1(A1) == P2(A1), 'error - Y rotation');
%         end
%         
%     elseif strcmp(rotationAxis, 'Z') || strcmp(rotationAxis, 'z')
%         if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
%             vectorAxis = [1, 0];
%             R = rotation(vectorAxis, P1, P2, A1, A2, A3);
%             P1 = round(function_rotation_matrix(P1, R), 4);
%             P2 = round(function_rotation_matrix(P2, R), 4);
%             assert(P1(A2) == P2(A2), 'error - Z rotation');
%             
%         elseif strcmp(alignTo, 'Y') || strcmp(alignTo, 'y')
%             vectorAxis = [0, 1];
%             R = rotation(vectorAxis, P1, P2, A1, A2, A3);
%             P1 = round(function_rotation_matrix(P1, R), 4);
%             P2 = round(function_rotation_matrix(P2, R), 4);
%             assert(P1(A1) == P2(A1), 'error - Z rotation');
%         end
%     end
% 
% function R = rotation(vectorAxis, P1, P2, A1, A2, A3)
%     vectorK = [P1(A1) - P2(A1), P1(A2) - P2(A2)];
%     rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));
%     if vectorAxis(1) == 0
%         if P1(A2) > P2(A2)
%         else
%             rotationAngle = rotationAngle * -1;
%         end
%     else
%         if P1(A1) > P2(A1)
%         else
%             rotationAngle = rotationAngle * -1;
%         end
%     end
%     R = function_rotationmat3D(rotationAngle/180*pi, A3);