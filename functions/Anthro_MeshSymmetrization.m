function [Vsymmeterized] = Anthro_MeshSymmetrization(V, Vpairs, idxCenterPts)
% Need a template model which is exactly symmetric, so that there are central points and pairs
% This code is not generalized, and only for this specific analysis.

    Vsymmeterized = V;
    Vsymmeterized(idxCenterPts, 1) = 0;
    for i = 1:size(Vpairs, 1)
        temp_pair1 = Vsymmeterized(Vpairs(i, 1), :);
        temp_pair2 = Vsymmeterized(Vpairs(i, 2), :);
        temp_pair_avg(1,1) = abs((temp_pair1(1)-temp_pair2(1))/2);
        temp_pair_avg(1,2) = mean([temp_pair1(2) temp_pair2(2)]);
        temp_pair_avg(1,3) = mean([temp_pair1(3) temp_pair2(3)]);
        if Vsymmeterized(Vpairs(i, 1), 1) > 0
            Vsymmeterized(Vpairs(i, 1), 1:3) = temp_pair_avg(1:3);
            Vsymmeterized(Vpairs(i, 2), 1:3) = [temp_pair_avg(1)*-1 temp_pair_avg(2:3)];
        else
            Vsymmeterized(Vpairs(i, 2), 1:3) = temp_pair_avg(1:3);
            Vsymmeterized(Vpairs(i, 1), 1:3) = [temp_pair_avg(1)*-1 temp_pair_avg(2:3)];
        end
    end
end