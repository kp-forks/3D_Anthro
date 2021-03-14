function [V, F] = Anthro_MeshCut_overXZplane(V, F, cutlineY)
    % cut over cutlineY value (when it is Y-up coordination)
    
    V(V(:,2) > cutlineY, :) = NaN;
    cutList = find(isnan(V(:,1)));
    keepList = find(~isnan(V(:,1)));
    
    V(isnan(V(:,1)), :) = [];
    F(ismember(F(:,1), cutList), :) = [];
    F(ismember(F(:,2), cutList), :) = [];
    F(ismember(F(:,3), cutList), :) = [];
    
    keepList(:,2) = [1:size(keepList, 1)];
    for i = 1:size(keepList, 1)
        F(F(:,1) == keepList(i, 1), 1) = keepList(i,2);
        F(F(:,2) == keepList(i, 1), 2) = keepList(i,2);
        F(F(:,3) == keepList(i, 1), 3) = keepList(i,2);
    end
    
%     [~, xA, xB] = intersect(F(:,1), keepList(:,1), 'stable');
%     F(xA, 1) = keepList(xB, 2);
% 
%     [~, yA, yB] = intersect(F(:,2), keepList(:,1), 'stable');
%     F(yA, 2) = keepList(yB, 2);
% 
%     [~, zA, zB] = intersect(F(:,3), keepList(:,1), 'stable');
%     F(zA, 3) = keepList(zB, 2);
%     
%     while ~isempty(xA) || ~isempty(yA) || ~isempty(zA)
%         [~, xA, xB] = intersect(F(:,1), keepList(:,1), 'stable');
%         F(xA, 1) = keepList(xB, 2);
% 
%         [~, yA, yB] = intersect(F(:,2), keepList(:,1), 'stable');
%         F(yA, 2) = keepList(yB, 2);
% 
%         [~, zA, zB] = intersect(F(:,3), keepList(:,1), 'stable');
%         F(zA, 3) = keepList(zB, 2);
%     end
end