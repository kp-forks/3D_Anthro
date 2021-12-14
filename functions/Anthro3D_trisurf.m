function F = Anthro3D_trisurf(V, F, figureNumber, lightOn, color)
    if nargin < 5
        color = [1 0.88 0.77];
    end
    figure(figureNumber);
    F = trisurf(F, V(:,1), V(:,2), V(:,3), 'edgecolor', 'none', 'facecolor', color);
        axis equal
        view(2)
        set(gca, 'xtick', [])
        set(gca, 'ytick', [])
        set(gca, 'ztick', [])
        set(gca, 'xticklabel', [])
        set(gca, 'yticklabel', [])
        set(gca, 'zticklabel', [])
        set(gca, 'visible', 'off')
        lighting gouraud; material dull;
        if lightOn == 1
            light('Position', [3 5 20], 'Style', 'infinite');
        end