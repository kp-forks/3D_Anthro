function RotationMatrix = Anthro3D_3DRotation_RotationMatrix(RotationAngle, Axis)
% creates a rotation matrix such that [rotationMatrix] * [x]
% operates on [x] by rotating [x] around the origin rotationAngle (radians) around line
% connecting the origin to the point "Axis"
%
% example1:
% rotate around a random direction a random amount and then back
% the result should be an Identity matrix
%
% r = rand(4,1);
% rotationmat3D(r(1),[r(2),r(3),r(4)]) * rotationmat3D(-r(1),[r(2),r(3),r(4)])
%
% example2: 
% rotate around z axis 45 degrees
% Rtest = rotationmat3D(pi/4,[0 0 1])
%
% by Bileschi 2009

if nargin == 1
   if(length(rotX) == 3)
      rotY = rotX(2);
      rotZ = rotZ(3);
      rotX = rotX(1);
   end
end

% useful intermediates
L = norm(Axis);
if (L < eps)
   error('axis direction must be non-zero vector');
end
Axis = Axis / L;
u = Axis(1);
v = Axis(2);
w = Axis(3);
u2 = u^2;
v2 = v^2;
w2 = w^2;
c = cos(RotationAngle);
s = sin(RotationAngle);
%storage
RotationMatrix = nan(3);

%fill
RotationMatrix(1,1) =  u2 + (v2 + w2)*c;
RotationMatrix(1,2) = u*v*(1-c) - w*s;
RotationMatrix(1,3) = u*w*(1-c) + v*s;
RotationMatrix(2,1) = u*v*(1-c) + w*s;
RotationMatrix(2,2) = v2 + (u2+w2)*c;
RotationMatrix(2,3) = v*w*(1-c) - u*s;
RotationMatrix(3,1) = u*w*(1-c) - v*s;
RotationMatrix(3,2) = v*w*(1-c)+u*s;
RotationMatrix(3,3) = w2 + (u2+v2)*c;
