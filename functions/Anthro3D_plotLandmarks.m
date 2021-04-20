function F = Anthro3D_plotLandmarks(LMs, properties)
    F = plot3(LMs(:,1), LMs(:,2), LMs(:,3), properties);