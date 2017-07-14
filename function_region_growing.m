function clust = function_region_growing(seed_point, points, sensitivity)
    cnt = 0;
    flag = 1;
    clust = [];
    previous_clust = seed_point;
    while (flag == 1)
        cnt = cnt + 1;
        new_clust = [];
        for i = 1:size(points, 1)
            for j = 1:size(previous_clust, 1)
                if norm(previous_clust(j, :) - points(i, :)) < sensitivity
                    new_clust = [new_clust; points(i, :)];
                    points(i, :) = 999;
                end
            end
        end
        previous_clust = new_clust;
        points(points(:, 1) == 999, :) = [];
        clust = [clust; new_clust];
        if ~isempty(new_clust)
            assert(~isempty(new_clust));
        else
            flag = 0;
        end
    end