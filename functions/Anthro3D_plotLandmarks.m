function F = Anthro3D_plotLandmarks(LMs, properties)
    if nargin == 1
        properties = {'r.', 'markersize', 10};
    end
    
    F = plot3(LMs(:,1), LMs(:,2), LMs(:,3), properties{:});