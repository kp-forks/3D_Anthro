function R = Anthro3D_3DRotation(P1, P2, rotationAxis, alignTo, rotationDirection)
    if nargin < 5
        rotationDirection = '';
    end

    if strcmp(rotationAxis, 'X') || strcmp(rotationAxis, 'x')
        A1 = [2, 3]; % A1(1) = Y, A1(2) = Z
        if strcmp(alignTo, 'Y') || strcmp(alignTo, 'y')
            vectorAxis = [1, 0];
            if P1(2) < P2(2)
                [P1, P2] = switchPts(P1, P2);
            end
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 2, rotationDirection);

        elseif strcmp(alignTo, 'Z') || strcmp(alignTo, 'z')
            vectorAxis = [0, 1];
            if P1(2) < P2(2)
                [P1, P2] = switchPts(P1, P2);
            end
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 1, rotationDirection);

        else
            vectorAxis = alignTo([2, 3]);
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 3, rotationDirection);
        end
        
    elseif strcmp(rotationAxis, 'Y') || strcmp(rotationAxis, 'y')
        A1 = [1, 3]; % A1(1) = X, A1(2) = Z
        if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
            vectorAxis = [1, 0];
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 2, rotationDirection);

        elseif strcmp(alignTo, 'Z') || strcmp(alignTo, 'z')
            vectorAxis = [0, 1];
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 1, rotationDirection);

        else
            vectorAxis = alignTo([1, 3]);
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 3, rotationDirection);
        end
        
    elseif strcmp(rotationAxis, 'Z') || strcmp(rotationAxis, 'z')
        A1 = [1, 2]; % A1(1) = X, A1(2) = Y
        if strcmp(alignTo, 'X') || strcmp(alignTo, 'x')
            vectorAxis = [1, 0];
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 2, rotationDirection);
            
        elseif strcmp(alignTo, 'Y') || strcmp(alignTo, 'y')
            vectorAxis = [0, 1];
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 1, rotationDirection);

        else
            vectorAxis = alignTo([1, 2]);
            R = rotation(P1, P2, vectorAxis, A1, rotationAxis, 3, rotationDirection);
        end
    end
end
    
    
    
function R = rotation(P1, P2, vectorAxis, A1, rotationAxis, cases, rotationDirection)
    vectorK = [P1(A1(1)) - P2(A1(1)), P1(A1(2)) - P2(A1(2))];
    rotationAngle = acosd(dot(vectorK, vectorAxis) / (norm(vectorK) * norm(vectorAxis)));

    if strcmp(rotationDirection, '+')
    elseif strcmp(rotationDirection, '+90')
        rotationAngle = rotationAngle +90;
    elseif strcmp(rotationDirection, '-')
        rotationAngle = rotationAngle * -1;
    elseif strcmp(rotationDirection, '-90')
        rotationAngle = rotationAngle -90;
    end

    if cases ~= 3
        try
            R = Anthro3D_3DRotation_RotationMatrix(rotationAngle/180*pi, rotationAxis);
            P1_rotated = round(Anthro3D_3DRotation_Rotate(P1, R), 4);
            P2_rotated = round(Anthro3D_3DRotation_Rotate(P2, R), 4);
            assert(P1_rotated(A1(cases)) == P2_rotated(A1(cases)), 'rotation error');
        catch
            rotationAngle = rotationAngle * -1;
            R = Anthro3D_3DRotation_RotationMatrix(rotationAngle/180*pi, rotationAxis);
            P1_rotated = round(Anthro3D_3DRotation_Rotate(P1, R), 4);
            P2_rotated = round(Anthro3D_3DRotation_Rotate(P2, R), 4);
            assert(P1_rotated(A1(cases)) == P2_rotated(A1(cases)), 'rotation error');
        end
    else
        R = Anthro3D_3DRotation_RotationMatrix(rotationAngle/180*pi, rotationAxis);
    end
end


function [P1, P2] = switchPts(P1, P2)
    tmp = P1;
    P1 = P2;
    P2 = tmp;
end