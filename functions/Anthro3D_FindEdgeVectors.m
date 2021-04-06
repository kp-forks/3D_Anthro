function [EV] = Anthro3D_FindEdgeVectors(V, F)
    % surface centroid
    C(size(F,1), 3) = NaN;
    for i = 1:size(F, 1)
        C(i, :) = (V(F(i, 1), :) + V(F(i, 2), :) + V(F(i, 3), :))/3;
    end

    % surface normals (unit vector)
    UV(size(F, 1), 3) = NaN;
    for i = 1:size(F, 1)
        N = cross(V(F(i, 1), :) - V(F(i, 2), :), V(F(i, 1), :) - V(F(i, 3), :));
        UV(i, :) = N / norm(N);
    end

    % find edges (pair between two surface normal vectors)
    F_backup = F;
    F_pairs = [];
    for i = 1:max(F(:))
        clear findFaceHaving1stVertex listF tmp

        % search face having vertex number same to F(i, 1)
        F_backup(i, :) = 0;
        tmp(:, 1) = F_backup(:, 1) == F(i, 1);
        tmp(:, 2) = F_backup(:, 2) == F(i, 1);
        tmp(:, 3) = F_backup(:, 3) == F(i, 1);

        findFaceHaving1stVertex = find(tmp);
        findFaceHaving1stVertex(findFaceHaving1stVertex(:) > size(tmp, 1), :) = findFaceHaving1stVertex(findFaceHaving1stVertex(:) > size(tmp, 1), :) - size(tmp, 1);
        findFaceHaving1stVertex(findFaceHaving1stVertex(:) > size(tmp, 1), :) = findFaceHaving1stVertex(findFaceHaving1stVertex(:) > size(tmp, 1), :) - size(tmp, 1);

        listF = F(findFaceHaving1stVertex, :);
        for j = 1:size(findFaceHaving1stVertex, 1)
            if listF(j, 2) == F(i, 2) || listF(j, 3) == F(i, 2) || ...
                listF(j, 2) == F(i, 3) || listF(j, 3) == F(i, 3)
                F_pairs = [F_pairs; i, findFaceHaving1stVertex(j)];
                F_backup(j, :) = 0;
            end
        end
    end

    % find edge vectors
    EV(size(F_paris, 1), 3) = NaN;
    for i = 1:size(F_pairs, 1)
        EV(i, :) = cross(UV(F_pairs(i, 1), :), UV(F_pairs(i, 2), :));
    end

%     % plot
%     trisurf(F(:, :), V(:,1), V(:,2), V(:,3));
%     % trisurf(F(:, :), V(:,1), V(:,2), V(:,3), 'EdgeColor', 'none');
%     axis equal
%     hold on
%     plot3(C(:, 1), C(:, 2), C(:, 3), 'r.', 'markersize', 10); % centroids
%     NV = C + UV*5; % multiply for visualization
%     for i = 1:size(F, 1)
%         line = [C(i, :); NV(i, :)];
%         plot3(line(:, 1), line(:, 2), line(:, 3), 'r-'); % Norval vectors
%     end