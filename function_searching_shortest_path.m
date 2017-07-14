function curve = function_searching_shortest_path(V, F, points, loop, simplified, smooth, interval)

    % loop: 0, not closed curve
    %       1, closed curve
    
    % simplified: 0, not slimplified
    %             1, simplified with interval
    
    % smooth: 0, don't smoothing after slimplified
    %         1, smoothing after slimplified

    vertexPairList = [F(:, 1:2); F(:, 2:3); F(:, 1:2:3)];
    vertexPairList = unique(vertexPairList, 'rows', 'stable');
    vertexPairList = [vertexPairList; [vertexPairList(:, 2), vertexPairList(:, 1)]];
    
    % Euclidean distance
    vertexPairList(:, 3) = sqrt((V(vertexPairList(:, 1), 1) - V(vertexPairList(:, 2), 1)) .^2 + ...
                                (V(vertexPairList(:, 1), 2) - V(vertexPairList(:, 2), 2)) .^2 + ...
                                (V(vertexPairList(:, 1), 3) - V(vertexPairList(:, 2), 3)) .^2);
    sparsematrix = sparse(vertexPairList(:,1), vertexPairList(:,2), vertexPairList(:,3));
    
    % curvature
    numPts = size(points, 1);
    curveRaw = [];
    
    for i = 1:numPts-1
            curveRaw = [curveRaw; function_shortest_path(points(i, :), points(i+1, :), V, sparsematrix, 'Dijkstra')];
    end
        
    if loop == 0 % not closed curve        
    elseif loop == 1
        curveRaw = [curveRaw; function_shortest_path(points(end, :), points(1, :), V, sparsematrix, 'Dijkstra')];
    else
        error('LOOP shoould be 0 or 1');
    end
    
    for i = 1:size(curveRaw, 1)-1
        if curveRaw(i, 1) == curveRaw(i+1, 1)
            curveRaw(i+1, :) = 99999;
        end
    end
    curveRaw(curveRaw(:, 1) == 99999, :) = [];
    curveRaw = unique(curveRaw, 'rows', 'stable');
    
    if simplified == 0
        curve = curveRaw;
    elseif simplified == 1
        numPts = size(curveRaw, 1);
        simplifiedCurve(1, 1:3) = 0;
        for i = 1:(100/interval-1)
            cnt(i, 1) = round(numPts * (i*interval/100), 0);
            simplifiedCurve(i+1, :) = curveRaw(cnt(i,1), :);
        end
        simplifiedCurve((100/interval+1), :) = curveRaw(end, :);
        
        if smooth == 0 % don't smoothing
            curve = simplifiedCurve;
        elseif smooth == 1
            simplifiedCurveSmooth = cscvn(simplifiedCurve');
            curve = fnplt(simplifiedCurveSmooth);
            curve = curve';
        else
            error('SMOOTH shoould be 0 or 1');
        end
    else
        error('SIMPLIFIED shoould be 0 or 1');
    end