function Anthro3D_simpleTrisurf(F, V, facecolor, lightOn)
    % facecolor [1 0.88 0.77] for skin color
    figure(99);
    trisurf(F, V(:,1), V(:,2), V(:,3), 'edgecolor', 'none', 'facecolor', facecolor);
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